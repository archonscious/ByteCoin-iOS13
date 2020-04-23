//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "EABCC9F0-6FB6-4706-B260-6B8CE8991362"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
   
    var delegate: CoinManagerDelegate?
    
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        
        
        if let url = URL(string: urlString) {
        
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
                
            if let safeData = data {
                if let bitCoinRate = self.parseJSON(safeData) {
                    let rateString =  String(format: "%.2f", bitCoinRate)
                    self.delegate?.didUpdateRate(rate: rateString, currency: currency)
                   
                
            }
        }
    }
        task.resume()
 }
    
            
}
    
//JSON Parsing
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: coinData)
            let rate = decodedData.rate
           print(rate)
            return rate
            
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil

        }
    
       
        }
    
}

