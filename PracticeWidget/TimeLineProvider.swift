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
        fetchDataFromApi(with: "all", date: Date(), completion: completion)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries = [SimpleEntry]()
        let dispatchGroup = DispatchGroup()
        let currentDate = Date()
        let calendar = Calendar.current
        // Calculate the date and time for the next 1 AM
        var futureDate = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: currentDate)!
        // If the next 1 AM is in the past, add one day to the futureDate
        if futureDate < currentDate {
            futureDate = calendar.date(byAdding: .day, value: 1, to: futureDate)!
        }
        for i in 0..<7 {
            dispatchGroup.enter()
            fetchDataFromApi(with: "all", date: futureDate) { result in
                entries.append(result)
                dispatchGroup.leave()
            }
            // Increment futureDate by one day for the next iteration
            futureDate = calendar.date(byAdding: .day, value: 1, to: futureDate)!
        }
        dispatchGroup.notify(queue: .main) {
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func fetchDataFromApi(with endpoint: String, date: Date, completion: @escaping (SimpleEntry) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        guard let apiKey = "f393d52a4b88513749207fa6a234dda9".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/trending/\(endpoint)/day?api_key=\(apiKey)&date=\(dateString)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                // Handle the error case here
                return
            }
            
            do {
                let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                completion(SimpleEntry(date: date, resultData: resultData.results))
            } catch {
                // Handle the parsing error here
                print("Catch error: \(error)")
                completion(SimpleEntry(date: date, resultData: nil))
            }
        }
        
        task.resume()
    }

}
