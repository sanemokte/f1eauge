//
//  RaceResultVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 23.12.2023.
//

import UIKit
import Firebase

class RaceResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gridNo: Int?
    var driverName: String?
    var constructorName: String?
    var constructorLogoUrl: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("raceResult").order(by: "gridNo", descending: false).addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let driver = document.get("driver") as? String {
                            self.driverName = driver
                        }
                        if let constructor = document.get("constructor") as? String {
                            self.constructorName = constructor
                        }
                        if let grid = document.get("gridNo") as? Int {
                            self.gridNo = grid
                        }
                        if let logo = document.get("logo") as? String {
                            self.constructorLogoUrl = logo
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RaceResultTbVCell", for: indexPath)
//        cell.initialize(
//            logoUrl: constructorLogoUrl ?? "",
//            constructor: constructorName ?? "",
//            driver: driverName ?? "",
//            grid: gridNo ?? -1
//        )
        return cell
    }
    
}
