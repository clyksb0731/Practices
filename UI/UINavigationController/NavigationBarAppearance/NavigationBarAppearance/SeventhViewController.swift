//
//  SeventhViewController.swift
//  NavigationBarAppearance
//
//  Created by Yongseok Choi on 2021/12/07.
//

import UIKit

class SeventhViewController: UIViewController {
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("이전 뷰", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(previousButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.text = "일곱 번째 뷰"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("다음 뷰", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .blue
        
        self.setButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }

    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Navigation bar line appears
        appearance.backgroundColor = .clear // Navigation bar is transparent and blue color (root view) appears on it.
        
        // MARK: NavigationItem appearance for each view controller
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = false // But, if then, no navigation bar appears
        self.navigationController?.navigationBar.backgroundColor = nil
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 0, blue: 0),
                                                                        .font:UIFont.systemFont(ofSize: 18, weight: .medium)]
        self.navigationItem.title = "일곱 번째 뷰"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 뷰", style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 뷰", style: .done, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func setButtons() {
        self.view.addSubview(self.previousButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.nextButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.previousButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            self.previousButton.heightAnchor.constraint(equalToConstant: 30),
            self.previousButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            self.previousButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.previousButton.topAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.previousButton.bottomAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            self.nextButton.heightAnchor.constraint(equalToConstant: 30),
            self.nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            self.nextButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SeventhViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let eighthVC = EighthViewController()
        self.navigationController?.pushViewController(eighthVC, animated: true)
    }
    
    @objc func previousButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButton(_ sender: UIButton) {
        let eighthVC = EighthViewController()
        self.navigationController?.pushViewController(eighthVC, animated: true)
    }
}
