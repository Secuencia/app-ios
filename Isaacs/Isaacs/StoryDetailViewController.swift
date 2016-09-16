//
//  StoryDetailViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class StoryDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    enum factors: CGFloat{
        case Full = 1
        case Half = 0.49
        case Double = 2
    }
    
    var sizes = [String: (CGFloat, CGFloat)]()
    
    var story : Story!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizes[Content.types.Audio.rawValue] = (factors.Full.rawValue, factors.Half.rawValue)
        sizes[Content.types.Contact.rawValue] = (factors.Half.rawValue, factors.Double.rawValue)
        sizes[Content.types.Picture.rawValue] = (factors.Half.rawValue, factors.Double.rawValue)
        sizes[Content.types.Text.rawValue] = (factors.Full.rawValue, factors.Double.rawValue)
        self.collectionView!.registerNib(UINib(nibName: "PictureCardView", bundle: nil), forCellWithReuseIdentifier: "picture_card")
        self.collectionView!.registerNib(UINib(nibName: "TextCardView", bundle: nil), forCellWithReuseIdentifier: "text_card")
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(StoryDetailViewController.handleLongGesture(_:)))
        self.collectionView!.addGestureRecognizer(longPressGesture)
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
    
    //Espacio entre secciones
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 5, 0)
    }
    
    //Numero de secciones en Coleccion
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //Numero de celdas en coleccion
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numCells:Int
        if(section == 0){
            numCells = 1
        }
        else{
            numCells = (self.story.contents?.count)!
        }
        return numCells
    }
    
    //Render de celdas
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell;
        if(indexPath.section == 0){
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("title_cell", forIndexPath: indexPath)
        }
        else {
            let type : String = (self.story.valueForKey("contents")!.allObjects as! [Content])[indexPath.row].type!
            switch type {
            case Content.types.Picture.rawValue:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("picture_card", forIndexPath: indexPath) as! PictureCardCollectionViewCell
            default:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("text_card", forIndexPath: indexPath) as! TextCardCollectionViewCell
            }
        }
        return cell
    }
    
    //Tamaño de celdas
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(indexPath.section == 0){
            return CGSizeMake(collectionView.bounds.width, 300)
        }
        let type : String = (self.story.valueForKey("contents")!.allObjects as! [Content])[indexPath.row].type!
        return CGSizeMake(collectionView.bounds.width * self.sizes[type]!.0, 100 * self.sizes[type]!.1)
    }
    
    //Movimiento de celdas
    override func collectionView(collectionView: UICollectionView,moveItemAtIndexPath sourceIndexPath:NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let content1 : Content = (self.story.valueForKey("contents")!.allObjects as! [Content])[sourceIndexPath.row]
        let content2 : Content = (self.story.valueForKey("contents")!.allObjects as! [Content])[destinationIndexPath.row]
        
        content1.index = destinationIndexPath.row
        content2.index = sourceIndexPath.row
        
        ContentPersistence().save()
        
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
