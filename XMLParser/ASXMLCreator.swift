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
    
    private var input: JSON?
    
    var output: String?
    
    init(input: JSON) {
        
        self.input = input
        let xmlSt = createXML(self.input)
        output = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" + "<root>" + xmlSt + "</root>"
        output = xmlSt
    }
    
    
    private func createXML(_ dictionnary: JSON?, key: String? = nil) -> String {
        
        var xml = ""
        var temp_attr = ""
        dictionnary?.keys.forEach({ (dickey) in
            if let value = dictionnary?[dickey] as? JSON {
                
                let xmlSt = createXML(value, key: dickey)
                let attr = xmlSt.components(separatedBy: "####")
                if attr.count > 1 {
                    if isElementPresent(key: dickey, xml: attr[0]) {
                        if let value = getValueFor(key: dickey, xml: attr[0]) {
                            xml = xml + "<\(dickey) \(attr[1])>" + value + "</\(dickey)>"
                        }
                    } else {
                        xml = xml + "<\(dickey) \(attr[1])>" + attr[0] + "</\(dickey)>"
                    }
                } else {
                    xml = xml + "<\(dickey)>" + xmlSt + "</\(dickey)>"
                }
                
                
            } else if let values = dictionnary?[dickey] as? [JSON] {
                
                for value in values {
                    let xmlSt = createXML(value, key: dickey)
                    let attr = xmlSt.components(separatedBy: "####")
                    if attr.count > 1 {
                        if isElementPresent(key: dickey, xml: attr[0]) {
                            if let value = getValueFor(key: dickey, xml: attr[0]) {
                                xml = xml + "<\(dickey) \(attr[1])>" + value + "</\(dickey)>"
                            }
                        } else {
                            xml = xml + "<\(dickey) \(attr[1])>" + attr[0] + "</\(dickey)>"
                        }
                    } else {
                        xml = xml + "<\(dickey)>" + xmlSt + "</\(dickey)>"
                    }
                }
                
            } else if let value = dictionnary?[dickey] as? String {
                
                if dickey.contains("_attr"){
                    let key = dickey.replacingOccurrences(of: "_attr", with: "")
                    temp_attr += " \(key)" + "=\"\(value)\""
                } else {
                    xml += "<\(dickey)>\(value)</\(dickey)>"
                }
            }
        })
        
        if temp_attr.isEmpty {
            return xml
        } else {
            return xml + "####" + temp_attr
        }
    }
    
    func isElementPresent(key: String, xml: String) -> Bool{
        return xml.contains(key)
    }
    
    func getValueFor( key: String, xml: String) -> String?{
        let attr1 = xml.components(separatedBy: "<\(key)>")
        if attr1.count == 2 {
            let attr2 = attr1[1].components(separatedBy: "</\(key)>")
            if attr2.count == 2 {
                return attr2[0]
            }
        }
        return nil
    }
}
