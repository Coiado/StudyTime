//
//  MateriaTeste1ViewController.swift
//  JodApp
//
//  Created by Ogari Pata Pacheco on 13/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.

import UIKit
import Charts
import Parse



class MateriaTeste1ViewController: UIViewController {
    
 //   public class BarLineChartViewBase: ChartViewBase, UIGestureRecognizerDelegate <- Ver!
//    public class ChartAxisBase: ChartComponentBase
    
//  var y  : ChartAxisBase
//    var x  : BarLineChartViewBase

    let transitionManager = TransitionManager()
    
    @IBOutlet weak var currentLineChartView: LineChartView!
    @IBOutlet weak var pastLineChartView: LineChartView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
   // var yAxis : ChartYAxis!
        
    // Onde estão todas as semanas de estudo do aluno
    var currentTimeStudied = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] // 7.5h totais
    var pastTimeStudied1 = [1.0, 0.5, 0.5, 1.0, 1.5, 0.0, 0.0] // 4.5h totais
    var pastTimeStudied2 = [0.5, 1.5, 1.0, 0.5, 0.5, 0.0, 0.5] // 4.5h totais
    var pastTimeStudied3 = [4.5, 1.0, 1.5, 1.0, 1.5, 0.5, 0.5] // 7.5h totais
    var currentDays = [NSLocalizedString("Mon", comment: "Monday"), NSLocalizedString("Tue", comment: "Tuesday"), NSLocalizedString("Wed", comment: "Wednesday"), NSLocalizedString("Thu", comment: "Thursday"), NSLocalizedString("Fri", comment: "Friday"), NSLocalizedString("Sat", comment: "Saturday"), NSLocalizedString("Sun", comment: "Sunday")]
    
    // Contador das "páginas" dos gráficos de semanas passadas
    var cont : Int8 = 0
    
    // Necessário para a animação de mudança de gráfico passado
    var basePositionForAnimation : CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionManager.sourceViewController = self

//        setChart(days, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
//        currentLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
//        pastLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.Linear)
        
        chartBeingShown(cont)
        
        
        basePositionForAnimation = pastLineChartView.frame // retem a posicao inicial para a qual se deve voltar.
        
