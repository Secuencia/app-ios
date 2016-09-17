//
//  InputViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/13/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    
    // MARK: Properties - Interface
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var picker: UIImagePickerController!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    var availableModules = ["Text", "Camera", "Gallery", "Record", "Contact", "Completed"]
    
    // MARK: Properties - State vars
    
    
    var globalImageStatus: String?
    
    var contactIndexPath: NSIndexPath?
    
    var entryModule: Int?
    
    var isInEditingMode = false
    
    var editedContentIndex: Int?
    
    var lastlyEditedContent: Int?
    
    let persistenceContext = ContentPersistence()
    
    
    // MARK: Properties - Logic
    
    enum SelectedBarButtonTag: Int {
        case Text
        case Camera
        case Gallery
        case Audio
        case Contact
        case Completed
    }
    
    enum Modules: Int {
        case Text
        case Photo
        case Audio
        case Contact
    }
    
    var modulesTypes = [Int]()
    
    var contents = [Content]()
    
    var images = [UIImage]()
    
    var historias = ["Pepita", "Sutana", "Menguana"]
    
    
    // MARK: Program entry point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationBar.topItem?.title = "Entry Session"
        navigationBar.barStyle = UIBarStyle.Black
        navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.registerNib(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "photo_cell")
        tableView.registerNib(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "text_cell")
        tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contact_cell")
        tableView.registerNib(UINib(nibName: "AudioTableViewCell", bundle: nil), forCellReuseIdentifier: "audio_cell")
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        enableKeyboardHideOnTap()
        
        if let entryAction = entryModule{
            print("LLEGA HASTA ACA")
            manageAction(entryAction)
        }
        
        
    }
    
    
    // MARK: Table View Actions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch modulesTypes[indexPath.section] {
        case Modules.Text.rawValue: return createTextCell(indexPath)
        case Modules.Photo.rawValue: return createPhotoCell(indexPath)
        case Modules.Audio.rawValue: return createAudioCell(indexPath)
        case Modules.Contact.rawValue: return createContactCell(indexPath)
        default: return createTextCell(indexPath)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return modulesTypes.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch modulesTypes[indexPath.section] {
        case Modules.Text.rawValue: return 120.0
        case Modules.Photo.rawValue: return 160.0
        case Modules.Audio.rawValue: return 120.0
        case Modules.Contact.rawValue: return 160.0
        default: return 80.0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch modulesTypes[indexPath.section] {
        case Modules.Text.rawValue: return 120.0
        case Modules.Photo.rawValue: return 160.0
        case Modules.Audio.rawValue: return 120.0
        case Modules.Contact.rawValue: return 160.0
        default: return 80.0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Cell selected: ")
        print(indexPath.section)
    }
    
    
    
    // MARK: Cell creation
    
    func createTextCell(indexPath: NSIndexPath) -> TextTableViewCell {
        
        let textCell = tableView.dequeueReusableCellWithIdentifier("text_cell", forIndexPath: indexPath) as! TextTableViewCell
        
        // Style
        textCell.containerView.layer.borderWidth = 2.0
        textCell.containerView.layer.borderColor = UIColor.darkGrayColor().CGColor
        textCell.containerView.layer.cornerRadius = 10.0
        textCell.backgroundColor = UIColor.clearColor()
        // Style
        
        if indexPath.section == editedContentIndex && editing {
            textCell.myText.becomeFirstResponder()
        }else if lastlyEditedContent == indexPath.section{
            textCell.beingEdited = false
            textCell.userInteractionEnabled = false
            if textCell.myText.isFirstResponder() {textCell.myText.resignFirstResponder()}
        }
        
        return textCell
    }
    
    
    func createPhotoCell(indexPath: NSIndexPath) -> PhotoTableViewCell {
        
        let photoCell = tableView.dequeueReusableCellWithIdentifier("photo_cell", forIndexPath: indexPath) as! PhotoTableViewCell
        
        // Style
        photoCell.containerView.layer.borderWidth = 2.0
        photoCell.containerView.layer.borderColor = UIColor.cyanColor().CGColor
        photoCell.containerView.layer.cornerRadius = 10.0
        photoCell.backgroundColor = UIColor.clearColor()
        // Style
        
        
        photoCell.photoView.image = images[0]
        
        if indexPath.section == editedContentIndex && editing {
            photoCell.notesTextView.becomeFirstResponder()
        }else{
            photoCell.beingEdited = false
            photoCell.userInteractionEnabled = false
            if photoCell.notesTextView.isFirstResponder() {photoCell.notesTextView.resignFirstResponder()}
        }
        
        return photoCell
        
    }
    
    
    func createContactCell(indexPath: NSIndexPath) -> ContactTableViewCell {
        
        let contactCell = tableView.dequeueReusableCellWithIdentifier("contact_cell", forIndexPath: indexPath) as! ContactTableViewCell
        
        // Style
        contactCell.containerView.layer.borderWidth = 2.0
        contactCell.containerView.layer.borderColor = UIColor.magentaColor().CGColor
        contactCell.containerView.layer.cornerRadius = 10.0
        contactCell.backgroundColor = UIColor.clearColor()
        contactCell.additionalInfoText.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Style
        
        contactCell.pictureButton.tag = indexPath.section
        contactCell.pictureButton.addTarget(self, action: #selector(addContactImage), forControlEvents: .TouchUpInside)
        
        if indexPath.section == editedContentIndex && editing {
            contactCell.nameTextField.becomeFirstResponder()
        }else if lastlyEditedContent == indexPath.section {
            contactCell.beingEdited = false
            contactCell.userInteractionEnabled = false
            if contactCell.nameTextField.isFirstResponder() {contactCell.nameTextField.resignFirstResponder()}
        }
        
        return contactCell
        
    }
    
    
    func createAudioCell(indexPath: NSIndexPath) -> AudioTableViewCell {
        let audioCell = tableView.dequeueReusableCellWithIdentifier("audio_cell", forIndexPath: indexPath) as! AudioTableViewCell
        
        // Style
        audioCell.containerView.layer.borderWidth = 2.0
        audioCell.containerView.layer.borderColor = UIColor.orangeColor().CGColor
        audioCell.containerView.layer.cornerRadius = 10.0
        audioCell.backgroundColor = UIColor.clearColor()
        // Style

        return audioCell
    }
    
    func addContactImage(sender: UIButton!) {
        globalImageStatus = "contact"
        contactIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
    }
    
    
    
    // MARK: Collection View Action
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionItem = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ModuleCollectionViewCell
        
        collectionItem.moduleName.tag = indexPath.row
        collectionItem.moduleName.backgroundColor = UIColor.clearColor()
        collectionItem.moduleName.setImage(UIImage(named: availableModules[indexPath.row]), forState: .Normal)
        collectionItem.moduleName.addTarget(self, action: #selector(buttonSelected), forControlEvents: .TouchUpInside)
        collectionItem.moduleName.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        collectionItem.moduleName.tintColor = UIColor.darkGrayColor()
        
        
        return collectionItem
    }
    
    
    func buttonSelected(sender: UIButton!){
        
        manageAction(sender.tag)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableModules.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    // MARK: Logic
    
    func manageAction(action: Int) {
        
        saveCurrentlyEditingContent()
        
        switch action {
        case SelectedBarButtonTag.Text.rawValue: insertText()
        case SelectedBarButtonTag.Camera.rawValue: insertPicture("camera")
        case SelectedBarButtonTag.Gallery.rawValue: insertPicture("gallery")
        case SelectedBarButtonTag.Audio.rawValue: insertAudio()
        case SelectedBarButtonTag.Contact.rawValue: insertContact()
        default: saveCurrentlyEditingContent()
        }
        
    }
    
    func insertText() {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Text.rawValue
        contents.append(newContent)
        editing = true
        editedContentIndex = contents.count - 1
        print("New content index: ", editedContentIndex)
        
        modulesTypes.append(Modules.Text.rawValue)
        tableView.reloadData()
    }
    
    func insertPicture(media: String) {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Picture.rawValue
        
        contents.append(newContent)
        editing = true
        editedContentIndex = contents.count - 1
        modulesTypes.append(Modules.Photo.rawValue)

        
        picker = UIImagePickerController()
        picker.delegate = self
        
        if media == "camera" {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        
        globalImageStatus = "photo"
        
        
        presentViewController(picker, animated: true, completion: nil)
    }
    


    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print(info)
        
        if globalImageStatus == "photo" {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                print("NUMBER OF SECTIONS", tableView.numberOfSections)
                print("New content index: ", editedContentIndex)
                
                images.append(image)
                
                print(image)
                
                print("GENERATING ROUTE")
                let imageData = NSData(data:UIImagePNGRepresentation(image)!)
                let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                var url = NSURL(fileURLWithPath: paths[0])
                //var docs = paths[0] as! NSURL
                let fullPath = url.URLByAppendingPathComponent("image.png")//stringByAppendingPathComponent("name.png")
                let result = imageData.writeToFile(fullPath!.absoluteString!,atomically: true)
                print(result)
                print("END OF PERSISTENCE")

            }else{
                print("Something went wrong")
            }
            globalImageStatus = nil
        } else {

            globalImageStatus = nil
            contactIndexPath = nil
        }
        
        tableView.reloadData()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func insertAudio() {
        print("Audio: To Be implemented")
        modulesTypes.append(Modules.Audio.rawValue)
        tableView.reloadData()
    }
    
    func insertContact() {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Contact.rawValue
        contents.append(newContent)
        editing = true
        editedContentIndex = contents.count - 1
        print("New content index: ", editedContentIndex)
        
        modulesTypes.append(Modules.Contact.rawValue)
        tableView.reloadData()
        
    }
    
    
    
    // MARK: Content
    
    func saveCurrentlyEditingContent() {
        
        if let index = editedContentIndex {
            var json: String?
            switch contents[index].type! {
                case Content.types.Text.rawValue: json = createDict(((tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: editedContentIndex!)) as? TextTableViewCell)?.myText.text)!)
                case Content.types.Picture.rawValue: json = createDict(((tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: editedContentIndex!)) as? PhotoTableViewCell)!.notesTextView.text)!)
                case Content.types.Audio.rawValue: json = ""
                case Content.types.Contact.rawValue: json = createDict(((tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: editedContentIndex!)) as? ContactTableViewCell)?.nameTextField.text)!)
                default: json = nil
            }
            print("ESTE ES EL JSON: ",json)
            contents[index].data = json
            persistenceContext.save()
            
            editing = false
            lastlyEditedContent = editedContentIndex
            editedContentIndex = nil
        }
        
    }
    
    func createDict(bodyText: String) -> String {
        let dict: [String: String] = ["title":"titulo por defecto", "body":bodyText,"otra propiedad":"nueva propiedad"]
        let json: String = JsonConverter.dictToJson(dict)
        return json
    }
    
    // MARK: End of session actions
    
    
    @IBAction func saveSession(sender: UIBarButtonItem) {
        print("This is the data of the session")
        print(modulesTypes)
        print(contents)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelSession(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Actions to keep toolbar sticked to keyboard
    
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
    
    

}
