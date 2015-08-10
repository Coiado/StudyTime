//
//  ViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 07/08/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var student : HSStudent = HSStudent()
    var subjects : [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        subjects = populateLabels(student.subjects)
        for index in 0...self.student.subjects.count-1{
            self.view.addSubview(subjects[index])
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateLabels(subject:[String]) -> [UILabel]{
        var labels : [UILabel] = []
        var pointx : CGFloat = 50.0
        var pointy : CGFloat = 50.0
        for index in 0...subject.count-1{
            var label = UILabel(frame: CGRectMake(0, 0, 100, 21))
            label.center = CGPointMake(pointx, pointy)
            label.textAlignment = NSTextAlignment.Center
            label.text = subject[index]
            pointx = pointx + 100.0
            if pointx > self.view.frame.width-50.0{
                pointx = 50.0
                pointy = pointy + 20.0
            }
            labels.append(label)
        }
        return labels
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
