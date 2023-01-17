//
//  ViewController.swift
//  PieChart
//
//  Created by Yongseok Choi on 2023/01/17.
//

import UIKit
import Charts // If The version, 4.1.0 needs to be installed via Swift Package Manager, Charts should be installed alone except ChartsDynamic from https://github.com/danielgindi/Charts.git

class ChartViewController: UIViewController {
    
    lazy var pieChartView: PieChartView = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: 15, label: "첫 번째 값"),
            PieChartDataEntry(value: 35, label: "두 번째 값"),
            PieChartDataEntry(value: 50, label: "세 번째 값"),
            //PieChartDataEntry(value: 1, label: "임시1", data: "임시1" as AnyObject),
            //PieChartDataEntry(value: 2, label: "임시1", data: "임시2" as AnyObject),
            //PieChartDataEntry(value: 3, label: "임시1", data: "임시1" as AnyObject),
        ]
        let dataSet: PieChartDataSet = PieChartDataSet(entries: dataEntries, label: "(여러 값들)")
        dataSet.colors = [
            .yellow,
            .blue,
            .green
        ]
        let data = PieChartData(dataSet: dataSet)
        
        let chartView = PieChartView()
        chartView.usePercentValuesEnabled = true
        chartView.data = data
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter)) // MARK: The 'setValueFormatter' must be called after inserting data into chartView's data
        chartView.data?.setValueTextColor(.gray)
        chartView.holeColor = .clear
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .brown

        self.view.addSubview(self.pieChartView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.pieChartView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.pieChartView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.pieChartView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.pieChartView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Selected: \(entry)")
        
        self.pieChartView.centerText = "Value: \(entry.y)"
    }
}
