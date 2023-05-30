//
//  SupportingMethods.swift
//  UIViewPropertyAnimator
//
//  Created by Yongseok Choi on 2023/05/30.
//

import UIKit

class SupportingMethods {
    static weak var keyWindow: UIWindow!
    
    private var notiView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 16
        view.layer.useSketchShadow(color: .black, alpha: 0.15, x: 0, y: 4, blur: 8, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var notiImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var notiTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "alert noti"
        label.textColor = .useRGB(red: 66, green: 66, blue: 66)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var showNotiAnimator: UIViewPropertyAnimator?
        
    private var notiViewBottomAnchor: NSLayoutConstraint!
    
    static let shared = SupportingMethods()
    
    var count = 1
    
    private init() {
        self.initializeAlertNoti()
    }
    
    // MARK: Alert Notification
    func initializeAlertNoti() {
        let window: UIWindow! = SupportingMethods.keyWindow
        
        self.addSubviews([
            self.notiView
        ], to: window)
        
        self.addSubviews([
            self.notiImageView,
            self.notiTitleLabel
        ], to: self.notiView)
        
        self.notiViewBottomAnchor = self.notiView.bottomAnchor.constraint(equalTo: window.topAnchor)
        NSLayoutConstraint.activate([
            self.notiViewBottomAnchor,
            self.notiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            self.notiView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16),
            self.notiView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -16)
        ])
        
        // notiImageView
        NSLayoutConstraint.activate([
            self.notiImageView.centerYAnchor.constraint(equalTo: notiView.centerYAnchor),
            self.notiImageView.heightAnchor.constraint(equalToConstant: 24),
            self.notiImageView.leadingAnchor.constraint(equalTo: notiView.leadingAnchor, constant: 16),
            self.notiImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        // notiTitleLabel
        NSLayoutConstraint.activate([
            self.notiTitleLabel.topAnchor.constraint(equalTo: notiView.topAnchor, constant: 18.5),
            self.notiTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            self.notiTitleLabel.bottomAnchor.constraint(equalTo: notiView.bottomAnchor, constant: -18.5),
            self.notiTitleLabel.leadingAnchor.constraint(equalTo: notiImageView.trailingAnchor, constant: 8),
            self.notiTitleLabel.trailingAnchor.constraint(equalTo: notiView.trailingAnchor, constant: -16)
        ])
    }


    func addSubviews(_ views: [UIView], to: UIView) {
        for view in views {
            to.addSubview(view)
        }
    }
    
    func start() {
        self.count += 1
        SupportingMethods.keyWindow.bringSubviewToFront(self.notiView)
        self.notiTitleLabel.text = "테스트 입니다. \(self.count)"

        self.showNotiAnimator?.stopAnimation(false)
        self.showNotiAnimator?.finishAnimation(at: .end)
        
        if self.showNotiAnimator == nil || self.showNotiAnimator?.state == .inactive {
            print("self.notiView.frame.height: \(self.notiView.frame.height)")
            self.showNotiAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
                self.notiViewBottomAnchor.constant = SupportingMethods.keyWindow.safeAreaInsets.top + 8 + self.notiView.frame.height
                SupportingMethods.keyWindow.layoutIfNeeded()
            })
            
            self.showNotiAnimator?.addCompletion({ position in
                switch position {
                case .start:
                    print("position start")
                    self.showNotiAnimator = nil

                case .current:
                    print("position current")

                case .end:
                    print("position end")
                    self.close()

                @unknown default:
                    fatalError()
                }
            })
            
            self.showNotiAnimator?.startAnimation()
        }
    }
    
    func close() {
        self.showNotiAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn, animations: {
            self.notiViewBottomAnchor.constant = 0
            SupportingMethods.keyWindow.layoutIfNeeded()
        })
        self.showNotiAnimator?.startAnimation(afterDelay: 3.0)
    }
}

