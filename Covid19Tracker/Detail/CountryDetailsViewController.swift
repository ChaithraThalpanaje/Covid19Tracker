//
//  CountryDetailsViewController.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import UIKit
import Charts

class CountryDetailsViewController: UIViewController {
    var viewModel: CountryDetailsViewModel!
    static func viewController() -> CountryDetailsViewController {
        return (UIStoryboard(name: "CountryDetails", bundle: nil).instantiateInitialViewController() as! UINavigationController).viewControllers.first as! CountryDetailsViewController
    }
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        guard let countryObject = viewModel.countryObject else {return}
        let dataArray = ["newConfirmed", "totalConfirmed","newDeaths","totalDeaths", "newRecovered", "totalRecovered"]
        let valueArray = [countryObject.newConfirmed, countryObject.totalConfirmed, countryObject.newDeaths, countryObject.totalDeaths, countryObject.newRecovered, countryObject.totalRecovered]
        customizeChart(dataPoints: dataArray, values: valueArray)
    }
    
    func customizeChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Covid Summary")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}
