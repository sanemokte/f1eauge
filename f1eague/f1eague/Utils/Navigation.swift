//
//  Navigation.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import UIKit

struct Navigation {
    // MARK: - Methods
    /// Sets root scene.
    static func setRootVC(root: UIViewController, animation: Bool = false) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.setRoot(viewController: root)
    }
}
