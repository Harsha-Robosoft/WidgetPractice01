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







struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        print("hi")
        return SimpleEntry(date: Date(), resultData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("hello")
        fetchDataFromApi(with: "all", completion: completion)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // Calculate the next 1 AM occurrence
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 1
        dateComponents.minute = 0
        let next1AM = calendar.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime)
        
        // Call fetchData with the 'all' parameter and provide a completion handler
        fetchDataAgain(with: "all") { resultData in
            if let resultData = resultData {
                completion(Timeline(entries: [SimpleEntry(date: now, resultData: resultData)], policy: .after(next1AM ?? now)))
            } else {
                // Handle the case where the API call fails
                completion(Timeline(entries: [SimpleEntry(date: now, resultData: nil)], policy: .after(next1AM ?? now)))
            }
        }
        
        // Print a message to indicate when the API call is scheduled
        print("API call scheduled for 1 AM")
    }
        
    func fetchDataAgain(with: String, completion: @escaping ([AllDetails]?) -> ()) {
        print("allenu aarama")
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, responce, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                debugPrint(resultData)
                completion(Array(resultData.results))
            } catch {
                completion(nil)
                print("API call failed at \(Date())")
            }
        })
        task.resume()
    }
    
        func fetchDataFromApi(with: String, completion: @escaping ((SimpleEntry) -> Void)){
            guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else{ return}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, responce, error in
                guard let data = data, error == nil else{
                    return
                }
                do {
                    let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                    debugPrint(resultData.results)
                    completion(SimpleEntry(date: Date(), resultData: resultData.results))
                } catch {
                    completion(SimpleEntry(date: Date(), resultData: nil))
                    print("catch error")
                }
            })
            task.resume()
        }
}



//    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
//        print("hiege ideera")
//        // Set the refresh date to one hour from now
//        let refreshDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
//
//        // Call fetchData with the 'all' parameter and provide a completion handler
//        fetchDataAgain(with: "all") { resultData in
//            if let resultData = resultData {
//                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: resultData)], policy: .after(refreshDate)))
//            } else {
//                // Handle the case where the API call fails
//                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: nil)], policy: .after(refreshDate)))
//            }
//        }
//        print("API call initiated at \(Date())")
//    }
