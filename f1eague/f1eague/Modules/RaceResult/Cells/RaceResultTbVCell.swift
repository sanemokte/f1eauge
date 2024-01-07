//
//  RaceResultTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 24.12.2023.
//

import UIKit

class RaceResultTbVCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblFinishingPlace: UILabel!
    @IBOutlet weak var lblDriver: UILabel!
    @IBOutlet weak var imgConstructor: UIImageView!
    @IBOutlet weak var lblConstructor: UILabel!
    
    func setResults(with model: RaceResult) {
        let driverName = model.driver?.givenName ?? ""
        let driverSurname = model.driver?.familyName ?? ""
        lblDriver.text = driverName + " " + driverSurname
        
        let finishingPlace = model.position ?? ""
        lblFinishingPlace.text = finishingPlace
        
        let constructorName = model.constructor?.name ?? ""
        lblConstructor.text = constructorName
        
        if let image = UIImage(named: "\(constructorName)") {
            imgConstructor.image = image
        } else {
            imgConstructor.image = nil
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblFinishingPlace.text = nil
        lblDriver.text = nil
        lblConstructor.text = nil
        imgConstructor.image = nil
    }
    
}
