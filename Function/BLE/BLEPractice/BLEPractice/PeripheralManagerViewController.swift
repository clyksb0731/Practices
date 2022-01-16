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
    @IBOutlet weak var ownedTextView: UITextView!
    @IBOutlet weak var ownedTextStateLabel: UILabel!
    @IBOutlet weak var updateTextButton: UIButton!
    @IBOutlet weak var receivingTextLabel: UILabel!
    @IBOutlet weak var receivingTextStateLabel: UILabel!
    @IBOutlet weak var startAdvertisingButton: UIButton!
    
    var connectedCentral: CBCentral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBCharacteristic!
    var service: CBMutableService!
    
    var ownedTextData = Data()
    var sentDataIndex: Int = 0
    var isSendingEOM = false
    var receivingTextData = Data()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }()
    
    deinit {
        print("=========================== PeripheralManagerViewController disposed ===========================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedTextView.delegate = self
        
        self.connectionStateView.layer.cornerRadius = 25/2
        self.enableObjects(on: false)
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey:true])
    }

    @IBAction func synchronizingSwitch(_ sender: UISwitch) {
        self.peripheralManager.updateValue(sender.isOn ? "switchOn".data(using: .utf8)! : "switchOff".data(using: .utf8)!, for: self.characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil)
    }
    
    @IBAction func updateTextButton(_ sender: Any) {
        guard let ownedTextData = self.ownedTextView.text.data(using: .utf8) else {
            return
        }
        
        self.ownedTextData = ownedTextData
        self.sentDataIndex = 0
        
        self.updateTextButton.isEnabled = false
        
        self.updateDataToCharacteristic()
    }
    
    @IBAction func startAdvertisingButton(_ sender: UIButton) {
        if self.peripheralManager.isAdvertising {
            self.peripheralManager.stopAdvertising()
            
            self.startAdvertisingButton.setTitle("Start Advertising", for: .normal)
            
        } else {
            self.peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey:"BLE 테스트", CBAdvertisementDataServiceUUIDsKey:[UUIDs.serviceUUID]])
        }
    }
    
    func updateDataToCharacteristic() {
        if self.isSendingEOM {
            if self.peripheralManager.updateValue("EOM".data(using: .utf8)!, for: self.characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil) {
                
                self.ownedTextStateLabel.text = "Sent at \(self.dateFormatter.string(from: Date()))"
                self.ownedTextStateLabel.textColor = .red
                
                self.updateTextButton.isEnabled = true
                
                self.isSendingEOM = false
            }
            
            return
        }
        
        if self.sentDataIndex >= self.ownedTextData.count {
            return
        }
        
        while true {
            var amountToSend = self.ownedTextData.count + self.sentDataIndex
            if let mtu = self.connectedCentral?.maximumUpdateValueLength {
                amountToSend = min(amountToSend, mtu)
            }
            
            let subData = self.ownedTextData.subdata(in: self.sentDataIndex..<(amountToSend + self.sentDataIndex))
            
            if self.peripheralManager.updateValue(subData, for: self.characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil) {
                self.sentDataIndex += amountToSend
                
                if self.sentDataIndex >= self.ownedTextData.count {
                    self.isSendingEOM = true
                    
                    if self.peripheralManager.updateValue("EOM".data(using: .utf8)!, for: self.characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil) {
                        
                        self.ownedTextStateLabel.text = "Sent at \(self.dateFormatter.string(from: Date()))"
                        self.ownedTextStateLabel.textColor = .red
                        
                        self.updateTextButton.isEnabled = true
                        
                        self.isSendingEOM = false
                    }
                    
                    return
                }
                
            } else {
                break;
            }
        }
    }
    
    func enableObjects(on: Bool) {
        self.synchronizingSwitch.isEnabled = on
        self.ownedTextView.isEditable = on
        self.updateTextButton.isEnabled = on
    }
    
    func foundPeripheral() {
        self.characteristic = CBMutableCharacteristic(type: UUIDs.characteristicUUID, properties: [.notify, .write], value: nil, permissions: [.readable, .writeable])
        self.service = CBMutableService(type: UUIDs.serviceUUID, primary: true)
        self.service.characteristics = [self.characteristic]
        self.peripheralManager.add(self.service)
    }
}

// MARK: - CBPeripheralManagerDelegate
extension PeripheralManagerViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        self.startAdvertisingButton.isEnabled = peripheral.state == .poweredOn
        
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral poweredOn")
            self.foundPeripheral()
            
        case .poweredOff:
            print("Peripheral poweredOff")
            
        case .unknown:
            print("Peripheral unknown")
            
        case .resetting:
            print("Peripheral resetting")
            
        case .unsupported:
            print("Peripheral unsupported")
            
        case .unauthorized:
            print("Peripheral unauthorized")
            
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
        print("didReceiveRead")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("didReceiveWrite")
        
        for request in requests { // Considered that only one request exists
            if let data = request.value {
                if let string = String(data: data, encoding: .utf8), string == "switchOn" {
                    self.synchronizingSwitch.isOn = true
                    
                } else if let string = String(data: data, encoding: .utf8), string == "switchOff" {
                    self.synchronizingSwitch.isOn = false
                    
                } else if let string = String(data: data, encoding: .utf8), string == "readData" {
                    self.updateDataToCharacteristic()
                    
                } else if let string = String(data: data, encoding: .utf8), string == "EOM" {
                    self.receivingTextLabel.text = String(data: self.receivingTextData, encoding: .utf8)
                    self.receivingTextStateLabel.text = "Received at \(self.dateFormatter.string(from: Date()))"
                    self.receivingTextStateLabel.textColor = .red
                    
                } else {
                    self.receivingTextData.append(data)
                }
            }
            
            peripheral.respond(to: request, withResult: .success)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        self.connectedCentral = central
        
        self.connectionStateView.backgroundColor = .green
        
        self.enableObjects(on: true)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        self.connectionStateView.backgroundColor = .red
        
        self.enableObjects(on: false)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.updateDataToCharacteristic()
    }
}

extension PeripheralManagerViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if (text == "\n") {
        textView.resignFirstResponder()
      }
        
      return true
    }
}