//        pastLineChartView.borderLineWidth = 3.0
//        pastLineChartView.borderColor = UIColor.blueColor()
        
    }
    
    // Metodo que retorna o dia da semana, dado o valor de entrada de um weekDay
    func auxDiaDaSemana(dia: Int) -> String{
    
        switch dia
        {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            println("ERROR! Dia da semana inexistente!")
            return ""
        }
    }
    
    func getChartsData(nomeDoAluno: String, materiaEstudada : Int){

        // Define-se a variacao de dias total, desde quando ele comecou até o dia atual
        var comecou = "2010-09-01" // NSDate()
        var parou = "2010-09-05"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var diaInicial:NSDate = dateFormatter.dateFromString(comecou)!
        var diaFinal:NSDate = dateFormatter.dateFromString(parou)!
        
        let calendario = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .CalendarUnitDay
        
        let components = calendario.components(unit, fromDate: diaInicial, toDate: diaFinal, options: nil)
        

        
        // Recebida a variação total de dias
        var  totalDeDias : Int =  components.day
        var totalDeSemanas : Int
        
        var auxDeCurrentDays : Int = 0
        
        //Define-se o total de semanas
            if (totalDeDias%7 == 0) { totalDeSemanas = totalDeDias/7 }
        
            else {totalDeSemanas = (totalDeDias/7) + 1}
        
//------------------------------  ------------------------------  ------------------------------
//                                Funções para o gráfico atual
//------------------------------  ------------------------------  ------------------------------
        
        // Caso ele não tenha uma semana completa, segue a função
            if (totalDeDias%7 != 0)
            {
            
            var aux : Int = ((totalDeDias%7)) // Por enquanto acho q agora foi.
                
                // Responsavel por definir primeira semana (dados a serem plotados no gráfico de cima)
                for var i = 0; i < aux; i++
                {
                    var  primeiroDiaDaSemana : NSDate = diaFinal.dateByAddingTimeInterval(Double(-(((aux - 1) + i)*24*60*60)))
                    
                    var itensDaData = calendario.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: primeiroDiaDaSemana)
                    
                    // É feita e afunilada a pesquisa para se pegar o dado de tempo, no determinado dia de estudo
                    var query = PFQuery(className:"StudyTime")
                    
                    query.whereKey("aluno", matchesRegex: nomeDoAluno)
                    query.whereKey( "materia", equalTo: materiaEstudada)
                    query.whereKey( "dia", equalTo: itensDaData.day)
                    query.whereKey( "mes", equalTo: itensDaData.month)
                    query.whereKey( "ano", equalTo: itensDaData.year)
                    
                    // Passa os dias dessa semana
                    currentDays[i] = NSLocalizedString(auxDiaDaSemana(itensDaData.weekday), comment: "dias da semana")
                    
                    //Assim, na última rodada do FOR, terá acumulado o último dia dessa semana
                    auxDeCurrentDays = itensDaData.weekday
                    
                    var tempo : Array = query.findObjects()!
                    var tempoTotal : Double = 0.0
                    
                        if tempo.isEmpty { currentTimeStudied[i] = 0.0 } // Verifica se o aluno não estudou nada da matéria no dia
                    
                        else
                        {
                            // Calcula as horas totais de estudo do cara, no dia. Já que ele pode terminar e voltar a estudar a mesma matéria ao longo do dia
                            for var j = 0; j < tempo.count; j++
                            {
                                tempoTotal = tempoTotal + (tempo[j]["tempo"] as! Double)
                            }
                            currentTimeStudied[i] = tempoTotal
                        }
                    
              //      itensDaData.weekday -> 1 is Sunday, 2 is Monday and so forth...
                    
                }
                
                // Essa parte serve para preencher a semana com os demais até completar 7, por mais que eles não tenham ocorrido ainda
                for var m = 0; m < (7 - currentDays.count); m++
                {
                
                    if (auxDeCurrentDays + 1) < 8
                    { currentDays.append(NSLocalizedString(auxDiaDaSemana(auxDeCurrentDays), comment: "dias da semana"))
                        auxDeCurrentDays = auxDeCurrentDays + 1
                    }
                    
                    else {
                        auxDeCurrentDays = auxDeCurrentDays - 7
                        currentDays.append(NSLocalizedString(auxDiaDaSemana(auxDeCurrentDays), comment: "dias da semana"))
                        }
                    
                }
                
                // Abaixo, completamos o gráfico com 0 horas, nos dias que faltam (ainda nem chegaram)
                for var n = 0; n < 7 - currentTimeStudied.count; n++ {currentTimeStudied.append(0.0)}
            }
        
            // Funcao para o caso de uma semana normal, de 7 dias (extremamente semelhante á funcao de cima)
            else
            {
                for var i = -6; i < 1; i++
                {
                    var  primeiroDiaDaSemana : NSDate = diaFinal.dateByAddingTimeInterval(Double(-((i)*24*60*60)))
                    
                    var itensDaData = calendario.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: primeiroDiaDaSemana)
                    
                    var query = PFQuery(className:"StudyTime")
                    
                    query.whereKey("aluno", matchesRegex: nomeDoAluno)
                    query.whereKey( "materia", equalTo: materiaEstudada)
                    query.whereKey( "dia", equalTo: itensDaData.day)
                    query.whereKey( "mes", equalTo: itensDaData.month)
                    query.whereKey( "ano", equalTo: itensDaData.year)
                    
                    currentDays[i + 6] = NSLocalizedString(auxDiaDaSemana(itensDaData.weekday), comment: "dias da semana")
                    
                    auxDeCurrentDays = itensDaData.weekday
                    
                    var tempo : Array = query.findObjects()!
                    var tempoTotal : Double = 0.0
                    
                    if tempo.isEmpty { currentTimeStudied[i + 6] = 0.0 } // Verifica se o aluno não estudou nada da matéria no dia
                        
                    else
                    {
                        for var j = 0; j < tempo.count; j++
                        {
                            tempoTotal = tempoTotal + (tempo[j]["tempo"] as! Double)
                        }
                        currentTimeStudied[i + 6] = tempoTotal
                    }
                    
                    //      itensDaData.weekday -> 1 is Sunday, 2 is Monday and so forth...
                    
                }
                
                // Essa parte serve para preencher a semana com os demais até completar 7, por mais que eles não tenham ocorrido ainda
                for var m = 0; m < (7 - currentDays.count); m++
                {
                    
                    if (auxDeCurrentDays + 1) < 8
                    { currentDays.append(NSLocalizedString(auxDiaDaSemana(auxDeCurrentDays), comment: "dias da semana"))
                        auxDeCurrentDays = auxDeCurrentDays + 1
                    }
                        
                    else {
                        auxDeCurrentDays = auxDeCurrentDays - 7
                        currentDays.append(NSLocalizedString(auxDiaDaSemana(auxDeCurrentDays), comment: "dias da semana"))
                    }
                    
                }

            }
        
        //------------------------------  ------------------------------  ------------------------------
        //                                Funções para os gráficos passados
        //------------------------------  ------------------------------  ------------------------------
        
        var dadosDeGraficosPassados : Array<Array<Double>>
        var semanaEmQuestao : Array<Double>
        
        for var a = 0; a < (totalDeSemanas - 1); a++
        {
        
            for var b = 0; b < 7; b++ {
            
//                semanaEmQuestao[b] = diaInicial
                
            }
            
        }
        
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
        
        let pastLineChartDataSet = LineChartDataSet(yVals: pastDataEntries, label: NSLocalizedString("Study Time", comment: "Time studied"))
        let pastLineChartData = LineChartData(xVals: dataPoints, dataSet: pastLineChartDataSet)
        pastLineChartView.data = pastLineChartData
        pastLineChartView.descriptionText = ""
        pastLineChartDataSet.colors = [(UIColor.redColor())]
        pastLineChartDataSet.circleColors = [(UIColor.redColor())]
        
        
        let lineChartDataSet = LineChartDataSet(yVals: currentDataEntries, label: NSLocalizedString("Study Time", comment: "Time studied"))
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
                setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied2)
                
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
            
            setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied2)
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
                setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied3)
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
            
            setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied3)
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
                setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
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
            
            setChart(currentDays, currentValues: currentTimeStudied, pastValues: pastTimeStudied1)
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
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){

    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // set transition delegate for our menu view controller
        let menu = segue.destinationViewController as! MenuViewController
        menu.transitioningDelegate = self.transitionManager
        self.transitionManager.menuViewController = menu
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    
}

