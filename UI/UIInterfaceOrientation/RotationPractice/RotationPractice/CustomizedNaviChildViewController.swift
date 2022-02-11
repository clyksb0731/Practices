//
//  CustomizedNaviChildViewController.swift
//  RotationPractice
//
//  Created by Yongseok Choi on 2021/12/14.
//

import UIKit

class CustomizedNaviChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .yellow
        
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationItem.title = "Customized Child VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backView(_:)))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft // could be .portrait and so on
        // This value affects the navigation controller orientation of this child view controller because the navigation controller use this value on the 'override var supportedInterfaceOrientations: UIInterfaceOrientationMask' with its property, topViewController's supportedInterfaceOrientations.
    }

    // default: true
//    override var shouldAutorotate: Bool {
//        return true
//    }
    
    @objc func backView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
