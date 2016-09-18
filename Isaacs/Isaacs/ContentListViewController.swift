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
    let persistence:ContentPersistence = ContentPersistence()
    var contents : [Content] = []
    
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        contents = persistence.getAll()
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
        case Content.types.Picture.rawValue: cell = createPhotoCell(indexPath)
        case Content.types.Audio.rawValue:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("audio_card", forIndexPath: indexPath) as! AudioCardCollectionViewCell
            (cell as! AudioCardCollectionViewCell).delete.tag = indexPath.row
            (cell as! AudioCardCollectionViewCell).delete.addTarget(self, action: #selector(deleteCard), forControlEvents: .TouchUpInside)
        case Content.types.Contact.rawValue: cell = createContactCell(indexPath)
        default:
            cell = createTextCell(indexPath)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("story_list") as! StorySelectViewController
        vc.content = contents[indexPath.row]
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    // Create a text cell 
    func createTextCell(indexPath: NSIndexPath) -> TextCardCollectionViewCell {
        let textCell:TextCardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("text_card", forIndexPath: indexPath) as! TextCardCollectionViewCell
        textCell.delete.tag = indexPath.row
        textCell.delete.addTarget(self, action: #selector(deleteCard), forControlEvents: .TouchUpInside)
        
        textCell.layer.borderColor = UIColor.darkGrayColor().CGColor
        textCell.layer.borderWidth = 2
        
        let jsonData = contents[indexPath.row].data ?? "No data"
        textCell.textView.text = JsonConverter.jsonToDict(jsonData)!["body"]
        
        return textCell
    }
    
    // Create Photo cell
    func createPhotoCell(indexPath: NSIndexPath) -> PictureCardCollectionViewCell {
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("picture_card", forIndexPath: indexPath) as! PictureCardCollectionViewCell
        photoCell.delete.tag = indexPath.row
        photoCell.delete.addTarget(self, action: #selector(deleteCard), forControlEvents: .TouchUpInside)
        
        photoCell.layer.borderColor = UIColor.cyanColor().CGColor
        photoCell.layer.borderWidth = 2
        
        let jsonData = contents[indexPath.row].data ?? "No data"
        let imageName = JsonConverter.jsonToDict(jsonData)!["image_file_name"]!
        let image = Utils.getImage(imageName)
        photoCell.image.image = image
        
        return photoCell
    }
    
    func createContactCell(indexPath: NSIndexPath) -> ContactCardCollectionViewCell {
        let contactCell = collectionView.dequeueReusableCellWithReuseIdentifier("contact_card", forIndexPath: indexPath) as! ContactCardCollectionViewCell
        contactCell.delete.tag = indexPath.row
        contactCell.delete.addTarget(self, action: #selector(deleteCard), forControlEvents: .TouchUpInside)
        
        contactCell.layer.borderColor = UIColor.magentaColor().CGColor
        contactCell.layer.borderWidth = 2
        
        let jsonData = contents[indexPath.row].data ?? "No data"
        let dict = JsonConverter.jsonToDict(jsonData)!
        
        contactCell.nameLabel.text = dict["name"]
        contactCell.notesLabel.text = dict["aditional_info"]
        
        return contactCell
    }
    
    func createAudioCell(indexPath: NSIndexPath) -> ContactCardCollectionViewCell {
        let audioCell = collectionView.dequeueReusableCellWithReuseIdentifier("contact_card", forIndexPath: indexPath) as! ContactCardCollectionViewCell
        audioCell.delete.tag = indexPath.row
        audioCell.delete.addTarget(self, action: #selector(deleteCard), forControlEvents: .TouchUpInside)
        
        audioCell.layer.borderColor = UIColor.orangeColor().CGColor
        audioCell.layer.borderWidth = 2
        
        let jsonData = contents[indexPath.row].data ?? "No data"
        let dict = JsonConverter.jsonToDict(jsonData)!
        
        audioCell.nameLabel.text = dict["title"]
        
        
        return audioCell
    }
    
    //Tamaño de celdas
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let type : String = (contents[indexPath.row].type)!
        return CGSizeMake(collectionView.bounds.width * self.sizes[type]!.0, 100 * self.sizes[type]!.1)
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deleteCard(sender: UIButton!){
        persistence.deleteEntity(contents[sender.tag])
        persistence.save()
        contents = persistence.getAll()
        collectionView?.reloadData()
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
