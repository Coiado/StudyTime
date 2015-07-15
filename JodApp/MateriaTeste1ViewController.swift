//
//  MateriaTeste1ViewController.swift
//  JodApp
//
//  Created by Ogari Pata Pacheco on 13/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Charts
import Parse


class MateriaTeste1ViewController: UIViewController {
    
 //   public class BarLineChartViewBase: ChartViewBase, UIGestureRecognizerDelegate <- Ver!
    
    @IBOutlet weak var currentLineChartView: LineChartView!
    @IBOutlet weak var pastLineChartView: LineChartView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
   // var yAxis : ChartYAxis!
    
    // Onde estão todas as semanas de estudo do aluno
    let currentTimeStudied = [0.5, 3.0, 0.5, 0.0, 1.0, 1.0, 1.5] // 7.5h totais
    var pastTimeStudied1 = [1.0, 0.5, 0.5, 1.0, 1.5, 0.0, 0.0] // 4.5h totais
    var pastTimeStudied2 = [0.5, 1.5, 1.0, 0.5, 0.5, 0.0, 0.5] // 4.5h totais
    var pastTimeStudied3 = [1.5, 1.0, 1.5, 1.0, 1.5, 0.5, 0.5] // 7.5h totais
    let days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]
    
    var cont : Int8 = 0
    var basePositionForAnimation : CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Entrou")
        
        var obj = PFObject(className: "Alunos")
        obj["tutor"] = PFUser.currentUser()
        obj["nome"] = "Ogari"
        obj.saveInBackgroundWithBlock { (sucess, error) -> Void in
            if error == nil{
                println("Salvo com sucesso")
            }
            else
            {
                println(error)
            }
        }
        
        var vetor = getStudents()
        
        for vetor in vetor{
            println(vetor)
        }
        
        println("saiu")
        
        // Do any additional setup after loading the view.
        
        // let days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]
        //let currentTimeStudied = [0.5, 3.0, 0.5, 0.0, 1.0, 1.0, 1.5] // 7.5h totais
        //  var pastTimeStudied = [1.0, 0.5, 0.5, 1.0, 1.5, 0.0, 0.0]
        
        setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
        currentLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
        pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
        
        //        self.pastLineChartView.data?.getYMax(axis: ChartYAxis.AxisDependency) // Provavelmente, a view da pagina é um let... Mesmo assim não faz muito sentido
        
        basePositionForAnimation = pastLineChartView.frame // retem a posicao inicial para a qual se deve voltar.
        
//        pastLineChartView.borderLineWidth = 3.0
//        pastLineChartView.borderColor = UIColor.blueColor()
        
    }
    
    func setChart(dataPoints: [String], currentValues: [Double], pastValues: [Double]) {
        
        var currentDataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: currentValues[i], xIndex: i)
            currentDataEntries.append(dataEntry)
        }
        
        var pastDataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: pastValues[i], xIndex: i)
            pastDataEntries.append(dataEntry)
        }
        
        let pastLineChartDataSet = LineChartDataSet(yVals: pastDataEntries, label: "Tempo de Estudo")
        let pastLineChartData = LineChartData(xVals: dataPoints, dataSet: pastLineChartDataSet)
        pastLineChartView.data = pastLineChartData
        pastLineChartView.descriptionText = ""
        pastLineChartDataSet.colors = [(UIColor.redColor())]
        pastLineChartDataSet.circleColors = [(UIColor.redColor())]
        
        
        let lineChartDataSet = LineChartDataSet(yVals: currentDataEntries, label: "Tempo de Estudo")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        currentLineChartView.data = lineChartData
        currentLineChartView.descriptionText = ""
        
    }
    
    func chartBeingShown (pastWeekChart : Int8){
        
        switch pastWeekChart
        {
        case 1:
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied2)
            pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
            
        case 2:
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied3)
            pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
            
        default:
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
            pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
            //            println("Test")
            
        }
    }
    
    
    
    
    func getStudents() -> NSArray{
        
        let user = PFUser.currentUser()
        
        var query = PFQuery(className: "Alunos")
        query.whereKey("tutor", equalTo: user!)
        return query.findObjects()!
    }
    
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        
        if self.cont < 2
        {
            
            self.cont = self.cont + 1
            chartBeingShown(cont)
            self.rightButton.hidden = false
            
            // Animacao
            pastLineChartView.frame = CGRectMake(-501, 266, 501, 266)
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.pastLineChartView.frame = self.basePositionForAnimation
                self.pastLineChartView.layoutIfNeeded()             // Fazer com as constraints
                }, completion: nil)
            
        }
        
        if self.cont == 2
        {
            self.leftButton.hidden = true
        }
        
    }
    
    
    @IBAction func nextButton(sender: AnyObject) {
        
        if self.cont > 0
        {
            self.cont = self.cont - 1
            chartBeingShown(cont)
            self.leftButton.hidden = false
            
            pastLineChartView.frame = CGRectMake(1067, 266, 501, 266)
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.pastLineChartView.frame = self.basePositionForAnimation
                self.pastLineChartView.layoutIfNeeded()             // Fazer com as constraints
                }, completion: nil)
            
        }
        
        if self.cont == 0
        {
            self.rightButton.hidden = true
        }
        
    }
    
    
}

