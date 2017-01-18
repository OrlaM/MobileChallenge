//
//  CurrencyModel.swift
//  MobileChallenge
//
//  Created by Orla on 17/01/2017.
//  Copyright © 2017 Orla. All rights reserved.
//

import Foundation

typealias CurrencyValue = (currencyType:String, amount:Double)

class CurrencyModel {
    
    var baseCurrency:String?
    var rates = Array<CurrencyValue>()
    
}
