//
//  WeatherTableView.swift
//  weather
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 Bitcoin. All rights reserved.
//

import UIKit

class WeatherTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var weatherTableView: UITableView!
    
    
    var regions: [Region] = [Region(name: "London", latitude: 51.508530, longitude: -0.076132),
                             Region(name: "Tokyo", latitude: 35.652832, longitude: 139.839478)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        weatherTableView.rowHeight = 170
        
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeatherTableViewCell
        
        cell!.imagewall.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell!.imagewall.layer.shadowColor = UIColor.black.cgColor
        cell!.imagewall.layer.shadowRadius = 3
        cell!.imagewall.layer.shadowOpacity = 0.8
        
        cell!.imagewall.layer.cornerRadius = 15
        cell!.imagewall.layer.masksToBounds = false
        
        let forecastServise = ForecastService(APIKey: "3342be0a95ee08936cddb289d649e48a")
        forecastServise.getForecastCurently(latitude: regions[indexPath.row].latitude, longitudude: regions[indexPath.row].longitude) { (weather) in
            
            DispatchQueue.main.async {
                
                cell?.regionName.text = self.regions[indexPath.row].name
                if let data = weather?.temperature! {
                    cell?.temp.text = "\(String(data))"
                }
                
                if let icon = weather?.icon {
                    cell?.icon.image = UIImage(named: icon)
                }
                
            }
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        
        viewController.name = regions[indexPath.row].name
        viewController.latitude = regions[indexPath.row].latitude
        viewController.longitude = regions[indexPath.row].longitude
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
