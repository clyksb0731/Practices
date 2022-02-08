//
//  ViewController.swift
//  NavigationBarAppearance
//
//  Created by Yongseok Choi on 2021/12/05.
//

import UIKit

class FirstViewController: UIViewController {
    
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
        > backgroundColor = .green
        > foregroundColor:blue
        > where? navigationBar
        
        NavigationBar:
        > isTranslucent = true
        > backgroundColor = .blue
        
        NavigationItem:
        > tintColor = .black
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.setViewDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }

    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // No nvaigation bar line
        appearance.backgroundColor = .green
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 0, blue: 255),
            .font:UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        
        // MARK: NavigationBar appearance
        // It affects all contained view's navigation bar because it is navigation bar's appearances.
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        
        /*
        ** Navigation bar area hierarchy **
         Up - Appearance - NavigationBar - Root View - Down
        */
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = true // Default is true -> navigation bar is translucent. So root view color could appear on navigation bar appearance area but navigation bar appearance is upper so root view color doesn't appear.
        self.navigationController?.navigationBar.backgroundColor = .blue // It is ignored due to navigation bar appearance background color.
        
        self.navigationItem.title = "첫 번째 뷰"
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: "Temp", image: nil, handler: { action in
                
            }),
            UIAction(title: NSLocalizedString("Copy", comment: ""), image: nil, handler: {
                (action) in }),
            UIAction(title: NSLocalizedString("Rename", comment: ""), image: nil, handler: {(action) in
            }),
            UIAction(title: NSLocalizedString("Duplicate", comment: ""), image: nil, handler: {(action) in
            }),
            UIAction(title: NSLocalizedString("Move", comment: ""), image: nil, handler: {(action) in
            })
        ])
        
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "메뉴바"
        barButtonItem.tintColor = .black
        barButtonItem.menu = barButtonMenu
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
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

extension FirstViewController {
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}
