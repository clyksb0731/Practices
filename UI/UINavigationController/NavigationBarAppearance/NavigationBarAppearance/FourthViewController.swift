//
//  FourthViewController.swift
//  NavigationBarAppearance
//
//  Created by Yongseok Choi on 2021/12/05.
//

import UIKit

class FourthViewController: UIViewController {
    
    var viewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        Appearance:
        > configureWithTransparentBackground()
        > backgroundColor = .clear
        > foregroundColor:white
        > where? navigationItem
        
        NavigationBar:
        > isTranslucent = false
        > backgroundColor = .brown
        
        NavigationItem:
        > tintColor = .black
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
        
        self.setViewDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }

    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // No navigation bar line
        appearance.backgroundColor = .clear // Navigation bar is transparent and red color (root view) appears on it.
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 255, green: 255, blue: 255),
            .font:UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // MARK: NavigationItem appearance for each view controller
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = false // But, if then, no navigation bar appears.
        self.navigationController?.navigationBar.backgroundColor = .brown // Just navigation background color appears.
        
        self.navigationItem.title = "네 번째 뷰"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 뷰", style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 뷰", style: .done, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }

    func setViewDescriptionLabel() {
        self.view.addSubview(self.viewDescriptionLabel)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.viewDescriptionLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.viewDescriptionLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

extension FourthViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let fifthVC = FifthViewController()
        self.navigationController?.pushViewController(fifthVC, animated: true)
    }
}
