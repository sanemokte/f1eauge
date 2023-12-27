//
//  SignupVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.12.2023.
//

import UIKit
import Firebase

class SignupVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfNameSurname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        if tfEmail.text != "" && tfPassword.text != "" {
            
            Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                } else {
                    self.storeSignupData()
                }
            }
        } else {
            makeAlert(title: "Error!", message: "Email and Password can not be empty!")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    private func showProfileVC() {
        let profileVC = ProfileVC.loadFromNib()
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true)
    }
    
    private func storeSignupData() {
        let firestoreDatabase = Firestore.firestore()
        var firestoreRef: DocumentReference?
        let firestoreUser = ["email" : tfEmail.text ?? "", "nameSurname" : tfNameSurname.text ?? "", "username" : tfUsername.text ?? "", "photo" : "", "point" : 0] as [String : Any]
        firestoreRef = firestoreDatabase.collection("users").addDocument(data: firestoreUser, completion: { error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
            }else {
                self.showProfileVC()
            }
        })
    }
    
}
