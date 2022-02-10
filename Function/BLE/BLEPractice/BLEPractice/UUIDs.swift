//
//  UUIDs.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import Foundation
import CoreBluetooth

struct UUIDs {
    static let serviceUUID = CBUUID(string: "80F8575D-873C-457B-8609-8A98D8C6FE8B")
    static let characteristicForTextUUID = CBUUID(string: "7BD42D08-7EE1-4EA9-BEBB-39C4C68BD942")
    static let characteristicForSwitchUUID = CBUUID(string: "87D004DC-524D-4492-B658-7884A4BC83A5")
}
