//
//  Global.swift
//  f1eague
//
//  Created by Sanem Ökte on 5.01.2024.
//

import UIKit
/// Holds device width
var deviceWidth = 0
/// Holds device height
var deviceHeight = 0

/// Basic delay function based on async after.
func delay(_ seconds: Double, fn: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(seconds * 1000.0)), execute: fn)
}

/**
  Sets device bounds and make them ready for usage anytime.
 
 - Parameters: Device width
 - Parameters: Device height
 */
func setDeviceBounds(_ width: Int, height: Int) {
    deviceWidth = width
    deviceHeight = height
}

/**
 Gets device width
 
 - Returns: CGFLoat
 */
func getWidth() -> CGFloat {
    return CGFloat(deviceWidth)
}

/**
 Gets device height
 
 - Returns: CGFLoat
 */
func getHeight() -> CGFloat {
    return CGFloat(deviceHeight)
}


func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow
    } else {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}


func makeYearsArray(from startYear: Int) -> [String] {
    var years: [String] = []
    let currentYear = Calendar.current.component(.year, from: Date())
    for year in startYear...currentYear {
        years.append(String(year))
    }
    years.removeLast()
    return years.reversed()
}
