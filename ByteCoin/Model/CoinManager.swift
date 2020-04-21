//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "EABCC9F0-6FB6-4706-B260-6B8CE8991362"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var selectedCurrencyString: String
    var delegate = CoinManagerDelegate.self
    
    func getCoinPrice(forCurrency: String) {
        let urlString = "\(baseURL)\(selectedCurrencyString)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
  
    func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate.didFailWithError(error: Error)
                return
            }
            if let safeData = data {
                if let rate = self.parseJSON(safeData) {
            delegate.didUpdateRate(self, rate: rate
                    )
                // if let weather = self.parseJSON(weather: safeData) {
                 //   delegate?.didUpdateWeather(weather: weather)
            }
        }
}
        
 }
    
            
    }
    
//JSON Parsing
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: CoinModel)
            let rate = decodedData.rate
            
            
            
            return rate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil

        }
    

    
}
