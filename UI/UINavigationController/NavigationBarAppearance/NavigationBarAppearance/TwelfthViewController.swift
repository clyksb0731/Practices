//
//  TwelfthViewController.swift
//  NavigationBarAppearance
//
//  Created by Yongseok Choi on 2021/12/07.
//

import UIKit

class TwelfthViewController: UIViewController {

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
        > backgroundColor = .clear
        > foregroundColor:green
        > where? navigationItem
        
        NavigationBar:
        > isTranslucent = false
        > backgroundColor = nil
        
        NavigationItem:
        > tintColor = .black
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .yellow // root view color
        
        self.setViewDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }
    

    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground() // Navigation bar line appears
        appearance.backgroundColor = .clear // Navigation bar is clear color and default background appears on it.
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 255, blue: 0),
            .font:UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // MARK: NavigationItem appearance for each view controller
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = false // Nvaigation bar is not translucent under default background.
        self.navigationController?.navigationBar.backgroundColor = nil // Navigation bar doesn't appear under default background.
        
        self.navigationItem.title = "열두 번째 뷰"
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

extension TwelfthViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let lastVC = LastViewController()
        self.navigationController?.pushViewController(lastVC, animated: true)
    }
}
