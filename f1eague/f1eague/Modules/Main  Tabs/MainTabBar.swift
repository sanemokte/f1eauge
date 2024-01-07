//
//  MainTabBar.swift
//  f1eague
//
//  Created by Sanem Ökte on 7.01.2024.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let tabAppearance = UITabBarAppearance()
            
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundImage = UIImage()
            tabAppearance.backgroundColor = UIColor.red
            
            tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
            
            tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
            tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
            
            UITabBar.appearance().standardAppearance = tabAppearance
            
            if #available(iOS 15, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabAppearance
            }
            
            setNeedsStatusBarAppearanceUpdate()
            
            tabBarController?.tabBar.tintColor = .white
            tabBarController?.tabBar.barTintColor = UIColor.systemRed
            tabBarController?.tabBar.isTranslucent = false
            
        } else {
            // Handle older versions prior to iOS 13.0
            tabBarController?.tabBar.tintColor = .white
            tabBarController?.tabBar.barTintColor = UIColor.systemRed
            tabBarController?.tabBar.isTranslucent = false
            
        }
    }

}
