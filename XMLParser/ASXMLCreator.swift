//
//  ASXMLCreator.swift
//  XMLParser
//
//  Created by Amitabha Saha on 27/06/18.
//  Copyright © 2018 ASTech. All rights reserved.
//

import Foundation

class ASXMLCreator {
    
    typealias JSON = [String: Any]
    
    var input: JSON?
    var output: String?
    init(input: JSON) {
        
        self.input = input
        let xmlSt = createXML(self.input)
        output = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" + "<root>" + xmlSt + "</root>"
    }
    
    
    private func createXML(_ dictionnary: JSON?, key: String? = nil) -> String {
        
        var xml = ""
        dictionnary?.keys.forEach({ (dickey) in
            if let value = dictionnary?[dickey] as? JSON {
                
                let xmlSt = createXML(value, key: dickey)
                xml = xml + "<\(dickey)>" + xmlSt + "</\(dickey)>"
                
            } else if let values = dictionnary?[dickey] as? [JSON] {
                
                for value in values {
                    let xmlSt = createXML(value, key: dickey)
                    xml = xml + "<\(dickey)>" + xmlSt + "</\(dickey)>"
                }
                
            } else if let value = dictionnary?[dickey] as? String {
                
                xml += "<\(dickey)>\(value)</\(dickey)>"
            }
        })
        
        return xml
    }
}
