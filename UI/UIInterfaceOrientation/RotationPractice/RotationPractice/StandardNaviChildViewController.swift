//
//  StandardNaviChildViewController.swift
//  RotationPractice
//
//  Created by Yongseok Choi on 2021/12/14.
//

import UIKit

class StandardNaviChildViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .cyan
        
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        self.navigationItem.title = "Standard Child VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backView(_:)))
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // default: true
//    override var shouldAutorotate: Bool {
//        return true
//    }
    
    @objc func backView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
