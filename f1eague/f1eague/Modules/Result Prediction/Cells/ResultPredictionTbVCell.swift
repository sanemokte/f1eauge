//
//  ResultPredictionTbVCell.swift
//  f1eague
//
//  Created by Sanem Ökte on 6.01.2024.
//

import UIKit

class ResultPredictionTbVCell: UITableViewCell {

    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var viewPointsSeperator: UIView!
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var viewCard: UIView!
    
    func setCell(index: Int, driverName: String, score: Int? = nil) {
        lblIndex.text = "\(index + 1)"
        if !driverName.isEmpty {
            lblDriverName.text = "\(driverName)"
        } else {
            lblDriverName.text = "Please Select a Driver"
        }
        
        lblScore.isHidden = score == nil
        viewPointsSeperator.isHidden = score == nil
        if let score {
            lblScore.text = "\(score) PTS"
            viewPointsSeperator.isHidden = false
        }
    }
    
    func setResult(index: Int, predictedDriver: String, driver: String) {
        lblIndex.text = "\(index + 1)"
        viewPointsSeperator.isHidden = true
        lblScore.isHidden = true
        if predictedDriver == driver {
            viewCard.backgroundColor = UIColor(red: 48/255, green: 203/255, blue: 0/255, alpha: 1)
        }
        
        if !predictedDriver.isEmpty {
            lblDriverName.text = "\(predictedDriver)"
        } else {
            lblDriverName.text = "Please Select a Driver"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDriverName.text = nil
        viewCard.backgroundColor = UIColor(red: 244/255, green: 0/255, blue: 0/255, alpha: 1)
    }
}
