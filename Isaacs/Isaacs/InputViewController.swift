//
//  InputViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/13/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    
    enum SelectedBarButtonTag: Int {
        case Text
        case Camera
        case Gallery
        case Audio
        case Contact
        case Completed
    }
    
    
    var availableModules = ["Text", "Camera", "Gallery", "Record", "Contact", "Completed"]
    var testingColors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor()]
    
    var entryModule: Int?
    
    // Data sources for the elements in the table view
    
    var modulesTypes = [String]()
    
    var moduleStates = [Bool]()
    
    var modules = [AnyObject]()
    
    var historias = ["Pepita", "Sutana", "Menguana"]
    
    var isInEditingMode = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var picker: UIImagePickerController!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationBar.topItem?.title = "Entry Session"
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        enableKeyboardHideOnTap()
        
        if let entryAction = entryModule{
            switch entryAction {
            case SelectedBarButtonTag.Text.rawValue: insertText()
            case SelectedBarButtonTag.Camera.rawValue: insertPicture("camera")
            case SelectedBarButtonTag.Gallery.rawValue: insertPicture("gallery")
            case SelectedBarButtonTag.Audio.rawValue: insertAudio()
            case SelectedBarButtonTag.Contact.rawValue: print("Contact button")
            default: print("No button")
            }
            
            tableView.reloadData()
            
        }
        
    }
    
    
    // MARK: Table View Actions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if modulesTypes[indexPath.section] == "text" {
            
            let textCell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as! TextTableViewCell
            
            textCell.myText.text = modules[indexPath.section] as! String
            styleTextCell(textCell)
            
            
            if !moduleStates[indexPath.section] {
                textCell.beingEdited = false
                textCell.userInteractionEnabled = false
                if textCell.myText.isFirstResponder() {textCell.myText.resignFirstResponder()}
            }else{
                textCell.myText.becomeFirstResponder()
            }
            
            return textCell
            
        } else if modulesTypes[indexPath.section] == "photo" {
            
            let photoCell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! PhotoTableViewCell
            photoCell.photoView.image = (modules[indexPath.section] as! [AnyObject])[1] as? UIImage
            photoCell.titleLabel.text = (modules[indexPath.section] as! [AnyObject])[0] as? String
            photoCell.notesTextView.text = (modules[indexPath.section] as! [AnyObject])[2] as? String
            
            
            stylePhotoCell(photoCell)
            
            if !moduleStates[indexPath.section] {photoCell.beingEdited = false}
            
            return photoCell
            
        } else {
            
            let contactCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! ContactTableViewCell
            //contactCell.photoView.image = modules[indexPath.section] as? UIImage
            
            //stylePhotoCell(photoCell)
            
            //if !moduleStates[indexPath.row] {photoCell.beingEdited = false}
            
            return contactCell
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return modulesTypes.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Cell selected: ")
        print(indexPath.row)
    }
    
    // MARK: Custom cell styling
    
    func styleTextCell(textCell: TextTableViewCell) {
        
        textCell.contentView.layer.borderWidth = 2.0
        textCell.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        textCell.contentView.layer.cornerRadius = 10.0
        
    }
    
    func stylePhotoCell(photoCell: PhotoTableViewCell) {
        
        photoCell.contentView.layer.borderWidth = 2.0
        photoCell.contentView.layer.borderColor = UIColor.cyanColor().CGColor
        photoCell.contentView.layer.cornerRadius = 10.0
        
        //photoCell.photoView.layer.cornerRadius = photoCell.frame.size.width / 2;
        //photoCell.photoView.clipsToBounds = true
        
    }
    
    func styleAudioCell() {
        print("Not implemented yet")
    }
    
    func styleContactCell() {
        
    }
    
    
    // MARK: Collection View Action
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionItem = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ModuleCollectionViewCell
        
        collectionItem.moduleName.tag = indexPath.row
        collectionItem.moduleName.setBackgroundImage(UIImage(named: availableModules[indexPath.row]), forState: .Normal)
        collectionItem.moduleName.addTarget(self, action: #selector(buttonSelected), forControlEvents: .TouchUpInside)
        //collectionItem.layer.borderWidth = 2.0
        
        
        return collectionItem
    }
    
    func buttonSelected(sender: UIButton!){
        
        saveCurrentlyEditingContent()
        
        moduleStates = moduleStates.map {bool in return false}
        
        switch sender.tag {
        case SelectedBarButtonTag.Text.rawValue: insertText()
        case SelectedBarButtonTag.Camera.rawValue: insertPicture("camera")
        case SelectedBarButtonTag.Gallery.rawValue: insertPicture("gallery")
        case SelectedBarButtonTag.Audio.rawValue: insertAudio()
        case SelectedBarButtonTag.Contact.rawValue: print("Contact button")
        case SelectedBarButtonTag.Completed.rawValue: print("No new module")
        default: print("No button")
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableModules.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: Toolbar actions
    
    func insertText() {
        modulesTypes.append("text")
        moduleStates.append(true)
        modules.append("")
        tableView.reloadData()
    }
    
    func insertPicture(media: String) {
        
        picker = UIImagePickerController()
        picker.delegate = self
        
        if media == "camera" {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            modulesTypes.append("photo")
            moduleStates.append(false)
            modules.append(["Random image 1",image,"Descripcion"])
        }else{
            print("Something went wrong")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
        
    }
    
    
    func insertAudio() {
        print("Audio: To Be implemented")
    }
    
    func insertContact() {
        
    }
    
    
    // MARK: Select module to create
    
    
    /*@IBAction func addNewInputModuleWithSender(sender: UIBarButtonItem) {
     
     switch sender.tag {
     case SelectedBarButtonTag.Text.rawValue: print("Text")
     case SelectedBarButtonTag.Camera.rawValue: print("Camera")
     case SelectedBarButtonTag.Gallery.rawValue: print("Gallery")
     case SelectedBarButtonTag.Audio.rawValue: print("Audio")
     case SelectedBarButtonTag.Contact.rawValue: print("Contact")
     default: print("No action")
     }
     
     tableView.reloadData()
     
     }*/
    
    
    // MARK: Actions to keep toolbar sticked to keyboard
    
    
    // Add a gesture on the view controller to close keyboard when tapped
    private func enableKeyboardHideOnTap(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil) // See
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil) //See 4.2
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InputViewController.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height + 5
            
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            self.toolbarBottomConstraint.constant = self.toolbarBottomConstraintInitialValue!
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    // MARK: Content
    
    func saveCurrentlyEditingContent() {
        for (index, value) in moduleStates.enumerate() {
            if value {
                if modulesTypes[index] == "text" {
                    let textCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: index)) as! TextTableViewCell
                    modules[index] = textCell.myText.text
                }
            }
        }
    }
    
    // MARK: End of session actions
    
    
    @IBAction func saveSession(sender: UIBarButtonItem) {
        print("This is the data of the session")
        print(modulesTypes)
        print(modules)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelSession(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
