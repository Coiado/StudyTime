//
//  HSStudent.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 21/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import Foundation
import UIKit
import Charts

class HSStudent{
    var months : [String] = []
    var graphMonths : [PieChartView] = []
    var subjects : [String] = ["Mat", "Hist", "Geo", "Port", "Bio", "Fis", "Quim", "Red", "Ing"]
    var studyTimeJan : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeFev : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeMar : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeApr : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeMay : [Double] = [35.0, 20.0,11.0, 13.0,4.0, 2.0,8.0, 60.0,1.0]
    var studyTimeJun : [Double] = [90.0, 33.0,21.0, 14.0,6.0, 17.0,9.0, 62.0,10.0]
    var studyTimeJul : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeAug : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeSep : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeOct : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeNov : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTimeDec : [Double] = [0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0, 0.0,0.0]
    var studyTime : [[Double]]!
    
    init(){
        studyTime.append(self.studyTimeJan)
        studyTime.append(self.studyTimeFev)
        studyTime.append(self.studyTimeMar)
        studyTime.append(self.studyTimeApr)
        studyTime.append(self.studyTimeMay)
        studyTime.append(self.studyTimeJun)
        studyTime.append(self.studyTimeJul)
        studyTime.append(self.studyTimeAug)
        studyTime.append(self.studyTimeSep)
        
        
    }
}