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
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 75)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
    
    var addRecessTimeButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var recessTimeButtonViewLabel: UILabel = {
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
    
    lazy var recessTimeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(recessTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var workTimeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 125, green: 243, blue: 110)
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var addWorkTimeButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var workTimeButtonViewLabel: UILabel = {
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
    
    lazy var workTimeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(workTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 2
        pageControl.addTarget(self, action: #selector(pageControl(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    var previousPointX: CGFloat = 0
    var isHaptic: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setSubviews()
        self.setLayouts()
    }
}

// MARK: - Extension for Essential Methods
extension ViewController {
    func setSubviews() {
        self.addSubviews([
            self.scrollView,
            self.pageControl
        ], to: self.view)
        
        self.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        self.addSubviews([
            self.recessTimeButtonView,
            self.workTimeButtonView
        ], to: self.contentView)
        
        self.addSubviews([
            self.addRecessTimeButtonImageView,
            self.recessTimeButtonViewLabel,
            self.recessTimeButton
        ], to: self.recessTimeButtonView)
        
        self.addSubviews([
            self.addWorkTimeButtonImageView,
            self.workTimeButtonViewLabel,
            self.workTimeButton
        ], to: self.workTimeButtonView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.scrollView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor, constant: -10),
            self.scrollView.heightAnchor.constraint(equalToConstant: 75),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Page control layout
        NSLayoutConstraint.activate([
            self.pageControl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -17),
            self.pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalToConstant: self.scrollView.contentSize.width)
        ])
        
        let pageWidth = UIScreen.main.bounds.width
        
        // Recess time button view layout
        NSLayoutConstraint.activate([
            self.recessTimeButtonView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.recessTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.recessTimeButtonView.centerXAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: pageWidth/2),
            self.recessTimeButtonView.widthAnchor.constraint(equalToConstant: pageWidth - 88)
        ])
        
        // Add recess time button image view layout
        NSLayoutConstraint.activate([
            self.addRecessTimeButtonImageView.centerYAnchor.constraint(equalTo: self.recessTimeButtonView.centerYAnchor),
            self.addRecessTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addRecessTimeButtonImageView.centerXAnchor.constraint(equalTo: self.recessTimeButtonView.centerXAnchor),
            self.addRecessTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Recess time button view label layout
        NSLayoutConstraint.activate([
            self.recessTimeButtonViewLabel.centerYAnchor.constraint(equalTo: self.recessTimeButtonView.centerYAnchor),
            self.recessTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            self.recessTimeButtonViewLabel.centerXAnchor.constraint(equalTo: self.recessTimeButtonView.trailingAnchor, constant: -((pageWidth-88)/4)),
            self.recessTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Recess time button layout
        NSLayoutConstraint.activate([
            self.recessTimeButton.topAnchor.constraint(equalTo: self.recessTimeButtonView.topAnchor),
            self.recessTimeButton.bottomAnchor.constraint(equalTo: self.recessTimeButtonView.bottomAnchor),
            self.recessTimeButton.leadingAnchor.constraint(equalTo: self.recessTimeButtonView.leadingAnchor),
            self.recessTimeButton.trailingAnchor.constraint(equalTo: self.recessTimeButtonView.trailingAnchor)
        ])
        
        // Work time button view layout
        NSLayoutConstraint.activate([
            self.workTimeButtonView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.workTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.workTimeButtonView.centerXAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -(pageWidth/2)),
            self.workTimeButtonView.widthAnchor.constraint(equalToConstant: pageWidth - 88)
        ])
        
        // Add work time button image view layout
        NSLayoutConstraint.activate([
            self.addWorkTimeButtonImageView.centerYAnchor.constraint(equalTo: self.workTimeButtonView.centerYAnchor),
            self.addWorkTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addWorkTimeButtonImageView.centerXAnchor.constraint(equalTo: self.workTimeButtonView.centerXAnchor),
            self.addWorkTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Work time button view label layout
        NSLayoutConstraint.activate([
            self.workTimeButtonViewLabel.centerYAnchor.constraint(equalTo: self.workTimeButtonView.centerYAnchor),
            self.workTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            self.workTimeButtonViewLabel.centerXAnchor.constraint(equalTo: self.workTimeButtonView.trailingAnchor, constant: -((pageWidth-88)/4)),
            self.workTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Work time button layout
        NSLayoutConstraint.activate([
            self.workTimeButton.topAnchor.constraint(equalTo: self.workTimeButtonView.topAnchor),
            self.workTimeButton.bottomAnchor.constraint(equalTo: self.workTimeButtonView.bottomAnchor),
            self.workTimeButton.leadingAnchor.constraint(equalTo: self.workTimeButtonView.leadingAnchor),
            self.workTimeButton.trailingAnchor.constraint(equalTo: self.workTimeButtonView.trailingAnchor)
        ])
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

// MARK: - Extension for Selector Methods
extension ViewController {
    @objc func recessTimeButton(_ sender: UIButton) {
        print("Recess Time Button touched")
    }
    
    @objc func workTimeButton(_ sender: UIButton) {
        print("Work Time Button touched")
    }
    
    @objc func pageControl(_ sender: UIPageControl) {
        if sender.currentPage == 0 {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        if sender.currentPage == 1 {
            self.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
        }
    }
}

// MARK: - Extension for UIScrollDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll: \(scrollView.contentOffset.x)")
        
        let centerXPoint: CGFloat = scrollView.frame.width / 2
        print("CneterXPoint: \(centerXPoint)")
        
        if self.previousPointX >= 0 && self.previousPointX < centerXPoint {
            if scrollView.contentOffset.x >= centerXPoint {
                if !self.isHaptic {
                    UIDevice.softHaptic()
                    self.isHaptic = true
                }
                
                self.pageControl.currentPage = 1
                
            } else {
                self.isHaptic = false
                
                self.pageControl.currentPage = 0
            }
            
        } else {
            if scrollView.contentOffset.x < centerXPoint {
                if !self.isHaptic {
                    UIDevice.softHaptic()
                    self.isHaptic = true
                }
                
                self.pageControl.currentPage = 0
                
            } else {
                self.isHaptic = false
                
                self.pageControl.currentPage = 1
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating: \(scrollView.contentOffset.x)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating: \(scrollView.contentOffset.x)")
        
        self.isHaptic = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging: \(scrollView.contentOffset.x)")
        
        self.previousPointX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            print("scrollViewDidEndDragging willDecelerate: \(scrollView.contentOffset.x)")
            
        } else {
            print("scrollViewDidEndDragging willNotDecelerate: \(scrollView.contentOffset.x)")
        }
    }
}

// MARK: - Extension for UIDevice
extension UIDevice {
    // MARK: Make Haptic Effect
    static func softHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
    }
    
    static func lightHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
    
    static func heavyHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .heavy)
        haptic.impactOccurred()
    }
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
