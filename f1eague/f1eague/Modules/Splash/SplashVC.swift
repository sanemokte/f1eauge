//
//  SplashVC.swift
//  f1eague
//
//  Created by Sanem Ökte on 22.11.2023.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showLoginVC()
        }
    }

    
     // MARK: - Navigation
    private func showLoginVC() {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar")
        present(storyboard, animated: true)
//        let loginVC = LoginVC.loadFromNib()
//        loginVC.modalPresentationStyle = .fullScreen
//        present(loginVC, animated: true)
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
