//
//  SignupVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.12.2023.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class SignupVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfNameSurname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        tfPassword.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        tfUsername.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        tfNameSurname.attributedPlaceholder = NSAttributedString(
            string: "Name & Surname",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
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
    
    private func showMainPage() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let mainTabBar = UIStoryboard(
            name: "MainTabBar",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "MainTabBar"
        )
        sceneDelegate.setRoot(viewController: mainTabBar)
    }
    
    private func storeSignupData() {
        let firestoreDatabase = Firestore.firestore()
        var firestoreRef: DocumentReference?
        let firestoreUser = ["email" : tfEmail.text ?? "", "nameSurname" : tfNameSurname.text ?? "", "username" : tfUsername.text ?? "", "photo" : "", "point" : 0, "lastPrediction" : "", "lastPredictionRound" : ""] as [String : Any]
        firestoreRef = firestoreDatabase.collection("users").addDocument(data: firestoreUser, completion: { error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
            }else {
                self.showMainPage()
            }
        })
    }
    
}
