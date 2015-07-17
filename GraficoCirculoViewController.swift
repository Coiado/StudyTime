//
//  GraficoCirculoViewController.swift
//  JodApp
//
//  Created by Lucas Coiado Mota on 16/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Charts

class GraficoCirculoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var meses : [String] = ["janeiro","fevereiro","marco"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : GraphicsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Grafico", forIndexPath: indexPath) as! GraphicsCollectionViewCell
        cell.mes.text = meses[indexPath.row]
        return cell
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
