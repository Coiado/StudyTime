//
//  TutorTableViewController.swift
//  JodApp
//
//  Created by Bruno Eiji Yoshida on 17/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Parse

class TutorTableViewController: UITableViewController {
    
    
    var array = [PFObject]()
    
    var actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        self.array = getStudents()
        
        println(array)
        
        self.actInd.stopAnimating()
        
        var backgroundView = UIView(frame: CGRectZero)
        
        self.tableView.tableFooterView = backgroundView
        
        self.tableView.backgroundColor = UIColor.grayColor()
        
        self.tableView.reloadData()
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let obj: PFObject = self.array[indexPath.row]
        
        cell.textLabel!.text = obj["nome"] as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("teste", sender: tableView)
    }
    
    
    
    func getStudents() -> [PFObject]{
        
        
        let user = PFUser.currentUser()
        
        var array = [PFObject]()
        
        actInd.startAnimating()
        
        var query = PFQuery(className: "Alunos")
        query.whereKey("tutor", equalTo: user!)
        
        array = query.findObjects() as! [PFObject]
//        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//        
//
//            if let objects = objects as? [PFObject] {
//                    for object in objects{
//                   
//                        array.append(object)
//                        println(object)
//
//                    }
//            }
//            
//        
//            
//            self.actInd.stopAnimating()
//            
//        })
//        
//        println(array)

        
        return array
    
    }
    
    
    
    
}