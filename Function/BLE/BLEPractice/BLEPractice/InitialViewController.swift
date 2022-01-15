//
//  InitialViewController.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2022/01/16.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var centralModeButton: UIButton!
    @IBOutlet weak var peripheralModeButton: UIButton!
    
    deinit {
        print("=========================== InitialViewController disposed ===========================")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.centralModeButton.layer.cornerRadius = 8
        self.peripheralModeButton.layer.cornerRadius = 8
    }

    @IBAction func centralModeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centralManagerVC = storyboard.instantiateViewController(withIdentifier: "CentralManagerViewController") as! CentralManagerViewController
        centralManagerVC.modalPresentationStyle = .fullScreen
        
        self.present(centralManagerVC, animated: true, completion: nil)
    }
    
    @IBAction func peripheralModeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let peripheralManagerVC = storyboard.instantiateViewController(withIdentifier: "PeripheralManagerViewController") as! PeripheralManagerViewController
        peripheralManagerVC.modalPresentationStyle = .fullScreen
        
        self.present(peripheralManagerVC, animated: true, completion: nil)
    }
}
