//
//  optionsViewController.swift
//  JodApp
//
//  Created by Bruno Eiji Yoshida on 31/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    
    let transitionManager = ButtonTransition()
    
    @IBOutlet weak var teste1: UIButton!
    
    @IBOutlet weak var teste2: UIButton!
    
    @IBOutlet weak var teste3: UIButton!
    
    @IBOutlet weak var teste4: UIButton!

    @IBOutlet weak var teste5: UIButton!

    @IBOutlet weak var teste6: UIButton!

    @IBOutlet weak var teste7: UIButton!

    @IBOutlet weak var teste8: UIButton!

    @IBOutlet weak var teste9: UIButton!

    @IBOutlet weak var teste10: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.transitionManager
        
    }
    
    
}
