//
//  WeatherViewController.swift
//  weather
//
//  Created by Apple on 31/05/19.
//  Copyright © 2019 Bitcoin. All rights reserved.
//

import UIKit
import Charts

class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var DailyView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wName: UILabel!
    @IBOutlet weak var wIcon: UIImageView!
    @IBOutlet weak var wTemperature: UILabel!
    

    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var weatherArray: [Weather]? = []
    
    
    var chartData = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        wName.text = name
        
    DailyView.layer.cornerRadius = 15
    DailyView.layer.masksToBounds = true
        
        let fService = ForecastService(APIKey: "3342be0a95ee08936cddb289d649e48a")
        fService.getForecastCurently(latitude: latitude, longitudude: longitude) { (weather) in
            
            DispatchQueue.main.async {
                if let data = weather?.temperature {
                    self.wTemperature.text = "\(String(data))"
                }
                if let icon = weather?.icon {
                    self.wIcon.image = UIImage(named: icon)
                }
            }
            
        }
        
        let dFService = ForecastService(APIKey: "3342be0a95ee08936cddb289d649e48a")
        dFService.getForecastDaily(latitude: latitude, longitudude: longitude) { (weather) in
            self.weatherArray = weather?.dailyWeather
            
            for i in 0..<self.weatherArray!.count {
                
                if let time = weather!.dailyWeather[i].time {
                    let date = Date(timeIntervalSince1970: TimeInterval(time))
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "EEE, MMM D" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    self.weatherArray![i].strDate = strDate
                } else {
                    print("time error")
                    
                }
            }
            
            
        }
        
        // Do any additional setup after loading the view.
        let chart = LineChart(latitude: latitude, Longitude: longitude)
        DispatchQueue.main.async {
            chart.loadData(chartView: self.lineChartView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherArray!.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CollectionViewCell
        
        cell.icon.image = UIImage(named: weatherArray![indexPath.row].icon!)
        cell.Temperature.text = "\(weatherArray![indexPath.row].temperature!)"
        cell.date.text = weatherArray![indexPath.row].strDate
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
