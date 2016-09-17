//
//  ContentListViewController.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/4/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class ContentListViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum factors: CGFloat{
        case Full = 1
        case Half = 0.49
        case Double = 2
    }
    
    var sizes = [String: (CGFloat, CGFloat)]()
    let contents : [Content] = ContentPersistence().getAll()
    
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        sizes[Content.types.Audio.rawValue] = (factors.Full.rawValue, factors.Half.rawValue)
        sizes[Content.types.Contact.rawValue] = (factors.Half.rawValue, factors.Double.rawValue)
        sizes[Content.types.Picture.rawValue] = (factors.Half.rawValue, factors.Double.rawValue)
        sizes[Content.types.Text.rawValue] = (factors.Full.rawValue, factors.Double.rawValue)
        
        self.collectionView!.registerNib(UINib(nibName: "PictureCardView", bundle: nil), forCellWithReuseIdentifier: "picture_card")
        self.collectionView!.registerNib(UINib(nibName: "TextCardView", bundle: nil), forCellWithReuseIdentifier: "text_card")
        self.collectionView!.registerNib(UINib(nibName: "AudioCardView", bundle: nil), forCellWithReuseIdentifier: "audio_card")
        self.collectionView!.registerNib(UINib(nibName: "ContactCardView", bundle: nil), forCellWithReuseIdentifier: "contact_card")
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
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Numero de celdas en coleccion
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    //Render de celdas
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell;
        let type : String = (contents[indexPath.row].type)!
        switch type {
        case Content.types.Picture.rawValue:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("picture_card", forIndexPath: indexPath) as! PictureCardCollectionViewCell
        case Content.types.Audio.rawValue:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("audio_card", forIndexPath: indexPath) as! AudioCardCollectionViewCell
        case Content.types.Contact.rawValue:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("contact_card", forIndexPath: indexPath) as! ContactCardCollectionViewCell
        default:
            cell = createTextCell(indexPath)
        }
        
        return cell
    }
    
    func createTextCell(indexPath: NSIndexPath) -> TextCardCollectionViewCell {
        let textCell = collectionView.dequeueReusableCellWithReuseIdentifier("text_card", forIndexPath: indexPath) as! TextCardCollectionViewCell
        var jsonData = contents[indexPath.row].data!
        var text: String = ""
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            if let text = json["json"] as? String {
                textCell.textLabel.text = text
            }
        }catch{
            print("Error info: \(error)")
        }
        return textCell
    }
    
    //Tamaño de celdas
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let type : String = (contents[indexPath.row].type)!
        return CGSizeMake(collectionView.bounds.width * self.sizes[type]!.0, 100 * self.sizes[type]!.1)
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
