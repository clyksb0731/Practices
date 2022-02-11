//
//  CentralManagerViewController.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit
import CoreBluetooth

class CentralManagerViewController: UIViewController {

    @IBOutlet weak var subscribingSwitchStateView: UIView!
    @IBOutlet weak var subscribingTextStateView: UIView!
    @IBOutlet weak var synchronizingSwitch: UISwitch!
    @IBOutlet weak var ownedTextView: UITextView!
    @IBOutlet weak var ownedTextStateLabel: UILabel!
    @IBOutlet weak var sendTextButton: UIButton!
    @IBOutlet weak var receivingTextView: UITextView!
    @IBOutlet weak var receivingTextStateLabel: UILabel!
    @IBOutlet weak var readTextButton: UIButton!
    @IBOutlet weak var connectingButton: UIButton!
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristicForText: CBCharacteristic!
    var characteristicForSwitch: CBCharacteristic!
    
    var ownedTextData = Data()
    //var subData = Data()
    var sentDataIndex: Int = 0
    var amountToSend: Int = 0
    var isWritingEOM = false
    
    var receivingTextData = Data()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }()
    
    var isBTConnected = false
    
    deinit {
        print("=========================== CentralManagerViewController disposed ===========================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownedTextView.delegate = self
        
        self.subscribingSwitchStateView.layer.cornerRadius = 25/2
        self.subscribingTextStateView.layer.cornerRadius = 25/2
        self.enableObjectsRelatedToSwitch(on: false)
        self.enableObjectsRelatedToText(on: false)
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
}

// MARK: - Extension for Methods add
extension CentralManagerViewController {
    func foundCentral() {
        if let connectedPeripheral = self.centralManager.retrieveConnectedPeripherals(withServices: [UUIDs.serviceUUID]).last {
            self.centralManager.connect(connectedPeripheral, options: nil)
            
        } else {
            self.connectingButton.isEnabled = true
        }
    }
    
    func writeDataToCharacteristic() {
        if self.sentDataIndex >= self.ownedTextData.count {
            self.peripheral.writeValue("EOM".data(using: .utf8)!, for: self.characteristicForText, type: .withResponse)
            self.isWritingEOM = true
            
            return
        }
        
        self.amountToSend = self.ownedTextData.count - self.sentDataIndex
        if let mtu = self.peripheral?.maximumWriteValueLength(for: .withResponse) {
            self.amountToSend = min(self.amountToSend, mtu)
        }
        
        let subData = self.ownedTextData.subdata(in: self.sentDataIndex..<(self.amountToSend + self.sentDataIndex))
        
        self.peripheral.writeValue(subData, for: self.characteristicForText, type: .withResponse)
    }
    
    func readDataFromCharacteristic() {
        self.peripheral.writeValue("readData".data(using: .utf8)!, for: self.characteristicForText, type: .withoutResponse)
    }
    
    func enableObjectsRelatedToSwitch(on: Bool) {
        self.synchronizingSwitch.isEnabled = on
        self.subscribingSwitchStateView.backgroundColor = on ? .green : .red
    }
    
    func enableObjectsRelatedToText(on: Bool) {
        self.ownedTextView.isEditable = on
        self.sendTextButton.isEnabled = on
        self.readTextButton.isEnabled = on
        
        self.subscribingTextStateView.backgroundColor = on ? .green : .red
    }
}

// MARK: - Extension for Selector methods
extension CentralManagerViewController {
    @IBAction func synchronizingSwitch(_ sender: UISwitch) {
        self.view.endEditing(true)
        
        self.peripheral.writeValue(sender.isOn ? "switchOn".data(using: .utf8)! : "switchOff".data(using: .utf8)!, for: self.characteristicForSwitch, type: .withResponse)
    }
    
    @IBAction func sendTextButton(_ sender: Any) {
        guard let ownedTextData = self.ownedTextView.text.data(using: .utf8) else {
            return
        }
        
        self.view.endEditing(true)
        
        self.ownedTextData = ownedTextData
        self.sentDataIndex = 0
        self.isWritingEOM = false
        
        self.sendTextButton.isEnabled = false
        
        self.writeDataToCharacteristic()
    }
    
    @IBAction func readTextButton(_ sender: Any) {
        self.view.endEditing(true)
        
        self.readDataFromCharacteristic()
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
}

// MARK: - Extension for CBCentralManagerDelegate
extension CentralManagerViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Central poweredOn")
            self.foundCentral()
            
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
        self.connectingButton.isEnabled = true
        
        central.stopScan()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        self.peripheral.discoverServices([UUIDs.serviceUUID])
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("didDisconnectPeripheral Error: \(error.localizedDescription)")
        }
        
        self.isBTConnected = false
        
        self.peripheral = nil
        
        self.connectingButton.setTitle("Connect To", for: .normal)
        
        self.enableObjectsRelatedToSwitch(on: false)
        self.enableObjectsRelatedToText(on: false)
        
        self.subscribingSwitchStateView.backgroundColor = .red
        self.subscribingTextStateView.backgroundColor = .red
        
        self.synchronizingSwitch.isOn = false
        
        self.ownedTextStateLabel.text = "Owned Text State"
        self.ownedTextStateLabel.textColor = .black
        self.receivingTextStateLabel.text = "Receiving Text State"
        self.receivingTextStateLabel.textColor = .black
        
        self.ownedTextView.text = ""
        self.receivingTextView.text = ""
        
        self.view.endEditing(true)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did fail to connect: \(error?.localizedDescription ?? "error")")
    }
}

