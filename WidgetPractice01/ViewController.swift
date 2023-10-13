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
        NetworkManager.networkCall(with: "all", completion: { [weak self] result in
            switch result{
            case .success(let data):
                self?.resultdata = data
                DispatchQueue.main.async {
                    self?.collectionView01.reloadData()
                }
            case .failure(let error):
                print(error)
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
