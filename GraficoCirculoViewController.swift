//
//  GraficoCirculoViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 16/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Charts


class GraficoCirculoViewController: UIViewController{

    var student = HSStudent()
    var color = [UIColor(red: 202/255, green: 25/255, blue: 19/255, alpha: 1),   //Math
                 UIColor(red: 208/255, green: 182/255, blue: 14/255, alpha: 1),  //English
                 UIColor(red: 210/255, green: 127/255, blue: 32/255, alpha: 1),  //Geography
                 UIColor(red: 53/255, green: 89/255, blue: 188/255, alpha: 1),   //Physics
                 UIColor(red: 75/255, green: 164/255, blue: 80/255, alpha: 1),   //Biology
                 UIColor(red: 158/255, green: 41/255, blue: 11/255, alpha: 1),   //Portuguese
                 UIColor(red: 139/255, green: 1/255, blue: 198/255, alpha: 1),   //Chemistry
                 UIColor(red: 84/255, green: 93/255, blue: 106/255, alpha: 1),   //History
                 UIColor(red: 37/255, green: 126/255, blue: 129/255, alpha: 1)]  //Writing
    var monthToday : Int!
    var pieChartData : [PieChartData] = []
    var currentGraphic : Int = 1
    
  
    @IBOutlet weak var pieChartView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let today = NSDate()
        var day = NSDateFormatter()
        day.dateFormat = "MM"
        self.monthToday = day.stringFromDate(today).toInt()!
        setMonth()
        self.pieChartData =  setChart(student.subjects, values: student.studyTime)
        self.pieChartView.data = self.pieChartData[self.currentGraphic]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftChart(sender: AnyObject) {
        if self.currentGraphic > 0{
            self.currentGraphic--
            self.pieChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.3)
            self.pieChartView.data = self.pieChartData[self.currentGraphic]
        }
    }
    
    @IBAction func rightChart(sender: AnyObject) {
        if self.currentGraphic < self.pieChartData.count{
            self.currentGraphic++
            self.pieChartView.data = self.pieChartData[self.currentGraphic]
            self.pieChartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.3)
        }
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) -> [PieChartData] {
        var pieChartData : [PieChartData] = []
        //Setting Data of Graphics
        for j in 0..<self.monthToday{
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[j][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            var pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Study Time")
//            Setting Color of Graphics
            pieChartDataSet.colors = color
            pieChartDataSet.highlightEnabled = false
            pieChartData.append(PieChartData(xVals: dataPoints, dataSet: pieChartDataSet))
        }
        return pieChartData
    }
    
    // set the month
    func setMonth (){
        switch self.monthToday {
        case 11..<12:
            student.months.append(NSLocalizedString("December", comment: "label do grafico de meses"))
            fallthrough
        case 10..<12:
            student.months.append(NSLocalizedString("November", comment: "label do grafico de meses"))
            fallthrough
        case 9..<12:
            student.months.append(NSLocalizedString("October", comment: "label do grafico de meses"))
            fallthrough
        case 8..<12:
            student.months.append(NSLocalizedString("September", comment: "label do grafico de meses"))
            fallthrough
        case 7..<12:
            student.months.append(NSLocalizedString("August", comment: "label do grafico de meses"))
            fallthrough
        case 6..<12:
            student.months.append(NSLocalizedString("July", comment: "label do grafico de meses"))
            fallthrough
        case 5..<12:
            student.months.append(NSLocalizedString("June", comment: "label do grafico de meses"))
            fallthrough
        case 4..<12:
            student.months.append(NSLocalizedString("May", comment: "label do grafico de meses"))
            fallthrough
        case 3..<12:
            student.months.append(NSLocalizedString("April", comment: "label do grafico de meses"))
            fallthrough
        case 2..<12:
            student.months.append(NSLocalizedString("March", comment: "label do grafico de meses"))
            fallthrough
        case 1..<12:
            student.months.append(NSLocalizedString("February", comment: "label do grafico de meses"))
            fallthrough
        case 0..<12:
            student.months.append(NSLocalizedString("January", comment: "label do grafico de meses"))
            fallthrough
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
