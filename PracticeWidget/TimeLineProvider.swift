//
//  TimeLineProvider.swift
//  PracticeWidgetExtension
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import Foundation
import WidgetKit
import Intents

struct Provider: TimelineProvider {
    // Define a target date for your update (11:59 PM)
        let targetDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Date()) ?? Date()

        // Check if the current date is before the target date
        if Date() < targetDate {
            // If it's before the target date, schedule the update for the target date
            let nextUpdate = Timeline(entries: [SimpleEntry(date: targetDate, resultData: nil)], policy: .after(targetDate))
            completion(nextUpdate)
        } else {
            // If it's after the target date, schedule the update for the next day
            let nextUpdate = Timeline(entries: [SimpleEntry(date: Calendar.current.date(byAdding: .day, value: 1, to: targetDate) ?? Date(), resultData: nil], policy: .at(targetDate))
            completion(nextUpdate)
        }
        
        // Now, call your fetchDataAgain function
        fetchDataAgain(with: "all") { simpleEntry in
            let timeline = Timeline(entries: [simpleEntry], policy: .never)
            completion(timeline)
        }

    func fetchDataFromApi(with: String, completion: @escaping ((SimpleEntry) -> Void)) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                completion(SimpleEntry(date: Date(), resultData: resultData.results))
            } catch {
                completion(SimpleEntry(date: Date(), resultData: nil))
            }
        }
        task.resume()
    }
                                                
    @objc func fetchDataAndRefresh() {
                
                
                
                
    }

    func fetchDataAgain(with: String, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: Array(resultData.results))], policy: .never))
            } catch {
                completion(Timeline(entries: [SimpleEntry(date: Date(), resultData: nil)], policy: .never))
            }
        }
        task.resume()
    }
}
