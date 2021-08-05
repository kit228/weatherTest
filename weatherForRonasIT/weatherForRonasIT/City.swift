//
//  City.swift
//  weatherForRonasIT
//
//  Created by Вениамин Китченко on 24.02.2020.
//  Copyright © 2020 veniaminCompany. All rights reserved.
//

import Foundation
import UIKit

class City {
    
    let name: String
    let id: String
    
    var icon: String?
    var temp: String?
    
    var main: String?
    var wind: String?
    
    var pressure: String?
    var humidity: String?
    
    var rainPossibility: String?
    
    var lastRequestedDate: Date?
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
        
        self.icon = nil
        self.temp = nil
        
        self.main = nil
        self.wind = nil
        
        self.pressure = nil
        self.humidity = nil
        
        self.rainPossibility = nil
        
        self.lastRequestedDate = nil
    }
    

}
