//
//  SupportingMethods.swift
//  UIViewPropertyAnimator
//
//  Created by Yongseok Choi on 2023/05/30.
//

import UIKit

class SupportingMethods {
    static weak var keyWindow: UIWindow!
    
    private lazy var notiBaseView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var notiView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 16
        view.layer.useSketchShadow(color: .black, alpha: 0.15, x: 0, y: 4, blur: 8, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var notiImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var notiTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "alert noti"
        label.textColor = .useRGB(red: 66, green: 66, blue: 66)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notiButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(notiButton(_:)), for: .touchUpInside)
        button.setTitle("더보기", for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var notiButtonAction: (() -> ())?
    
    private var showNotiAnimator: UIViewPropertyAnimator?
        
    private var notiViewBottomAnchor: NSLayoutConstraint!
    
    static let shared = SupportingMethods()
    
    var count = 0
    
    private init() {
        self.initializeAlertNoti()
    }
    
    // MARK: Alert Notification
    func initializeAlertNoti() {
        let window: UIWindow! = SupportingMethods.keyWindow
        
        self.addSubviews([
            self.notiBaseView
        ], to: window)
        
        self.addSubviews([
            self.notiView
        ], to: self.notiBaseView)
        
        self.addSubviews([
            self.notiImageView,
            self.notiTitleLabel,
            self.notiButton
        ], to: self.notiView)
        
        // notiBaseView
        NSLayoutConstraint.activate([
            self.notiBaseView.topAnchor.constraint(equalTo: window.topAnchor),
            self.notiBaseView.heightAnchor.constraint(equalToConstant: 150),
            self.notiBaseView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            self.notiBaseView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        self.notiViewBottomAnchor = self.notiView.bottomAnchor.constraint(equalTo: self.notiBaseView.topAnchor)
        NSLayoutConstraint.activate([
            self.notiViewBottomAnchor,
            self.notiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            self.notiView.leadingAnchor.constraint(equalTo: self.notiBaseView.leadingAnchor, constant: 16),
            self.notiView.trailingAnchor.constraint(equalTo: self.notiBaseView.trailingAnchor, constant: -16)
        ])
        
        // notiImageView
        NSLayoutConstraint.activate([
            self.notiImageView.centerYAnchor.constraint(equalTo: self.notiView.centerYAnchor),
            self.notiImageView.heightAnchor.constraint(equalToConstant: 24),
            self.notiImageView.leadingAnchor.constraint(equalTo: self.notiView.leadingAnchor, constant: 16),
            self.notiImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        // notiTitleLabel
        NSLayoutConstraint.activate([
            self.notiTitleLabel.topAnchor.constraint(equalTo: self.notiView.topAnchor, constant: 18.5),
            self.notiTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            self.notiTitleLabel.bottomAnchor.constraint(equalTo: self.notiView.bottomAnchor, constant: -18.5),
            self.notiTitleLabel.leadingAnchor.constraint(equalTo: self.notiImageView.trailingAnchor, constant: 8),
            self.notiTitleLabel.trailingAnchor.constraint(equalTo: self.notiButton.leadingAnchor, constant: -4)
        ])
        
        // notiButton
        NSLayoutConstraint.activate([
            self.notiButton.centerYAnchor.constraint(equalTo: self.notiView.centerYAnchor),
            self.notiButton.trailingAnchor.constraint(equalTo: self.notiView.trailingAnchor, constant: -16),
        ])
    }


    func addSubviews(_ views: [UIView], to: UIView) {
        for view in views {
            to.addSubview(view)
        }
    }
    
    func showNotiAlert(notiButtonAction: (() -> ())? = nil) {
        self.count += 1
        SupportingMethods.keyWindow.bringSubviewToFront(self.notiBaseView)
        self.notiTitleLabel.text = "테스트 입니다: \(self.count)"
        self.notiButtonAction = notiButtonAction
        self.notiButton.isHidden = notiButtonAction == nil

        self.showNotiAnimator?.stopAnimation(false)
        self.showNotiAnimator?.finishAnimation(at: .end)
        
        if self.showNotiAnimator == nil || self.showNotiAnimator?.state == .inactive {
            self.notiBaseView.isHidden = false
            print("self.notiView.frame.height: \(self.notiView.frame.height)")
            self.showNotiAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.6, animations: {
                self.notiViewBottomAnchor.constant = SupportingMethods.keyWindow.safeAreaInsets.top + 8 + self.notiView.frame.height
                self.notiBaseView.layoutIfNeeded()
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
                    self.hideNotiAlert()

                @unknown default:
                    fatalError()
                }
            })
            
            self.showNotiAnimator?.startAnimation()
        }
    }
    
    func hideNotiAlert() {
        print("close")
        self.showNotiAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: {
            self.notiViewBottomAnchor.constant = 0
            self.notiBaseView.layoutIfNeeded()
        })
        self.showNotiAnimator?.addCompletion({ position in
            switch position {
            case .start:
                print("second position start")

            case .current:
                print("second position current")

            case .end:
                print("second position end")
                self.notiBaseView.isHidden = true

            @unknown default:
                fatalError()
            }
        })
        self.showNotiAnimator?.startAnimation(afterDelay: 3.0)
    }
    
    @objc func notiButton(_ sender: UIButton) {
        if let action = self.notiButtonAction {
            action()
            
            self.notiButtonAction = nil
        }
    }
}
