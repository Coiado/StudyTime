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
    var currentSubject : Int!
    var started : Bool = false
    var lastIndexPath: NSIndexPath?
    
    var tutorialView:UIView = UIView()
    
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
    
    var color: Array<UIColor>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDay()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitionManager.sourceViewController = self
        
        
        
        subjects = ["Math", "English", "Geography", "Physics" , "Biology", "Portuguese", "Chemistry", "History", "Writing"]
        
        color = [UIColor(red: 202/255, green: 25/255, blue: 19/255, alpha: 1),   //Math
                UIColor(red: 208/255, green: 182/255, blue: 14/255, alpha: 1),   //English
                UIColor(red: 210/255, green: 127/255, blue: 32/255, alpha: 1),  //Geography
                UIColor(red: 53/255, green: 89/255, blue: 188/255, alpha: 1),        //Physics
                UIColor(red: 75/255, green: 164/255, blue: 80/255, alpha: 1),   //Biology
                UIColor(red: 158/255, green: 41/255, blue: 11/255, alpha: 1),   //Portuguese
                UIColor(red: 139/255, green: 1/255, blue: 198/255, alpha: 1),  //Chemistry
                UIColor(red: 84/255, green: 93/255, blue: 106/255, alpha: 1), //History
                UIColor(red: 37/255, green: 126/255, blue: 129/255, alpha: 1)]    // Writing
        
        
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
        
        var user = PFUser.currentUser()
        
        var tempo = self.count/3600
        
        self.count = 0
        
        self.chooseSubject = false
        self.started = false
        
//        var time: PFObject = PFObject(className: "StudyTime")
//        time["tempo"] = tempo
//        time["dia"] = self.day
//        time["mes"] = self.month
//        time["ano"] = self.year
//        time["aluno"] = user!["nome"]
//        time["materia"] = currentSubject
//        time.saveEventually { (sucess, error) -> Void in
//        
//        }
        
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SubjectsCollectionCells = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SubjectsCollectionCells
        cell.subjectsLabel.text = subjects[indexPath.row]
        cell.backgroundColor = self.color[indexPath.row]
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if self.lastIndexPath != nil{
            var lastCell = collectionView.cellForItemAtIndexPath(self.lastIndexPath!) as! SubjectsCollectionCells
            lastCell.notHighlight()
        }
        
        self.currentSubject = indexPath.row
        self.chooseSubject = true
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SubjectsCollectionCells
        cell.highlight()
        
        self.lastIndexPath = indexPath
        
        println("Botao \(indexPath.row) \(self.currentSubject)selecionado") // Separar matéria aqui (onde vai salvar os dados de tempo do estudo)
    }

    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.started{
        
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SubjectsCollectionCells
            cell.notHighlight()
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !self.started
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // set transition delegate for our menu view controller
        let menu = segue.destinationViewController as! MenuViewController
        menu.transitioningDelegate = self.transitionManager
        self.transitionManager.menuViewController = menu
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
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
    @IBAction func tutorialButton(sender: AnyObject) {
        
        self.tutorialView.frame = CGRect(x: self.view.frame.width*0.05, y: self.view.frame.height * 0.05, width:
            self.view.frame.width*0.90, height: self.view.frame.height*0.90)

        self.tutorialView.backgroundColor = UIColor.purpleColor()
        
        self.tutorialView.layer.cornerRadius = 10
        
        self.view.addSubview(self.tutorialView)
        
        populateTutorialView()
        
        
    }
    
    func populateTutorialView()
    {
        var image: UIImage = UIImage(named: "tutorial.png")!
        
        var imageView:UIImageView = UIImageView(image: image)
        
        imageView.frame = self.tutorialView.bounds
        
        self.tutorialView.addSubview(imageView)
        

        
        var closeButton = UIButton()

        closeButton.setTitle("X", forState: .Normal)
        
        closeButton.layer.cornerRadius = 10
        closeButton.backgroundColor = UIColor.blackColor()
        
        closeButton.addTarget(self, action: "closeTutorial", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.frame = CGRect(x: self.tutorialView.frame.width*0.85, y: 10, width: self.tutorialView.frame.width * 0.1 ,  height: self.tutorialView.frame.width * 0.1)
        self.tutorialView.addSubview(closeButton)
        
        
    }
    
    func closeTutorial(){
        
        self.tutorialView.removeFromSuperview()
        
    }
    
}

