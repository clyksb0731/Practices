//
//  ViewController2.swift
//  UIViewPropertyAnimator
//
//  Created by Yongseok Choi on 2023/05/30.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(_ sender: UIButton) {
        SupportingMethods.shared.start()
    }
}
