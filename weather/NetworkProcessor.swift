//
//  NetworkProcessor.swift
//  WeatherApp
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 Bitcoin. All rights reserved.
//

import Foundation

class NetworkProcessor
{
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: configuration)
    
    var url : URL
    
    init(url: URL) {
        self.url = url
    }
    
    typealias JSONDictonaryHandler = (([String: Any]?) -> Void)
    
    func downloadJSONFromUrl(complation: @escaping JSONDictonaryHandler) {
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200 :
                        if let data = data {
                            do {
                                let jsonDictonary = try JSONSerialization.jsonObject(with: data, options: [])
                                complation(jsonDictonary as? [String : Any])
                            } catch let error as NSError {
                                print("Errore While Serialization: \(error.localizedDescription)")
                            }
                        }
                    default:
                        print("Status Code: \(httpResponse.statusCode)")
                    }
                }
                
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            }.resume()
    }
    
}
