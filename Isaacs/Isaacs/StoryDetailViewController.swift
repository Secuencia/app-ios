//
//  StoryDetailViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class StoryDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var story : Story!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerNib(UINib(nibName: "PictureCardView", bundle: nil), forCellWithReuseIdentifier: "picture_card")
        self.collectionView!.registerNib(UINib(nibName: "TextCardView", bundle: nil), forCellWithReuseIdentifier: "text_card")
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(StoryDetailViewController.handleLongGesture(_:)))
        self.collectionView!.addGestureRecognizer(longPressGesture)
        
        print("___________________ACA va la historia________________")
        print(self.story.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Espacio entre filas de coleccion
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    //Espacio entre celdas de coleccion
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return CGFloat(2.5)
    }
    
    //Numero de secciones en Coleccion
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Numero de celdas en coleccion
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //Render de celdas
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell;
        if(indexPath.row == 1){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("picture_card", forIndexPath: indexPath) as! PictureCardCollectionViewCell
        }
        else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("text_card", forIndexPath: indexPath) as! TextCardCollectionViewCell
        }
        return cell
    }
    
    //Tamaño de celdas
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return CGSizeMake(collectionView.bounds.width/2 - 2.5,100)
        }
        else{
            return CGSizeMake(collectionView.bounds.width,100)
        }
    }
    
    //Movimiento de celdas
    override func collectionView(collectionView: UICollectionView,moveItemAtIndexPath sourceIndexPath:NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // move your data order
    }
    
    //Manejo de sostenido sobre celda
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.collectionView!.indexPathForItemAtPoint(gesture.locationInView(self.collectionView))
                else {
                    break
                }
            self.collectionView!.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            self.collectionView!.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            self.collectionView!.endInteractiveMovement()
        default:
            self.collectionView!.cancelInteractiveMovement()
        }
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
