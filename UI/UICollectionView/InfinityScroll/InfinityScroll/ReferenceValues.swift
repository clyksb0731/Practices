//
//  ReferenceValues.swift
//  InfinityScroll
//
//  Created by Yongs Work on 2023/05/01.
//

import UIKit

struct ReferenceValues {
    static weak var keyWindow: UIWindow!
}

// MARK: - Extension of referenceValues
extension ReferenceValues {
    struct Size {
        struct Device {
            static let width: CGFloat = ReferenceValues.keyWindow.screen.bounds.width
            static let height: CGFloat = ReferenceValues.keyWindow.screen.bounds.height
        }
        
        struct SafeAreaInsets {
            static let top: CGFloat = ReferenceValues.keyWindow.safeAreaInsets.top
            static let bottom: CGFloat = ReferenceValues.keyWindow.safeAreaInsets.bottom
            static let left: CGFloat = ReferenceValues.keyWindow.safeAreaInsets.left
            static let right: CGFloat = ReferenceValues.keyWindow.safeAreaInsets.right
        }
    }
}

// MARK: UIColor to be possible to get color using 0 ~ 255 integer
extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}
