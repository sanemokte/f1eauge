//
//  Loading.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import UIKit

/// Loading class is a simple loader which will be used while service returns a value.
open class Loading: UIView {
    /// Custom superview
    fileprivate static weak var customSuperview: UIView?
    /// Loading view will be used as transparent background
    let loadingView = UIView()
    let label = UILabel()
    /// An activity indicator to show user the app has no crash or freeze sitution.
    let actInd = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    /// Loading Singleton
    open class var shared: Loading {
        /// Singleton struct
        struct Singleton {
            /// Loading instance has the same frame with device screen
            static let instance = Loading(frame: CGRect(x: 0, y: 0, width: getWidth(), height: getHeight()))
        }
        return Singleton.instance
    }
    
    // InitX
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.alpha = 0.0
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.6
        addSubview(loadingView)
        actInd.center = loadingView.center
        actInd.startAnimating()
        actInd.color = .white
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 2
        addSubview(actInd)
        addSubview(label)
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Shows Loading view
     
     - Returns: None.
     */
    open class func show(_ message: String = "") {
        DispatchQueue.main.async {
            guard let window = getKeyWindow() else { return }
            window.addSubview(Loading.shared)
            Loading.shared.label.text = message
            Loading.shared.label.sizeToFit()
            Loading.shared.label.center = Loading.shared.actInd.center
            let actY = Loading.shared.actInd.frame.origin.y
            let actH = Loading.shared.actInd.frame.height
            let lblY = actY + actH + 10
            Loading.shared.label.frame.origin.y = lblY
        }
    }
    
    /**
     Hides Loading view
     
     - Returns: None.
     */
    open class func hide() {
        DispatchQueue.main.async {
            Loading.shared.removeFromSuperview()
            Loading.shared.label.text = ""
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("fataaal error coder fln")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let containerView = Loading.containerView() {
            Loading.shared.frame = containerView.bounds
            loadingView.frame = containerView.frame
            actInd.center = containerView.center
        }
    }
    
    /**
     Custom view / Key window
     
     - Returns: UIView
     */
    fileprivate static func containerView() -> UIView? {
        return customSuperview ?? getKeyWindow()
    }
}
