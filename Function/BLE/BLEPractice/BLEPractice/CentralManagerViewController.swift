//
//  CentralManagerViewController.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit
import CoreBluetooth

class CentralManagerViewController: UIViewController {

    @IBOutlet weak var connectionStateView: UIView!
    @IBOutlet weak var synchronizingSwitch: UISwitch!
    @IBOutlet weak var sendingTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var connectingButton: UIButton!
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    
    var isBTConnected = false
    
    deinit {
        print("=========================== CentralManagerViewController disposed ===========================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendingTextField.delegate = self
        
        self.connectionStateView.layer.cornerRadius = 25/2
        self.enableObjects(on: false)
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    @IBAction func synchronizingSwitch(_ sender: UISwitch) {
        self.peripheral.writeValue(sender.isOn ? "true".data(using: .utf8)! : "false".data(using: .utf8)!, for: self.characteristic, type: .withResponse)
    }
    
    @IBAction func sendingMessageButton(_ sender: Any) {
        
    }
    
    @IBAction func openVCToConnectBT(_ sender: UIButton) {
        if self.isBTConnected {
            self.centralManager.cancelPeripheralConnection(self.peripheral)
            
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let peripheralListVC = storyboard.instantiateViewController(withIdentifier: "PeripheralListViewController") as! PeripheralListViewController
            peripheralListVC.modalPresentationStyle = .fullScreen
            
            peripheralListVC.centralManager = self.centralManager
            
            self.present(peripheralListVC, animated: true, completion: nil)
        }
    }
    
    func enableObjects(on: Bool) {
        self.synchronizingSwitch.isEnabled = on
        self.sendingTextField.isEnabled = on
        self.sendMessageButton.isEnabled = on
    }
}

// MARK: - CBCentralManagerDelegate
extension CentralManagerViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Central poweredOn")
            self.connectingButton.isEnabled = true
            
        case .poweredOff:
            print("Central poweredOff")
            
        case .unknown:
            print("Central unknown")
            
        case .resetting:
            print("Central resetting")
            
        case .unsupported:
            print("Central unsupported")
            
        case .unauthorized:
            print("Central unauthorized")
            
        default:
            print("Central default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isBTConnected = true
        self.connectingButton.setTitle("Disconnect", for: .normal)
        
        central.stopScan()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        self.peripheral.discoverServices([UUIDs.serviceUUID])
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Did disconnect error: \(error.localizedDescription)")
        }
        
        self.isBTConnected = false
        
        self.peripheral = nil
        
        self.connectingButton.setTitle("Connect To", for: .normal)
        
        self.connectionStateView.backgroundColor = .red
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did fail to connect: \(error?.localizedDescription ?? "error")")
    }
}

// MARK: - CBPeripheralDelegate
extension CentralManagerViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                // FIXME: to check proper operator
                if service.uuid == UUIDs.serviceUUID {
                    peripheral.discoverCharacteristics([UUIDs.characteristicUUID], for: service)
                }
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == UUIDs.characteristicUUID {
                    self.characteristic = characteristic
                    
                    self.peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            return
        }
        
        self.enableObjects(on: characteristic.isNotifying)
        
        if characteristic.isNotifying {
            self.connectionStateView.backgroundColor = .green
            
        } else {
            self.connectionStateView.backgroundColor = .red
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            return
        }
        
        if let data = characteristic.value, let string = String(data: data, encoding: .utf8) {
            self.synchronizingSwitch.isOn = string == "true" ? true : false
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            print("didWriteValueFor: " + String(data: data, encoding: .utf8)!)
        }
        
        if let error = error {
            print("didWriteValueFor Error: \(error.localizedDescription)")
        }
    }
}

extension CentralManagerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
