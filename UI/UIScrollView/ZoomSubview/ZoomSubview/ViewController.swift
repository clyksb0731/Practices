//
//  ViewController.swift
//  ZoomSubview
//
//  Created by Yongseok Choi on 2023/04/16.
//

import UIKit

protocol EssentialViewMethods {
    func setViewFoundation()
    func initializeObjects()
    func setDelegates()
    func setGestures()
    func setNotificationCenters()
    func setSubviews()
    func setLayouts()
}

class ViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        scrollView.bouncesZoom = false
        scrollView.backgroundColor = .yellow
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var zoomBackgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "zoomBackground"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    lazy var button1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "zoomButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(button1(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "zoomButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(button2(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var button3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "zoomButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(button3(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var button4: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "zoomButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(button4(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let button1Point: CGPoint = CGPointMake(1000, 180)
    let button2Point: CGPoint = CGPointMake(600, 600)
    let button3Point: CGPoint = CGPointMake(170, 920)
    let button4Point: CGPoint = CGPointMake(1000, 1000)
    
    var button1TopAnchor: NSLayoutConstraint!
    var button1LeadingAnchor: NSLayoutConstraint!
    var button2TopAnchor: NSLayoutConstraint!
    var button2LeadingAnchor: NSLayoutConstraint!
    var button3TopAnchor: NSLayoutConstraint!
    var button3LeadingAnchor: NSLayoutConstraint!
    var button4TopAnchor: NSLayoutConstraint!
    var button4LeadingAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeScrollView()
        
        print("ScrollView ContentSize at viewDidAppear: \(self.scrollView.contentSize)")
    }
}

// MARK: - Extension for methods
extension ViewController: EssentialViewMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.zoomBackgroundImageView)
        self.scrollView.addSubview(self.button1)
        self.scrollView.addSubview(self.button2)
        self.scrollView.addSubview(self.button3)
        self.scrollView.addSubview(self.button4)
    }
    
    func setLayouts() {
        // scrollView
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // zoomBackgroundImageView
        NSLayoutConstraint.activate([
            self.zoomBackgroundImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.zoomBackgroundImageView.heightAnchor.constraint(equalToConstant: 1200),
            self.zoomBackgroundImageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.zoomBackgroundImageView.widthAnchor.constraint(equalToConstant: 1200)
        ])
        
        // button1
        self.button1TopAnchor = self.button1.centerYAnchor.constraint(equalTo: self.zoomBackgroundImageView.topAnchor, constant: self.button1Point.y)
        self.button1LeadingAnchor = self.button1.centerXAnchor.constraint(equalTo: self.zoomBackgroundImageView.leadingAnchor, constant: self.button1Point.x)
        NSLayoutConstraint.activate([
            self.button1TopAnchor,
            self.button1.heightAnchor.constraint(equalToConstant: 86),
            self.button1LeadingAnchor,
            self.button1.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        // button2
        self.button2TopAnchor = self.button2.centerYAnchor.constraint(equalTo: self.zoomBackgroundImageView.topAnchor, constant: self.button2Point.y)
        self.button2LeadingAnchor = self.button2.centerXAnchor.constraint(equalTo: self.zoomBackgroundImageView.leadingAnchor, constant: self.button2Point.x)
        NSLayoutConstraint.activate([
            self.button2TopAnchor,
            self.button2.heightAnchor.constraint(equalToConstant: 86),
            self.button2LeadingAnchor,
            self.button2.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        // button3
        self.button3TopAnchor = self.button3.centerYAnchor.constraint(equalTo: self.zoomBackgroundImageView.topAnchor, constant: self.button3Point.y)
        self.button3LeadingAnchor = self.button3.centerXAnchor.constraint(equalTo: self.zoomBackgroundImageView.leadingAnchor, constant: self.button3Point.x)
        NSLayoutConstraint.activate([
            self.button3TopAnchor,
            self.button3.heightAnchor.constraint(equalToConstant: 86),
            self.button3LeadingAnchor,
            self.button3.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        // button4
        self.button4TopAnchor = self.button4.centerYAnchor.constraint(equalTo: self.zoomBackgroundImageView.topAnchor, constant: self.button4Point.y)
        self.button4LeadingAnchor = self.button4.centerXAnchor.constraint(equalTo: self.zoomBackgroundImageView.leadingAnchor, constant: self.button4Point.x)
        NSLayoutConstraint.activate([
            self.button4TopAnchor,
            self.button4.heightAnchor.constraint(equalToConstant: 86),
            self.button4LeadingAnchor,
            self.button4.widthAnchor.constraint(equalToConstant: 86)
        ])
    }
}

// MARK: - Extension for methods added
extension ViewController {
    func initializeScrollView() {
        self.scrollView.zoomScale = 1.0
        
        self.makeContentToBeCenter()
    }
    
    func makeContentToBeCenter() {
        let offsetX = max((self.scrollView.bounds.width - self.scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((self.scrollView.bounds.height - self.scrollView.contentSize.height) * 0.5, 0)
        self.scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

// MARK: - Extension for selector methods
extension ViewController {
    @objc func button1(_ sender: UIButton) {
        print("button1")
    }
    
    @objc func button2(_ sender: UIButton) {
        print("button2")
    }
    
    @objc func button3(_ sender: UIButton) {
        print("button3")
    }
    
    @objc func button4(_ sender: UIButton) {
        print("button4")
    }
}

// MARK: - Extension for UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomBackgroundImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.makeContentToBeCenter()
        
        self.button1.transform = CGAffineTransform(scaleX: scrollView.zoomScale, y: scrollView.zoomScale)
        self.button1TopAnchor.constant = self.button1Point.y * scrollView.zoomScale
        self.button1LeadingAnchor.constant = self.button1Point.x * scrollView.zoomScale
        
        self.button2.transform = CGAffineTransform(scaleX: scrollView.zoomScale, y: scrollView.zoomScale)
        self.button2TopAnchor.constant = self.button2Point.y * scrollView.zoomScale
        self.button2LeadingAnchor.constant = self.button2Point.x * scrollView.zoomScale
        
        self.button3.transform = CGAffineTransform(scaleX: scrollView.zoomScale, y: scrollView.zoomScale)
        self.button3TopAnchor.constant = self.button3Point.y * scrollView.zoomScale
        self.button3LeadingAnchor.constant = self.button3Point.x * scrollView.zoomScale
        
        self.button4.transform = CGAffineTransform(scaleX: scrollView.zoomScale, y: scrollView.zoomScale)
        self.button4TopAnchor.constant = self.button4Point.y * scrollView.zoomScale
        self.button4LeadingAnchor.constant = self.button4Point.x * scrollView.zoomScale
        
        print("zoomScale: \(scrollView.zoomScale)")
        print("ScrollView ContentSize at zooming: \(scrollView.contentSize)")
    }
}
