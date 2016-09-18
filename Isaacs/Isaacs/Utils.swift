//
//  Utils.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation
import UIKit

public class Utils{
    
    static func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    static func saveImageToDirectory(image:UIImage, imageName: String) -> String {
        let fileManager = NSFileManager.defaultManager()
        let imageData = NSData(data:UIImagePNGRepresentation(image)!)
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(imageName)
        fileManager.createFileAtPath(paths as String, contents: imageData, attributes: nil)
        return imageName
    }
    
    static func getImage(imageName: String) -> UIImage?{
        let fileManager = NSFileManager.defaultManager()
        let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(imageName)
        if fileManager.fileExistsAtPath(imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }else{
            return nil
        }
    }
    
    static func getDirectoryPath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDir = paths[0]
        return documentsDir
    }
}