// MARK: - CBPeripheralDelegate
extension CentralManagerViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("didDiscoverServices Error: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                // FIXME: to check proper operator
                if service.uuid == UUIDs.serviceUUID {
                    peripheral.discoverCharacteristics([UUIDs.characteristicForTextUUID], for: service)
                    peripheral.discoverCharacteristics([UUIDs.characteristicForSwitchUUID], for: service)
                }
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("didDiscoverCharacteristicsFor Error: \(error.localizedDescription)")
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == UUIDs.characteristicForTextUUID {
                    self.characteristicForText = characteristic
                    
                    self.peripheral.setNotifyValue(true, for: characteristic)
                }
                
                if characteristic.uuid == UUIDs.characteristicForSwitchUUID {
                    self.characteristicForSwitch = characteristic
                    
                    self.peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didUpdateNotificationStateFor Error: \(error.localizedDescription)")
            return
        }
        
        if characteristic.uuid == UUIDs.characteristicForTextUUID {
            self.enableObjectsRelatedToText(on: characteristic.isNotifying)
        }
        
        if characteristic.uuid == UUIDs.characteristicForSwitchUUID {
            self.enableObjectsRelatedToSwitch(on: characteristic.isNotifying)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didUpdateValueFor Error: \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            if characteristic.uuid == UUIDs.characteristicForSwitchUUID {
                if let string = String(data: data, encoding: .utf8), string == "switchOn" {
                    self.synchronizingSwitch.isOn = true
                    
                }
                
                if let string = String(data: data, encoding: .utf8), string == "switchOff" {
                    self.synchronizingSwitch.isOn = false
                    
                }
            }
            
            if characteristic.uuid == UUIDs.characteristicForTextUUID {
                if let string = String(data: data, encoding: .utf8), string == "EOM" {
                    self.receivingTextView.text = String(data: self.receivingTextData, encoding: .utf8)
                    self.receivingTextStateLabel.text = "Received at \(self.dateFormatter.string(from: Date()))"
                    self.receivingTextStateLabel.textColor = .red
                    
                    self.receivingTextData = Data()
                    
                } else {
                    self.receivingTextData.append(data)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didWriteValueFor Error: \(error.localizedDescription)")
            
            return
        }
        
        if characteristic.uuid == UUIDs.characteristicForSwitchUUID {
            
        }
        
        if characteristic.uuid == UUIDs.characteristicForTextUUID {
            if self.isWritingEOM {
                self.ownedTextStateLabel.text = "Sent at \(self.dateFormatter.string(from: Date()))"
                self.ownedTextStateLabel.textColor = .red
                
                self.sendTextButton.isEnabled = true
                
            } else {
                self.sentDataIndex += self.amountToSend
                
                self.writeDataToCharacteristic()
            }
        }
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        // code
    }
}

extension CentralManagerViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if (text == "\n") {
        textView.resignFirstResponder()
      }
        
      return true
    }
}
