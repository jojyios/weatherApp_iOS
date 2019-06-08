//
//  Chart.swift
//  weather
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 Bitcoin. All rights reserved.
//


import Foundation
import Charts

class LineChart
{
    var lineChartData: [ChartDataEntry] = []
    
    init(latitude: Double, Longitude: Double) {
        let forecastService = ForecastService(APIKey: "3342be0a95ee08936cddb289d649e48a")
        forecastService.getForecastDaily(latitude: latitude, longitudude: Longitude) { (weather) in
            for i in 1..<weather!.dailyWeather.count {
                let high = Double((weather!.dailyWeather[i].temperature)!)
                let chartValue = ChartDataEntry(x: Double((weather!.dailyWeather[i].day)!), y: high)
                self.lineChartData.append(chartValue)
            }
        }
    }
    
    func loadData(chartView: LineChartView) {
        let chartDataSet = LineChartDataSet(values: self.lineChartData, label: nil)
        let chartData = LineChartData(dataSet: chartDataSet)
        
        chartView.data = chartData
    }
    
    
}
