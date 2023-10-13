//
//  NetworkManager.swift
//  WidgetPractice01
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import Foundation
import Alamofire

final class NetworkManager{
    static let shared = NetworkManager()
    private init() { }
    
    static func networkCall(with: String, completion: @escaping (((Result<[AllDetails], Error>) -> Void))) {
        print("api calling")
        AF.request("https://api.themoviedb.org/3/trending/\(with)/day?api_key=f393d52a4b88513749207fa6a234dda9").response(completionHandler: { response in
            if let data = response.data {
                   do {
                       print("getting data from api")
                       let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                       completion(.success(resultData.results))
                       print("data stored")
                   } catch {
                       completion(.failure("failed" as! Error))
                       print("catch error")
                       print("Error decoding JSON: \(error)")
                   }
               }
        })
    }
}
