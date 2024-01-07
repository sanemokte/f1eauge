//
//  RaceScheduleTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import UIKit

class RaceScheduleTbVCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak private var imgRace: UIImageView!
    @IBOutlet weak private var lblRaceTitle: UILabel!
    @IBOutlet weak private var lblRaceDate: UILabel!
    @IBOutlet weak private var lblRacePlace: UILabel!
    @IBOutlet weak var stkCard: UIStackView!
    
    func set(with model: Race) {
        stkCard.layer.borderColor = UIColor.systemRed.cgColor
        stkCard.layer.borderWidth = 1
        
        lblRaceTitle.text = model.raceName ?? ""
        lblRacePlace.text = model.circuit?.circuitName ?? ""
        guard let date = model.date,
              let time = model.time else {
            lblRaceDate.text = "No time information found."
            return
        }
        
        let dateTime = date + " " + time
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy, HH:mm"
        
        guard let date = dateFormatterGet.date(from: dateTime) else { return }
        let dateText = dateFormatterPrint.string(from: date)
        lblRaceDate.text = dateText
    }
    
    func setResults(with model: RaceResult) {
        let title = model.driver?.givenName ?? ""
        lblRaceTitle.text = title
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblRaceTitle.text = nil
        lblRaceDate.text = nil
    }
}
