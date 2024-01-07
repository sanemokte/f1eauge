//
//  SplashVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.11.2023.
//

import UIKit
import FirebaseAuth

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.checkLogin()
        }
    }
}

extension SplashVC {
    func checkLogin() {
        if Auth.auth().currentUser == nil {
            showLogin()
        } else {
            showMainPage()
        }
    }
    
    private func showLogin() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        sceneDelegate.setRoot(viewController: loginVC)
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
}

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
