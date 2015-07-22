//
//  SubjectsCollectionCells.swift
//  JodApp
//
//  Created by Ogari Pata Pacheco on 15/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit

class SubjectsCollectionCells: UICollectionViewCell {
    
    @IBOutlet weak var subjectsLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
    }

}
