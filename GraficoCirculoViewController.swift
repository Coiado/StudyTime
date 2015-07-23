//
//  GraficoCirculoViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 16/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Charts


class GraficoCirculoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var graph: PieChartView!
    var student = HSStudent()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setMonth()
        setChart(student.subjects, values: student.studyTime)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setting Collection View number of items
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return student.months.count
    }
    
    //Setting Collection View
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : GraphicsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Grafico", forIndexPath: indexPath) as! GraphicsCollectionViewCell
        //Setting Graphics Collection View
        cell.grafico.data = setChart(student.subjects, values: student.studyTime)[indexPath.row]
        //Setting Label Graphics in Collection View
        cell.mes.text = student.months[indexPath.row]
        return cell
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) -> [PieChartData] {
        var pieChartData : [PieChartData] = []
        var dataEntries: [ChartDataEntry] = []
        var colors : [UIColor]!
        //Setting Data of Graphics
        for j in 0..<values.count{
            colors = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[j][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            var pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Study Time")
            //Setting Color of Graphics
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
    
    // set the month
    func setMonth (){
        let today = NSDate()
        var day = NSDateFormatter()
        day.dateFormat = "MM"
        var monthToday = day.stringFromDate(today).toInt()!
        monthToday--
        switch monthToday {
    case 0..<12:
        student.months.append(NSLocalizedString("January", comment: "label do grafico de meses"))
        fallthrough
    case 1..<12:
        student.months.append(NSLocalizedString("February", comment: "label do grafico de meses"))
        fallthrough
    case 2..<12:
        student.months.append(NSLocalizedString("March", comment: "label do grafico de meses"))
        fallthrough
    case 3..<12:
        student.months.append(NSLocalizedString("April", comment: "label do grafico de meses"))
        fallthrough
    case 4..<12:
        student.months.append(NSLocalizedString("May", comment: "label do grafico de meses"))
        fallthrough
    case 5..<12:
        student.months.append(NSLocalizedString("June", comment: "label do grafico de meses"))
        fallthrough
    case 6..<12:
        student.months.append(NSLocalizedString("July", comment: "label do grafico de meses"))
        fallthrough
    case 7..<12:
        student.months.append(NSLocalizedString("August", comment: "label do grafico de meses"))
        fallthrough
    case 8..<12:
        student.months.append(NSLocalizedString("September", comment: "label do grafico de meses"))
        fallthrough
    case 9..<12:
        student.months.append(NSLocalizedString("October", comment: "label do grafico de meses"))
        fallthrough
    case 10..<12:
        student.months.append(NSLocalizedString("November", comment: "label do grafico de meses"))
        fallthrough
    case 11..<12:
        student.months.append(NSLocalizedString("December", comment: "label do grafico de meses"))
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
