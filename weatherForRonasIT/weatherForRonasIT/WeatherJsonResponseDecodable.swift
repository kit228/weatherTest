//
//  WeatherJsonResponseDecodable.swift
//  weatherForRonasIT
//
//  Created by Вениамин Китченко on 25.02.2020.
//  Copyright © 2020 veniaminCompany. All rights reserved.
//

import Foundation

class WeatherJsonResponseDecodable {
    
    struct structJsonWeatherResponse: Decodable {
        let coord: coordStruct
        let weather: [weatherStruct]
        let main: mainStruct
    }
    
    struct coordStruct: Decodable {
        let lon: Double?
        let lat: Double?
    }
    
    struct weatherStruct: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct mainStruct: Decodable {
        let temp: Double
        let pressure: Int
        let humidity: Double
        let temp_min: Double?
        let temp_max: Double?
    }
    
}
