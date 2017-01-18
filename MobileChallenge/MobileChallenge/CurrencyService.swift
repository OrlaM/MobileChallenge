//
//  CurrencyService.swift
//  MobileChallenge
//
//  Created by Orla on 17/01/2017.
//  Copyright © 2017 Orla. All rights reserved.
//

import Foundation

class CurrencyService {
    
    class func getCurrencyData(_ baseCurrency:String, completion: @escaping (_ result: CurrencyModel) -> Void) {
        guard let url = URL(string: "https://api.fixer.io/latest?base=\(baseCurrency)") else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        let task = session.dataTask(with: request) { (data,response,error) in
            
            guard let data = data else {
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let currencyData = json as? [String: Any] else {
                return
            }
            
            let currencyModel = CurrencyModel()
            currencyModel.baseCurrency = currencyData["base"] as? String
            
            guard let ratesData = currencyData["rates"] as? [String:Any] else {
                return
            }
            
            for (type, amount) in ratesData {
                guard let amount = amount as? Double else {
                    return
                }
                
                let value = CurrencyValue(type, amount)
                currencyModel.rates.append(value)
            }

            completion(currencyModel)
        }

        task.resume()
    }
    
}
