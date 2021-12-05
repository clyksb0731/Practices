//
//  ViewController.swift
//  XMLParser_Basic
//
//  Created by Yongseok Choi on 2021/11/18.
//

import UIKit
import Alamofire
import SwiftUI

class ViewController: UIViewController {
    
    var today: Days?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        
        let dateComponent = calendar.dateComponents([.year, .month], from: today)
        
        let afManager = self.makeAFManagerForDataAPI(dateComponent)
        
        afManager.responseData(completionHandler: { response in
            print(String(data: response.data!, encoding: .utf8)!)
            
            self.today = Days(today, xmlData: response.data)
            
            if let today = self.today {
                print(today.isHoliday ? "It's holiday" : "It's not holiday")
                print(today.isWeekend! ? "It's weekend" : "It's not weekend")
            }
        })
    }
    
    func makeAFManagerForDataAPI(_ dateComponent: DateComponents) -> DataRequest {
        var parameters: Parameters = [:]
        parameters.updateValue(dateComponent.year!, forKey: "solYear")
        parameters.updateValue(String(format: "%02d", dateComponent.month!), forKey: "solMonth")
        parameters.updateValue("0QXt5ziBfkOV7lQFGKAVFuBO8O5YX+Hx0VUu8GauZVX1iJfsZosGtcz/QApzO1/5vmw+GtAz26cVw9nm8Q8LjQ==", forKey: "ServiceKey") // data.go.kr (available until 2023. 11. 18)
        
        print("Parameters: \(parameters)")
        
        let manager = AF.request("http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo", method: .get, parameters: parameters)
        
        return manager
    }
}

