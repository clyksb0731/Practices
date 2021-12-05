//
//  PeripheralManagerViewController.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit
import CoreBluetooth

class PeripheralManagerViewController: UIViewController {

    @IBOutlet weak var connectionStateView: UIView!
    @IBOutlet weak var synchronizingSwitch: UISwitch!
    @IBOutlet weak var sendingTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var startAdvertisingButton: UIButton!
    
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBCharacteristic!
    var service: CBMutableService!
    
    deinit {
        print("=========================== PeripheralManagerViewController disposed ===========================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendingTextField.delegate = self
        
        self.connectionStateView.layer.cornerRadius = 25/2
        self.enableObjects(on: false)
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey:true])
    }

    @IBAction func synchronizingSwitch(_ sender: UISwitch) {
        self.peripheralManager.updateValue(sender.isOn ? "true".data(using: .utf8)! : "false".data(using: .utf8)!, for: self.characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil)
    }
    
    @IBAction func sendingMessageButton(_ sender: Any) {
        
    }
    
    @IBAction func startAdvertisingButton(_ sender: UIButton) {
        if self.peripheralManager.isAdvertising {
            self.peripheralManager.stopAdvertising()
            
            self.startAdvertisingButton.setTitle("Start Advertising", for: .normal)
            
        } else {
            self.peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey:"BLE 테스트", CBAdvertisementDataServiceUUIDsKey:[UUIDs.serviceUUID]])
        }
    }
    
    @IBAction func centralTabButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func peripheralTabButton(_ sender: UIButton) {
        // nothing
    }
    
    func enableObjects(on: Bool) {
        self.synchronizingSwitch.isEnabled = on
        self.sendingTextField.isEnabled = on
        self.sendMessageButton.isEnabled = on
    }
}

// MARK: - CBPeripheralManagerDelegate
extension PeripheralManagerViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        self.startAdvertisingButton.isEnabled = peripheral.state == .poweredOn
        
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral poweredOn")
            
            self.characteristic = CBMutableCharacteristic(type: UUIDs.characteristicUUID, properties: [.notify, .write], value: nil, permissions: [.readable, .writeable])
            self.service = CBMutableService(type: UUIDs.serviceUUID, primary: true)
            self.service.characteristics = [self.characteristic]
            self.peripheralManager.add(self.service)
            
        case .unknown:
            print("Peripheral unknown")
            
        case .resetting:
            print("Peripheral resetting")
            
        case .unsupported:
            print("Peripheral unsupported")
            
        case .unauthorized:
            print("Peripheral unauthorized")
            
        case .poweredOff:
            print("Peripheral poweredOff")
            
        default:
            print("Peripheral default")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        guard error == nil else {
            return
        }
        
        if peripheral.isAdvertising {
            self.startAdvertisingButton.setTitle("Stop Advertising", for: .normal)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            request.characteristic
            if let data = request.value, let string = String(data: data, encoding: .utf8) {
                self.synchronizingSwitch.isOn = string == "true" ? true : false
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        self.connectionStateView.backgroundColor = .green
        
        self.enableObjects(on: true)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        self.connectionStateView.backgroundColor = .red
        
        self.enableObjects(on: false)
    }
}

extension PeripheralManagerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
