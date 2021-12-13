//
//  ViewController.swift
//  RotationPractice
//
//  Created by Yongseok Choi on 2021/12/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }

    
    @IBAction func controlRotation(_ sender: UIButton) {
        if UIDevice.current.orientation.isPortrait {
            let orientation = UIInterfaceOrientation.landscapeLeft.rawValue
            
            UIDevice.current.setValue(orientation, forKey: "orientation")
            
            UIViewController.attemptRotationToDeviceOrientation()
            
        } else if UIDevice.current.orientation.isLandscape {
            let orientation = UIInterfaceOrientation.portrait.rawValue
            
            UIDevice.current.setValue(orientation, forKey: "orientation")
            
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

