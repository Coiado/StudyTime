//
//  teste.swift
//  JodApp
//
//  Created by Bruno Eiji Yoshida on 14/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Parse

class teste: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("Entrou")
//        
//        var obj = PFObject(className: "Alunos")
//        obj["tutor"] = PFUser.currentUser()
//        obj["nome"] = "Ogari"
//        obj.saveInBackgroundWithBlock { (sucess, error) -> Void in
//            if error == nil{
//                println("Salvo com sucesso")
//            }
//            else
//            {
//                println(error)
//            }
//        }
        
        //var vetor = getStudents()
        
//        for vetor in vetor{
//            println(vetor["portugues"])
//        }
        
        println("saiu")
    }
    
    func getStudents() -> NSArray{
        
        let user = PFUser.currentUser()
        
        
//        
//        var array = [AnyObject]()
//        
        var query = PFQuery(className: "Alunos")
        query.whereKey("tutor", equalTo: user!)
        return query.findObjects()!
//
//        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//        
//            if let objects = objects as? [PFObject] {
//                for object in objects{
//               
//                    array.append(object)
//            
//                }
//            }
//            
//        })
//        return array
    }

    
}
