//
//  LoginVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.12.2023.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: Any) {
        if tfEmail.text != "" && tfPassword.text != "" {
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                } else {
                    self.showProfileVC()
                }
            }
        } else {
            makeAlert(title: "Error!", message: "Email and Password can not be empty!")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
//        showSignupVC()
        showRaceResultVC()
    }
    
    func makeAlert (title: String, message: String) {
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
    
    private func showRaceResultVC() {
        let raceResultVC = RaceResultVC.loadFromNib()
        raceResultVC.modalPresentationStyle = .fullScreen
        present(raceResultVC, animated: true)
    }
    
    private func showSignupVC() {
        let signupVC = SignupVC.loadFromNib()
        signupVC.modalPresentationStyle = .fullScreen
        present(signupVC, animated: true)
    }
}
