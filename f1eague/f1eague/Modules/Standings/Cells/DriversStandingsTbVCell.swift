//
//  DriversStandingsTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import UIKit

class DriversStandingsTbVCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblStanding: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblConstructorName: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    
    // MARK: - Actions
    
    func setResults(with model: DriverStanding) {
        let driverName = model.driver?.givenName ?? ""
        let driverSurname = model.driver?.familyName ?? ""
        lblDriverName.text = driverName + " " + driverSurname
        
        let finishingPlace = model.position ?? ""
        lblStanding.text = finishingPlace
        
        let constructorName = model.constructors?.first?.name ?? ""
        lblConstructorName.text = constructorName
        
        let point = (model.points ?? "0") + " PTS"
        lblPoint.text = point
        
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblPoint.text = nil
        lblStanding.text = nil
        lblDriverName.text = nil
        lblConstructorName.text = nil
    }
}
