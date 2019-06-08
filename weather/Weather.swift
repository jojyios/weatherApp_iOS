//
//  Weather.swift
//  weather
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 Bitcoin. All rights reserved.
//

import Foundation

class Weather {
    
    let temperature: Int?
    var lowTemperature: Int? = 0
    let icon: String?
    var time: Int? = 0
    var day: Double? = 0
    var strDate: String = ""
    
    struct WeatherKeys {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipProbability = "precipProbability"
        static let icon = "icon"
    }
    
    init(weatherDictonary: [String : Any]) {
        if let temp = weatherDictonary[WeatherKeys.temperature] {
            temperature = Int( ( (temp as? Double)! - 32 ) / 1.8 )
        } else {
            temperature = Int( ( (weatherDictonary["temperatureHigh"] as? Double)! - 32 ) / 1.8 )
            lowTemperature = Int( ( (weatherDictonary["temperatureLow"] as? Double)! - 32 ) / 1.8 )
            time = weatherDictonary["time"] as? Int
            let date = Date(timeIntervalSince1970: TimeInterval(time!))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "D" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            self.day = Double(strDate)
        }
        
        icon = weatherDictonary[WeatherKeys.icon] as? String
    }
}
