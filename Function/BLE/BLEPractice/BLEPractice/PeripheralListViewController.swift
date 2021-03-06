//
//  PeripheralListViewController.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit
import CoreBluetooth

class PeripheralListViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    
    var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var tableView: UITableView!
    
    var centralManager: CBCentralManager!
    var peripheralList: Array<CBPeripheral> = []

    deinit {
        print("=========================== PeripheralListViewController disposed ===========================")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centralManager.delegate = self

        self.tableView = {
            let tableView = UITableView()
            tableView.register(PeripheralCell.self, forCellReuseIdentifier: "PeripheralCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            return tableView
        }()
        
        self.view.addSubview(self.topLineView)
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.topLineView.topAnchor.constraint(equalTo: self.baseView.topAnchor),
            self.topLineView.heightAnchor.constraint(equalToConstant: 1),
            self.topLineView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
            self.topLineView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.topLineView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.centralManager.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: [UUIDs.serviceUUID], options: nil)
        }
    }
}

// MARK: - Extension for Selector methods
extension PeripheralListViewController {
    @IBAction func goBackToThePreviousVC(_ sender: UIButton) {
        self.centralManager.delegate = self.presentingViewController as! CentralManagerViewController
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension PeripheralListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripheralList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell", for: indexPath) as! PeripheralCell
        cell.setCell(nameAndUuid: "\(self.peripheralList[indexPath.row].name ?? "unknown"): \(self.peripheralList[indexPath.row].identifier.uuidString)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.centralManager.stopScan()
        
        self.centralManager.delegate = self.presentingViewController as! CentralManagerViewController
        self.centralManager.connect(self.peripheralList[indexPath.row], options: nil)
    }
}

extension PeripheralListViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for item in self.peripheralList {
            if item.identifier == peripheral.identifier {
                return
            }
        }
        
        self.peripheralList.append(peripheral)
        
        self.topLineView.isHidden = false
        
        self.tableView.reloadData()
    }
}
