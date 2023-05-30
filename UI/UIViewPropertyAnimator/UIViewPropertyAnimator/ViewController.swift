//
//  ViewController.swift
//  UIViewPropertyAnimator
//
//  Created by Yongseok Choi on 2023/05/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = SupportingMethods.shared // To make notiView frame.
    }
    
    @IBAction func StartAnimator(_ sender: UIButton) {
        SupportingMethods.shared.showNotiAlert()
    }
    
    @IBAction func newVC(_ sender: UIButton) {
        if let storyboard = self.storyboard, let vc = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
            vc.modalPresentationStyle = .fullScreen
            vc.view.backgroundColor = .yellow
            
            self.present(vc, animated: true)
        }
    }
}

extension ViewController {
    
}

// MARK: Shadow
extension CALayer {
    func useSketchShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.shadowPath = nil
            
        } else {
            let dx = -spread
            let rect = self.bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func useSketchShadow(color: UIColor, alpha: Float, shadowSize: CGFloat, viewSize: CGSize) {
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: viewSize.width + shadowSize,
                                                   height: viewSize.height + shadowSize))
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowOpacity = alpha
        self.shadowPath = shadowPath.cgPath
    }
}

extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}

