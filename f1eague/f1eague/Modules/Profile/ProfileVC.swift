//
//  ProfileVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.12.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    var newImgURL: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.getDataFromFirestore()
        })
        // Do any additional setup after loading the view.
    }
    
    func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgProfilePic.image = info[.originalImage] as? UIImage
        imageSave()
        self.dismiss(animated: true )
    }
    
    func imageSave() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("userPhoto")
        if let data = imgProfilePic.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpeg")
            imageRef.putData(data) { metaData, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                } else {
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            self.newImgURL = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").addSnapshotListener { snapshot, error in
                                if error != nil {
                                    print("Error")
                                } else {
                                    if snapshot?.isEmpty != true && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let update = ["photo" : self.newImgURL]
                                            document.reference.updateData(update)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnEditProfilePic(_ sender: Any) {
        chooseImage()
    }
    
    func getDataFromFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("users").whereField("email", isEqualTo: Auth.auth().currentUser!.email ?? "").addSnapshotListener { snapshot, error in
            if error != nil {
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            self.lblUsername.text = username
                        }
                        if let name = document.get("nameSurname") as? String {
                            self.lblName.text = name
                        }
                        if let email = document.get("email") as? String {
                            self.lblEmail.text = email
                        }
                        if let points = document.get("point") as? Int {
                            self.lblPoints.text = String(points)
                        }
                        if let pic = document.get("photo") as? String {
                            self.imgProfilePic.sd_setImage(with: URL(string: pic))
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}
