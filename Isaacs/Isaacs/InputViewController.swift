//
//  InputViewController.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/13/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, CLLocationManagerDelegate {

    
    // MARK: Properties - Interface
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    
    // MARK: Properties - Interface Utils
    
    var picker: UIImagePickerController!
    
    var availableModules = ["Text", "Camera", "Gallery", "Record"] // Names of the images that go in the toolbar
    
    var modulesTypes = [Int]() // Aid in cell creation
    
    var imagesTuples = [(Int, UIImage, String)]() // Index, UIImage object, image name (String)
    
    var audioTuples = [(Int, String)]() // Editing stream index, name (is the date) 
    
    
    // MARK: Properties - State vars
    
    var entryModule: Int?
    
    var editedContentIndex: Int?
    
    var lastlyEditedContent: Int?
    
    let persistenceContext = ContentPersistence()
    
    
    // MARK: Properties - Logic

    enum Modules: Int {
        case Text
        case Camera
        case Gallery
        case Audio
    }
    
    var contents = [Content]()
    
    
    
    // MARK: Program entry point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Location manager
        
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
        tableView.registerNib(UINib(nibName: "AudioTableViewCell", bundle: nil), forCellReuseIdentifier: "audio_cell")
        
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        enableKeyboardHideOnTap()
        
        if let entryAction = entryModule {
            manageAction(entryAction)
        }
        
        
    }
    
    // MARK: Location
    
    let locationManager = CLLocationManager()
    
    var lastLocationRetrieved: CLLocationCoordinate2D? = nil
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        lastLocationRetrieved = locValue
    }
    
    
    
    // MARK: Table View Actions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch modulesTypes[indexPath.section] {
        case Modules.Text.rawValue: return createTextCell(indexPath)
        case Modules.Gallery.rawValue: return createPhotoCell(indexPath)
        case Modules.Camera.rawValue: return createPhotoCell(indexPath)
        case Modules.Audio.rawValue: return createAudioCell(indexPath)
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
        case Modules.Gallery.rawValue: return 160.0
        case Modules.Camera.rawValue: return 160.0
        case Modules.Audio.rawValue: return 80.0
        default: return 80.0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch modulesTypes[indexPath.section] {
        case Modules.Text.rawValue: return 120.0
        case Modules.Gallery.rawValue: return 160.0
        case Modules.Camera.rawValue: return 160.0
        case Modules.Audio.rawValue: return 80.0
        default: return 80.0
        }
    }
    
    
    // MARK: Cell creation
    
    func createTextCell(indexPath: NSIndexPath) -> TextTableViewCell {
        
        let textCell = tableView.dequeueReusableCellWithIdentifier("text_cell", forIndexPath: indexPath) as! TextTableViewCell
    
        
        if indexPath.section == editedContentIndex && editing {
            
            textCell.myText.becomeFirstResponder()
            
        }else if lastlyEditedContent == indexPath.section {
            
            textCell.beingEdited = false
            textCell.userInteractionEnabled = false
            
            if textCell.myText.isFirstResponder() {textCell.myText.resignFirstResponder()}
            
        }
        
        return textCell
    }
    
    
    func createPhotoCell(indexPath: NSIndexPath) -> PhotoTableViewCell {
        
        let photoCell = tableView.dequeueReusableCellWithIdentifier("photo_cell", forIndexPath: indexPath) as! PhotoTableViewCell
        
        for (_, value) in imagesTuples.enumerate() {
            
            if value.0 == indexPath.section {
                
                let tuple = value
                photoCell.photoView.image = tuple.1
                photoCell.titleLabel.text = tuple.2
                break
                
            }
        
        }
        
        if indexPath.section == editedContentIndex && editing {
            
            photoCell.notesTextView.becomeFirstResponder()
            
        }else{
            
            photoCell.beingEdited = false
            photoCell.userInteractionEnabled = false
            
            if photoCell.notesTextView.isFirstResponder() {photoCell.notesTextView.resignFirstResponder()}
            
        }
        
        return photoCell
        
    }
    
    
    func createAudioCell(indexPath: NSIndexPath) -> AudioTableViewCell {
        
        let audioCell = tableView.dequeueReusableCellWithIdentifier("audio_cell", forIndexPath: indexPath) as! AudioTableViewCell
        
        for (_, value) in audioTuples.enumerate() {
            
            if value.0 == indexPath.section {
                
                let tuple = value
                audioCell.file_name = tuple.1
                audioCell.titleLabel.text = tuple.1
                break
                
            }
            
        }
        
        return audioCell
    }
    
    
    
    
    // MARK: Collection View
    
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
        case Modules.Text.rawValue: insertText()
        case Modules.Camera.rawValue: insertPicture("camera")
        case Modules.Gallery.rawValue: insertPicture("gallery")
        case Modules.Audio.rawValue: insertAudio()
        default: saveCurrentlyEditingContent()
        }
        
    }
    
    func insertText() {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Text.rawValue
        
        newContent.date_created = NSDate()
        
        if let location = lastLocationRetrieved {
            
            newContent.longitude = location.longitude
            newContent.latitude = location.latitude
            
        }
        
        
        contents.append(newContent)
        editing = true
        editedContentIndex = contents.count - 1
        
        modulesTypes.append(Modules.Text.rawValue)
        tableView.reloadData()
    }
    
    
    func insertPicture(media: String) {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Picture.rawValue
        
        
        newContent.date_created = NSDate()
        
        
        if let location = lastLocationRetrieved {
            newContent.longitude = location.longitude
            newContent.latitude = location.latitude

        }
        
        
        
        contents.append(newContent)
        editing = true
        editedContentIndex = contents.count - 1
        
        picker = UIImagePickerController()
        picker.delegate = self
        
        
        if media == "camera" {
            picker.sourceType = .Camera
            modulesTypes.append(Modules.Camera.rawValue)
        } else {
            picker.sourceType = .PhotoLibrary
            modulesTypes.append(Modules.Gallery.rawValue)
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // MARK: Check
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            let name = NSDate().iso8601 + ".png"
            
            let imageName = saveImageToDirectory(image, imageName: name)
            
            let loadedImage = getImage(imageName)!
            
            
            imagesTuples.append((editedContentIndex!, loadedImage, name))
            
            
        } else { print("Something went wrong") }
        
        tableView.reloadData()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
 
    
    func insertAudio() {
        
        let newContent = ContentPersistence().createEntity(); newContent.type = Content.types.Audio.rawValue
        
        
        newContent.date_created = NSDate()
        
        
        if let location = lastLocationRetrieved {
            
            newContent.longitude = location.longitude
            newContent.latitude = location.latitude
            
        }
    
        
        contents.append(newContent)
        
        editing = true
        editedContentIndex = contents.count - 1
        

        audioTuples.append((editedContentIndex!, NSDate().iso8601))
        
        modulesTypes.append(Modules.Audio.rawValue)
        
        tableView.reloadData()
    }
    
    
    
    // MARK: Content
    
    func saveCurrentlyEditingContent() {
        
        if let index = editedContentIndex {
            var json: String?
            switch contents[index].type! {
                case Content.types.Text.rawValue: json = createDictForText()
                case Content.types.Picture.rawValue: json = createDictForPhoto()
                case Content.types.Audio.rawValue: json = createDictForAudio()
                default: json = nil
            }
            contents[index].data = json
            persistenceContext.save()
            
            editing = false
            lastlyEditedContent = editedContentIndex
            editedContentIndex = nil
        }
        
    }
    
    func createDictForText() -> String {
        let bodyText = ((tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: editedContentIndex!)) as? TextTableViewCell)?.myText.text)!
        let dict: [String: String] = ["text":bodyText]
        let json: String = JsonConverter.dictToJson(dict)
        return json
    }
    
    func createDictForPhoto() -> String {
        let cell = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: editedContentIndex!)) as? PhotoTableViewCell)!
        let dict: [String: String] = ["notes":cell.notesTextView.text,"image_file_name":cell.titleLabel.text!]
        let json: String = JsonConverter.dictToJson(dict)
        return json
    }
    
    func createDictForAudio() -> String {
        let dict: [String: String] = ["title":getContentNameFromIndex(editedContentIndex!, type: "audio"), "audio_file_name":getAudioFileName(editedContentIndex!)]
        let json: String = JsonConverter.dictToJson(dict)
        return json
    }
    
    
    // MARK: End of session actions
    
    
    @IBAction func saveSession(sender: UIBarButtonItem) {
        
        checkLocations()
        
        saveCurrentlyEditingContent()
        
        print("This is the data of the session")
        print(modulesTypes)
        print(contents)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func checkLocations() {
        for content in contents {
            if content.longitude == 0 && content.latitude == 0 {
                if let location = lastLocationRetrieved {
                    content.longitude = location.longitude
                    content.latitude = location.latitude
                }
            }
        }
    }
    
    
    @IBAction func cancelSession(sender: UIBarButtonItem) {
        
        for (_, value) in contents.enumerate() {
            persistenceContext.deleteEntity(value)
        }
        
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
    
    // MARK: Utility actions
    
    
    func saveImageToDirectory(image:UIImage, imageName: String) -> String {
        let fileManager = NSFileManager.defaultManager()
        let imageData = NSData(data:UIImagePNGRepresentation(image)!)
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(imageName)
        fileManager.createFileAtPath(paths as String, contents: imageData, attributes: nil)
        return imageName
    }
    
    func getImage(imageName: String) -> UIImage?{
        let fileManager = NSFileManager.defaultManager()
        let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(imageName)
        if fileManager.fileExistsAtPath(imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }else{
            return nil
        }
    }
    
    func getDirectoryPath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDir = paths[0]
        return documentsDir
    }
    
    func getContentNameFromIndex(index: Int, type: String) -> String {
        if type == "image" {
            for (_, value) in imagesTuples.enumerate() {
                if value.0 == index {
                    return "Imagen - " + (imagesTuples[index].2).componentsSeparatedByString(".")[0]
                }
            }
        } else {
            for (_, value) in audioTuples.enumerate() {
                if value.0 == index {
                    return "Audio - " + (value.1).componentsSeparatedByString(".")[0]
                }
            }
        }
        return ""
    }
    
    func getAudioFileName(index: Int) -> String {
        for (_, value) in audioTuples.enumerate() {
            if value.0 == index {
                return value.1
            }
        }
        return ""
    }
    
    
}

extension NSDate {
    struct Formatter {
        static let iso8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.stringFromDate(self) }
}

extension String {
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.dateFromString(self)
    }
}
