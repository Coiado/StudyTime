//
//  MateriaTeste1ViewController.swift
//  JodApp
//
//  Created by Ogari Pata Pacheco on 13/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.

import UIKit
import Charts

class MateriaTeste1ViewController: UIViewController {
    
 //   public class BarLineChartViewBase: ChartViewBase, UIGestureRecognizerDelegate <- Ver!
//    public class ChartAxisBase: ChartComponentBase
    
//  var y  : ChartAxisBase
//    var x  : BarLineChartViewBase

    
    @IBOutlet weak var currentLineChartView: LineChartView!
    @IBOutlet weak var pastLineChartView: LineChartView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
   // var yAxis : ChartYAxis!
        
    // Onde estão todas as semanas de estudo do aluno
    let currentTimeStudied = [0.5, 3.0, 0.5, 0.0, 1.0, 1.0, 1.5] // 7.5h totais
    var pastTimeStudied1 = [1.0, 0.5, 0.5, 1.0, 1.5, 0.0, 0.0] // 4.5h totais
    var pastTimeStudied2 = [0.5, 1.5, 1.0, 0.5, 0.5, 0.0, 0.5] // 4.5h totais
    var pastTimeStudied3 = [4.5, 1.0, 1.5, 1.0, 1.5, 0.5, 0.5] // 7.5h totais
    let days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]
    
    // Contador das "páginas" dos gráficos de semanas passadas
    var cont : Int8 = 0
    
    // Necessário para a animação de mudança de gráfico passado
    var basePositionForAnimation : CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
//        currentLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
//        pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
        
        chartBeingShown(cont)
        
        
        basePositionForAnimation = pastLineChartView.frame // retem a posicao inicial para a qual se deve voltar.
        
//        pastLineChartView.borderLineWidth = 3.0
//        pastLineChartView.borderColor = UIColor.blueColor()
        
    }
    
    // MARK: - Desenho e plotagem
    
    // Método que define os dados de cada gráfico (os plota e desenha)
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
    
    // MARK: - Metodos auxiliares para a exibição dos gráficos
    
    // Metodo que define qual gráfico possui a maior hora no eixo Y
    func highestHourComparison(week1:[Double], week2:[Double]) -> Double
    {
        var sortedArray1 = week1
        var sortedArray2 = week2

        sortedArray1.sort {return $0 < $1} // Pq aqui o negócio eh profissa!!
        sortedArray2.sort {return $0 < $1} // Perguntar sobre shorthand arguments
        
        if sortedArray1.last > sortedArray2.last
        {
            return sortedArray1.last!
        }
        
        else if sortedArray1.last < sortedArray2.last
        {
            return sortedArray2.last!
        }
        
        else
        {
            return sortedArray1.last!
        }
    }
    
    // Criada meramente para tornar menos repetitivo e extender o código desnecessariamente. (Usado logo abaixo)
    func auxAnimationTransition() {
        
        currentLineChartView.leftAxis.customAxisMax = pastLineChartView.leftAxis.customAxisMax
        currentLineChartView.rightAxis.customAxisMax = pastLineChartView.rightAxis.customAxisMax
        UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.currentLineChartView.alpha = 0.0
            }, completion: nil)
        UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.currentLineChartView.alpha = 1.0
            }, completion: nil)
    }
    
    // Metodo que define qual gráfico aparecerá abaixo
    func chartBeingShown (pastWeekChart : Int8){
        
        switch pastWeekChart
        {
        case 1:
            
            // É definido qual gráfico deve ter seu Y maximo alterado e com qual valor
            
            // Aqui verifica-se qual gráfico tem mais horas, resultando na modificação necessária de acordo com isso
            if contains(currentTimeStudied, highestHourComparison(currentTimeStudied, week2: pastTimeStudied2))
            {
            
                pastLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied2)
                pastLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied2)
                
                if currentLineChartView.leftAxis.customAxisMax != pastLineChartView.leftAxis.customAxisMax {
                    
                    auxAnimationTransition()
                    
                    // Animacao de gráfico de baixo para cima.
//                    currentLineChartView.animate(yAxisDuration: 2.0, easing: { (elapsed, duration) -> CGFloat in
//                        var position = (self.currentLineChartView.scaleY/((CGFloat((elapsed)/duration))))
//                        return position
//                    })
                }
            
            }
            
            else
            {
                // Ocorre caso o número máximo atingido, seja de alguma semana anterior
                
//                let yAxisMaxInitial = currentLineChartView.leftAxis.customAxisMax
                currentLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied2)
                currentLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied2)
                setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied2)
                
