//
//  ViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 03/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit


class ChronometerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var hourDisplay: UILabel!
    @IBOutlet weak var minuteDisplay: UILabel!
    @IBOutlet weak var secondDisplay: UILabel!
    var timer : NSTimer = NSTimer()
    
    @IBOutlet weak var buttons: UICollectionView!
    
    var startTime = NSTimeInterval ()
    
    var count : Double = 0
    
    var paused : Bool = false
    
    var subjects : Array<String>!
    
    var subjectType : NSString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("load")
        subjects = ["Literatura","Matematica","Fisica","Geografia","Historia","Biologia","Quimica","Ingles","Redacao"]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.buttons.flashScrollIndicators()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var state : UIApplicationState = UIApplication.sharedApplication().applicationState
        
        var screenBrightness : CGFloat = UIScreen.mainScreen().brightness
        
        if state == UIApplicationState.Background && screenBrightness != 0.0 {
            
        }
            
        else {
            
            //Start to count the time
            count++
            
            var elapsedTime: NSTimeInterval = count
            
            //calculate the hours
            
            let hour = UInt32(count / 3600.0)
            
            //calculate the minutes
            
            let minutes = UInt8(count / 60.0) % 60
            
            elapsedTime -= (NSTimeInterval(minutes) * 60)
            
            //calculate the seconds
            
            let seconds = UInt8(elapsedTime)
            
            elapsedTime -= NSTimeInterval(seconds)
            
            //find out the fraction of milliseconds to be displayed.
            
            let fraction = UInt16(elapsedTime * 1000)
            
            //Display time counted in Storyboard
            
            self.hourDisplay.text = String(format: "%02d", hour)
            self.minuteDisplay.text = String(format: ":%02d", minutes)
            self.secondDisplay.text = String(format: ":%02d", seconds)
            
        }
    }
    

    
    
    @IBAction func study(sender: AnyObject) {
        if (!self.timer.valid){
            let updateSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: updateSelector, userInfo: nil, repeats: true)
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    
    @IBAction func pause(sender: AnyObject) {
        timer.invalidate()
        
    }
    
    @IBAction func finish(sender: AnyObject) {
        self.timer.invalidate()
        self.count = 0
        self.hourDisplay.text = "00"
        self.minuteDisplay.text = ":00"
        self.secondDisplay.text = ":00"
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SubjectsCollectionCells = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SubjectsCollectionCells
        cell.subjectsLabel.text = subjects[indexPath.row]
        cell.backgroundColor = UIColor.blueColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Botao \(indexPath.row) selecionado") // Separar matéria aqui (onde vai salvar os dados de tempo do estudo)
    }

}

