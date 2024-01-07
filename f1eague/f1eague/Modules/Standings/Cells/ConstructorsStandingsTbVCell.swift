//
//  ConstructorsStandingsTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import UIKit

class ConstructorsStandingsTbVCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var lblStanding: UILabel!
    @IBOutlet weak var lblNationality: UILabel!
    @IBOutlet weak var lblConstructorName: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    
    
    // MARK: - Actions

    func setResults(with model: ConstructorStanding) {
        let nationality = model.constructor?.nationality ?? ""
        lblNationality.text = nationality

        let finishingPlace = model.position ?? ""
        lblStanding.text = finishingPlace

        let constructorName = model.constructor?.name ?? ""
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
        lblNationality.text = nil
        lblConstructorName.text = nil
    }
    
}
