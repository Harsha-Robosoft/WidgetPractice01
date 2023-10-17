//
//  NetworkManager.swift
//  WidgetPractice01
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import Foundation
import Alamofire
import Combine

final class NetworkManager{
    static let shared = NetworkManager()
    private init() { }
    
//    static func networkCall(with: String, completion: @escaping (((Result<[AllDetails], Error>) -> Void))) {
//        print("api calling")
//        AF.request("https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9").response(completionHandler: { response in
//            if let data = response.data {
//                   do {
//                       print("getting data from api")
//                       let resultData = try JSONDecoder().decode(ResultData.self, from: data)
//                       completion(.success(resultData.results))
//                       print("data stored")
//                   } catch {
//                       completion(.failure("failed" as! Error))
//                       print("catch error")
//                       print("Error decoding JSON: \(error)")
//                   }
//               }
//        })
//    }
    
    
    static func networkCall(with: String) -> Future<[AllDetails], Error> {
        return Future{ promise in
            guard let url = URL(string: "https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9") else{
                promise(.failure(FailureCases.failedToFetch))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data, error == nil else{
                    promise(.failure(FailureCases.failedToFetch))
                    return
                }
                do {
                    let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                    promise(.success(resultData.results))
                } catch {
                    promise(.failure(FailureCases.failedToFetch))
                    print("catch error")
                }
            })
            task.resume()
        }
    }
    
    enum FailureCases: Error{
        case failedToFetch
    }
}
