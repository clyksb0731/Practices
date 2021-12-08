//
//  ViewController.swift
//  PagingSample
//
//  Created by Yongseok Choi on 2021/12/08.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var recessTimeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 120, green: 223, blue: 238)
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var addRecessButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addButtonImagge"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var recessButtonViewLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "휴가"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var workTimeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 125, green: 243, blue: 110)
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var addWorkButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addButtonImagge"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var workButtonViewLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "근무"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
}

// MARK: - Extension for Essential Methods
extension ViewController {
    func setSubviews() {
        
    }
    
    func setLayouts() {
        
    }
}

// MARK: - Extension for Methods Added
extension ViewController {
    func addSubviews(_ views: [UIView], to: UIView) {
        for view in views {
            to.addSubview(view)
        }
    }
}

// MARK: - Extension for UIScrollDelegate
extension ViewController: UIScrollViewDelegate {
    
}

// MARK: - Extension for UIColor
extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}

// MARK: - Extension for CALayer
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
}
