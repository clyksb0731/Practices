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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft]
    }

    // default: true
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
    
    @IBAction func standardNavi(_ sender: UIButton) {
        let standardNaviChildVC = StandardNaviChildViewController()
        let naviVC = UINavigationController(rootViewController: standardNaviChildVC)
        naviVC.modalPresentationStyle = .fullScreen
        
        self.present(naviVC, animated: true, completion: nil)
    }
    
    @IBAction func customizedNavi(_ sender: UIButton) {
        let customizedNaviChildVC = CustomizedNaviChildViewController()
        let naviVC = CustomizedNavigationController(rootViewController: customizedNaviChildVC)
        naviVC.modalPresentationStyle = .fullScreen
        
        self.present(naviVC, animated: true, completion: nil)
    }
}