//                // Animacao de gráfico de baixo para cima.
//                currentLineChartView.animate(yAxisDuration: 2.0, easing: { (elapsed, duration) -> CGFloat in
//                    var position = (self.currentLineChartView.scaleY/((CGFloat((elapsed)/duration))))
//                    return position
//                })
                
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 0.0
                    }, completion: nil)
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 1.0
                    }, completion: nil)
                
                
                if pastLineChartView.leftAxis.customAxisMax != currentLineChartView.leftAxis.customAxisMax {
                
                    pastLineChartView.leftAxis.customAxisMax = currentLineChartView.leftAxis.customAxisMax
                    pastLineChartView.rightAxis.customAxisMax = currentLineChartView.rightAxis.customAxisMax

                }
            
            }
            
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied2)
            pastLineChartView.animate(yAxisDuration: 2.0)
            
        case 2:
            
            if contains(currentTimeStudied, highestHourComparison(currentTimeStudied, week2: pastTimeStudied3))
            {
                
                pastLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied3)
                pastLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied3)
                
                if currentLineChartView.leftAxis.customAxisMax != pastLineChartView.leftAxis.customAxisMax {
                    
                    auxAnimationTransition()

                }
//                setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
//                
            }
                
            else
            {
                currentLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied3)
                currentLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied3)
                setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied3)
//                currentLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
                
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 0.0
                    }, completion: nil)
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 1.0
                    }, completion: nil)
                
                if pastLineChartView.leftAxis.customAxisMax != currentLineChartView.leftAxis.customAxisMax {
                    
                    pastLineChartView.leftAxis.customAxisMax = currentLineChartView.leftAxis.customAxisMax
                    pastLineChartView.rightAxis.customAxisMax = currentLineChartView.rightAxis.customAxisMax
                    
                }
                
            }
            
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied3)
            pastLineChartView.animate(yAxisDuration: 2.0)
            
        default:
            
            if contains(currentTimeStudied, highestHourComparison(currentTimeStudied, week2: pastTimeStudied1))
            {
                
                pastLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied1)
                pastLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied1)
                
                if currentLineChartView.leftAxis.customAxisMax != pastLineChartView.leftAxis.customAxisMax {
                    
                    auxAnimationTransition()
                }
            }
                
            else
            {
                currentLineChartView.leftAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied1)
                currentLineChartView.rightAxis.customAxisMax = highestHourComparison(currentTimeStudied, week2: pastTimeStudied1)
                setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
//                currentLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
                
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 0.0
                    }, completion: nil)
                UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                    self.currentLineChartView.alpha = 1.0
                    }, completion: nil)

                
                if pastLineChartView.leftAxis.customAxisMax != currentLineChartView.leftAxis.customAxisMax {
                    
                    pastLineChartView.leftAxis.customAxisMax = currentLineChartView.leftAxis.customAxisMax
                    pastLineChartView.rightAxis.customAxisMax = currentLineChartView.rightAxis.customAxisMax
                    
                }
                
            }
            
            setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
            pastLineChartView.animate(yAxisDuration: 2.0)
            //            println("Test")
            
        }
    }
    
    // MARK: - Métodos de mudança de gráficos passados (gráficos de baixo)
    
    @IBAction func backButton(sender: AnyObject) {
        
        if self.cont < 2
        {
            
            self.cont = self.cont + 1
            chartBeingShown(cont)
            self.rightButton.hidden = false
            
            // Animacao
            pastLineChartView.frame = CGRectMake(-501, 266, 501, 266) // Precisam-se ajeitar constraints
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.pastLineChartView.frame = self.basePositionForAnimation
                self.pastLineChartView.layoutIfNeeded()
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
            
            pastLineChartView.frame = CGRectMake(1067, 266, 501, 266) // Precisam-se ajeitar constraints
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.pastLineChartView.frame = self.basePositionForAnimation
                self.pastLineChartView.layoutIfNeeded()
                }, completion: nil)
            
        }
        
        if self.cont == 0
        {
            self.rightButton.hidden = true
        }
        
    }
    
    
}

