//
//  LoginVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.12.2023.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    override func viewDidLoad() {
        btnSignUp.layer.borderColor = UIColor.white.cgColor
        btnSignUp.layer.borderWidth = 2
        tfEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        tfPassword.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
        )
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func signIn(_ sender: Any) {
        if tfEmail.text != "" && tfPassword.text != "" {
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                } else {
                    self.showMainPage()
                }
            }
        } else {
            makeAlert(title: "Error!", message: "Email and Password can not be empty!")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        showSignupVC()
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
    
    private func showRaceResultVC() {
        let raceResultVC = RaceResultVC.loadFromNib()
        raceResultVC.modalPresentationStyle = .fullScreen
        present(raceResultVC, animated: true)
    }
    
    private func showSignupVC() {
        let signupVC = SignupVC.loadFromNib()
        signupVC.modalPresentationStyle = .formSheet
        present(signupVC, animated: true)
    }
}
