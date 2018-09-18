//
//  Model.swift
//  mvp
//
//  Created by 山下翔平 on 2018/08/18.
//  Copyright © 2018年 山下翔平. All rights reserved.
//

import Foundation

class Store {
    var name : String?
    var genre : String?
    var langitude : Double?
    var longitude : Double?
    var lunchTime : String?
    var lunchBudget : String?
    var dinnerBudget : String?
    
    init(restaurant : [String]) {
        self.name = restaurant[0]
        self.genre = restaurant[1]
        self.langitude = Double(restaurant[2])
        self.longitude = Double(restaurant[3])
        self.lunchTime = restaurant[4]
        self.lunchBudget = restaurant[6]
        self.dinnerBudget = restaurant[7]
    }
}
