//
//  NinthViewController.swift
//  NavigationBarAppearance
//
//  Created by Yongseok Choi on 2021/12/07.
//

import UIKit

class NinthViewController: UIViewController {

    var viewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        Appearance:
        > configureWithDefaultBackground()
        > backgroundColor = .cyan
        > foregroundColor:blue
        > where? navigationItem
        
        NavigationBar:
        > isTranslucent = false
        > backgroundColor = .blue
        
        NavigationItem:
        > tintColor = .black
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white // root view color
        
        self.setViewDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }
    

    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground() // Navigation bar line appears
        appearance.backgroundColor = .cyan // Navigation bar is cyan color.
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 0, blue: 255),
            .font:UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // MARK: NavigationItem appearance for each view controller
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = false // Default is true
        self.navigationController?.navigationBar.backgroundColor = .blue // It is ignored due to appearance background color.
        
        self.navigationItem.title = "아홉 번째 뷰"
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

extension NinthViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let tenthVC = TenthViewController()
        self.navigationController?.pushViewController(tenthVC, animated: true)
    }
}
