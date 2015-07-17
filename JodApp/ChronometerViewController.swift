//
//  ViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 03/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Parse


class ChronometerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let transitionManager = TransitionManager()
    
    var day:Int = Int()
    var month:Int = Int()
    var year:Int = Int()
    var weekday:Int = Int()
    var currentSubject : String!
    var started : Bool = false
    
    
    @IBOutlet weak var hourDisplay: UILabel!
    @IBOutlet weak var minuteDisplay: UILabel!
    @IBOutlet weak var secondDisplay: UILabel!
    var timer : NSTimer = NSTimer()
    
    @IBOutlet weak var buttons: UICollectionView!
    
    var chooseSubject : Bool = false
    
    var startTime = NSTimeInterval ()
    
    var count : Double = 0
    
    var paused : Bool = false
    
//    @IBOutlet weak var buttons: UICollectionView!
    
    var subjects : Array<String>!
    
    var subjectType : NSString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDay()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitionManager.sourceViewController = self
        
        subjects = ["Matematica", "Historia", "Geografia", "Portugues", "Biologia", "Fisica", "Quimica", "Redacao", "Ingles"]
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
            
            let minutes = UInt32(count / 60.0) % 60
            
            elapsedTime -= (NSTimeInterval(minutes) * 60)
            elapsedTime -= (NSTimeInterval(hour) * 3600)
            
            
            //calculate the seconds
            
            let seconds = UInt32(elapsedTime)
            
            elapsedTime -= NSTimeInterval(seconds)
            
            //Display time counted in Storyboard
            
            self.hourDisplay.text = String(format: "%02d", hour)
            self.minuteDisplay.text = String(format: ":%02d", minutes)
            self.secondDisplay.text = String(format: ":%02d", seconds)
            
        }
    }
    

    
    
    @IBAction func study(sender: AnyObject) {
        if (!self.timer.valid) && self.chooseSubject {
            let updateSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: updateSelector, userInfo: nil, repeats: true)
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            self.started = true
        }
    }
    
    
    @IBAction func pause(sender: AnyObject) {
        timer.invalidate()
        
    }
    
    @IBAction func finish(sender: AnyObject) {
        self.timer.invalidate()
        self.hourDisplay.text = "00"
        self.minuteDisplay.text = ":00"
        self.secondDisplay.text = ":00"
        
        var tempo = self.count/3600
        
        self.count = 0
        
        self.chooseSubject = false
        self.started = false
        
//        var time: PFObject = PFObject(className: "StudyTime")
//        time["tempo"] = tempo
//        time["dia"] = self.day
//        time["mes"] = self.month
//        time["ano"] = self.year
//        time["aluno"] = 
//        time.saveEventually { (sucess, error) -> Void in
//        
//        }
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        println("Teste")
    
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SubjectsCollectionCells = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SubjectsCollectionCells
        cell.subjectsLabel.text = subjects[indexPath.row]
        cell.backgroundColor = UIColor.blueColor()

        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.started{
            self.currentSubject = self.subjects[indexPath.row]
            self.chooseSubject = true
        }
        
        println("Botao \(indexPath.row) \(self.currentSubject)selecionado") // Separar matéria aqui (onde vai salvar os dados de tempo do estudo)
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // set transition delegate for our menu view controller
        let menu = segue.destinationViewController as! MenuViewController
        menu.transitioningDelegate = self.transitionManager
        self.transitionManager.menuViewController = menu
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.presentingViewController == nil ? UIStatusBarStyle.Default : UIStatusBarStyle.LightContent
    }

    
    func getDay(){
        let today = NSDate()
        
        var day = NSDateFormatter()
        day.dateFormat = "dd"
        self.day = day.stringFromDate(today).toInt()!
        
        day.dateFormat = "MM"
        self.month = day.stringFromDate(today).toInt()!
        
        day.dateFormat = "yyyy"
        self.year = day.stringFromDate(today).toInt()!
        
        day.dateFormat = "e"
        self.weekday = day.stringFromDate(today).toInt()!
        
    }
}

