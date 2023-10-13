//
//  TableViewCell.swift
//  WidgetPractice01
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import UIKit
import SDWebImage

class TableViewCell: UICollectionViewCell {

    @IBOutlet weak var imageToShow: UIImageView!
    
    func renderCell(render with: AllDetails){
        imageToShow.layer.cornerRadius = 15
        self.contentView.backgroundColor = .systemGray4
        self.contentView.layer.cornerRadius = 15
        guard let url = with.imageUrl else{
            return
        }
        imageToShow.sd_setImage(with: url)
    }
    
}
