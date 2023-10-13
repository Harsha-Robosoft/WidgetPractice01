//
//  ViewController.swift
//  WidgetPractice01
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView01: UICollectionView!
    
    var resultdata = [AllDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView01.delegate = self
        collectionView01.dataSource = self
        callTheAPi()
    }
    
    private func callTheAPi(){
        print("api calling")
        AF.request("https://api.themoviedb.org/3/trending/all/day?api_key=f393d52a4b88513749207fa6a234dda9").response(completionHandler: { [weak self] response in
            if let data = response.data {
                   do {
                       print("getting data from api")
                       let resultData = try JSONDecoder().decode(ResultData.self, from: data)
                       self?.resultdata = resultData.results
                       self?.collectionView01.reloadData()
                       print("data stored")
                   } catch {
                       print("catch error")
                       print("Error decoding JSON: \(error)")
                   }
               }
        })
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let render = resultdata[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TableViewCell else{
            return UICollectionViewCell()
        }
        cell.renderCell(render: render)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: (collectionView.frame.height) / 2.5)
    }
    
}

//"https://image.tmdb.org/t/p/w500\(poster_path)"



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
