//
//  JsonConverter.swift
//  Isaacs
//
//  Created by Sebastian Florez on 9/17/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation

public class JsonConverter{
    static func dictToJson(dict : NSDictionary) -> String{
        do {
            return try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        return "{}"
    }
    
    static func jsonToDict(json : String) -> [String:String]?{
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:String]
            } catch let error as NSError {
                print(error)
            }
        }
        return []
    }

}
