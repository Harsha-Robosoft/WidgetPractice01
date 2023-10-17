//
//  TimeLineProvider.swift
//  PracticeWidgetExtension
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import Foundation
import WidgetKit
import Intents
import SwiftUI

//struct Provider: TimelineProvider {
//
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), resultData: nil)
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        completion(SimpleEntry(date: Date(), resultData: nil))
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
//        fetchDataAgain(with: "all", completion: completion)
//    }
//
//    func fetchDataAgain(with: String, completion: @escaping (Timeline<SimpleEntry>) -> ()){
//        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else{ return}
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, responce, error in
//            guard let data = data, error == nil else{
//                return
//            }
//            do {
//                let resultData = try JSONDecoder().decode(ResultData.self, from: data)
//                debugPrint(resultData.results)
//                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: Array(resultData.results))], policy: .never))
//            } catch {
//                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: nil)], policy: .never))
//                print("catch error")
//            }
//        })
//        task.resume()
//    }
//
//}




struct SimpleEntry: TimelineEntry {
    let date: Date
    let images: [UIImage]?
}


struct Provider: TimelineProvider {
    
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), images: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), images: nil))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            guard let image = try? await DataFetcher.fetchMovieDetails() else {
                return
            }
            let currentDate = Date()
            let startOfDay = Calendar.current.startOfDay(for: currentDate)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            let entry = SimpleEntry(date: startOfDay, images: Array(image))
            let timeline = Timeline(entries: [entry],policy: .after(endOfDay))
            completion(timeline)
        }
    }
}

struct ResultData: Decodable {
    let results: [AllDetails]
}

struct AllDetails: Decodable {
    let backdrop_path: String
    let id: Int
    let title: String?
    let original_title: String?
    let name: String?
    let poster_path: String
    let media_type: String
    
    
    var imageUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")
    }
}


struct DataFetcher {
    
    enum DataFetcherError: Error {
        case imageDataCorrupted
    }

    private static var cachePath: URL {
        URL.cachesDirectory.appending(path: "dataImage.png")
    }

    static var cachedImages: UIImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return  nil
        }
        return UIImage(data: imageData)
    }

    static var cachedImageAvailable: Bool {
        cachedImages != nil
    }
    
    static func fetchMovieDetails() async throws -> [UIImage] {

        guard let url = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=f393d52a4b88513749207fa6a234dda9") else{
            throw DataFetcherError.imageDataCorrupted
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let detailsData = try JSONDecoder().decode(ResultData.self, from: data)
        
//        guard let imageURl = detailsData.results[0].imageUrl else { throw DataFetcherError.imageDataCorrupted}
//        let (imageData, _) = try await URLSession.shared.data(from: imageURl)
//
//        guard let image = UIImage(data: imageData) else {
//            throw DataFetcherError.imageDataCorrupted
//        }
//
//        // Spawn another task to cache the downloaded image
//        Task {
//            try? await cache(imageData)
//        }
        var imagesIs = [UIImage]()
        for i in 0..<min(3, detailsData.results.count) {
            if let imageUrl = detailsData.results[i].imageUrl {
                do {
                    let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
                    let image = UIImage(data: imageData)
                    if let image = image {
                        try? await DataFetcher.cache(imageData)
                        imagesIs.append(image)
                    }
                } catch {
                    throw DataFetcherError.imageDataCorrupted
                }
            }
        }
        return imagesIs
    }
    
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}
