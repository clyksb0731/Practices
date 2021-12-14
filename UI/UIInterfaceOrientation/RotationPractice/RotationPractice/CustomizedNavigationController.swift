//
//  CustomizedNavigationController.swift
//  RotationPractice
//
//  Created by Yongseok Choi on 2021/12/14.
//

import UIKit

class CustomizedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {        
        return self.topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }

    // default: true
//    override var shouldAutorotate: Bool {
//        return true
//    }
}
