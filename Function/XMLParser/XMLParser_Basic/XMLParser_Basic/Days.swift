//
//  Days.swift
//  XMLParser_Basic
//
//  Created by Yongseok Choi on 2021/11/18.
//

import Foundation
import Alamofire

enum HolidayItem: String {
    case dateName = "dateName"
    case isHoliday = "isHoliday"
    case date = "locdate"
}

class Days: NSObject {
    private(set) var isRestDay: Bool?
    private(set) var isWeekend: Bool?
    var isHoliday: Bool {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            let todayDateString = dateFormatter.string(from: today)
            
            for holiday in self.holidays {
                if holiday.dateString == todayDateString {
                    return true
                }
            }
            
            return false
        }
    }
    
    private var today: Date
    private var currentElement: String?
    private var holiday: Holiday?
    private var holidays: [Holiday] = []
    
    init(_ today: Date, xmlData: Data?) {
        self.today = today
        
        super.init()
        
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        
        let dateComponent = calendar.dateComponents([.year, .month, .weekday], from: today)
        
        if let weekday = dateComponent.weekday {
            self.isWeekend = weekday == 1 || weekday == 7 ? true : false
            self.isRestDay = self.isWeekend
        }
        
        if let xmlData = xmlData {
            let xmlParser = XMLParser(data: xmlData)
            xmlParser.parse()
        }
    }
}

extension Days: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElement = elementName
        
        if elementName == "item" {
            self.holiday = Holiday()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let currentElement = self.currentElement {
            if currentElement == HolidayItem.dateName.rawValue {
                self.holiday?.dateName = string
            }
            
            if currentElement == HolidayItem.isHoliday.rawValue {
                self.holiday?.isHoliday = string == "Y" ? true : false
            }
            
            if currentElement == HolidayItem.date.rawValue {
                self.holiday?.dateString = string
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let holiday = self.holiday {
                self.holidays.append(holiday)
                
                self.holiday = nil
            }
        }
    }
}

struct Holiday {
    var dateName: String = ""
    var dateString: String = ""
    var isHoliday: Bool = false
}
