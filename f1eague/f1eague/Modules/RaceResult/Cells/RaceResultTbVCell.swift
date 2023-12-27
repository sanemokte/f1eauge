//
//  RaceResultTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 24.12.2023.
//

import UIKit

class RaceResultTbVCell: UITableViewCell {

    @IBOutlet weak var lblFinishingPlace: UILabel!
    @IBOutlet weak var imgConstructor: UIImageView!
    @IBOutlet weak var lblDriver: UILabel!
    @IBOutlet weak var lblConstructor: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         
//         initialize()
    }
    
//    func setCell() {
//
//    }

//    func initialize(logoUrl: String,
//                    constructor: String,
//                    driver: String,
//                    grid: Int) {
//        
//        setCell()
//    }

}


struct RaceResultModel {
    var gridNo: Int?
    var constructorLogoUrl: String?
    var driverName: String?
    var constructorName: String?
}
