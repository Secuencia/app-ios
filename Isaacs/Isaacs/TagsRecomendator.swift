//
//  TagsRecomendator.swift
//  Isaacs
//
//  Created by Nicolas Chaves on 9/6/16.
//  Copyright © 2016 Inspect. All rights reserved.
//

import Foundation

public class TagsRecomendator {
    
    typealias TaggedToken = (String, String?)
    
    public init() {
        
    }
    
    func tag(text: String, scheme: String) -> [TaggedToken] {
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace , .OmitPunctuation , .OmitOther]
        let tagger: NSLinguisticTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("es"), options: Int(options.rawValue))
        tagger.string = text
        
        let tokens: [TaggedToken] = []
        
        return tokens
        
    }
    
}
