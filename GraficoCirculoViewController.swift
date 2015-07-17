//
//  GraficoCirculoViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 16/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Charts

class GraficoCirculoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var graph: PieChartView!
    var months : [String] = ["Janeiro","Fevereiro","Março"]
    var graphJan : PieChartView!
    var graphFev : PieChartView!
    var graphMar : PieChartView!
    var graphMonths : [PieChartView] = []
    var subjects : [String] = ["Mat", "Hist", "Geo", "Port", "Bio", "Fis", "Quim", "Red", "Ing"]
    var studyTimeJan : [Double] = [50.0, 40.0,20.0, 30.0,5.0, 10.0,45.0, 55.0,15.0]
    var studyTimeFev : [Double] = [35.0, 20.0,11.0, 13.0,4.0, 2.0,8.0, 60.0,1.0]
    var studyTimeMar : [Double] = [90.0, 33.0,21.0, 14.0,6.0, 17.0,9.0, 62.0,10.0]
    var studyTime : [[Double]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.studyTime = [self.studyTimeJan,self.studyTimeFev,self.studyTimeMar]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : GraphicsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Grafico", forIndexPath: indexPath) as! GraphicsCollectionViewCell
        cell.grafico.data = setChart(subjects, values: self.studyTime)[indexPath.row]
        cell.mes.text = months[indexPath.row]
        return cell
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) -> [PieChartData] {
        var pieChartData : [PieChartData] = []
        var dataEntries: [ChartDataEntry] = []
        var colors : [UIColor]!
        for j in 0..<values.count{
            colors = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[j][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            var pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Study Time")
            for j in 0..<dataPoints.count{
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
            pieChartDataSet.colors = colors
            pieChartData.append(PieChartData(xVals: dataPoints, dataSet: pieChartDataSet))
            
        }
        return pieChartData
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
