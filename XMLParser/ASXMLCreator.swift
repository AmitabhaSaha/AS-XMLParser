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
        
        var xmlString = ""
        var tempAttribute = ""
        var keys: [String]? = []
        
        if dictionnary?.keys.filter({ $0.lowercased().contains("header") || $0.lowercased().contains("body") }).count == 2 {
            keys = dictionnary?.keys.sorted(by: { (key1, key2) -> Bool in
                return key1 > key2
            })
        } else {
            keys = dictionnary?.keys.sorted()
        }
        
        (keys ?? []).forEach({ (dickey) in
            if let value = dictionnary?[dickey] as? JSON {
                
                xmlString += parseJSON(value: value, dickey: dickey)
                
            } else if let values = dictionnary?[dickey] as? [JSON] {
                
                for value in values {
                    xmlString += parseJSON(value: value, dickey: dickey)
                }
                
            } else if let value = dictionnary?[dickey] as? String {
                
                if dickey.contains("_attr"){
                    print("dickey :",dickey)
                    let key = dickey.replacingOccurrences(of: "_attr", with: "")
                    tempAttribute += " \(key)" + "=\"\(value)\""
                } else {
                    xmlString += "<\(dickey)>\(value)</\(dickey)>"
                }
            }
        })
        
        if tempAttribute.isEmpty {
            return xmlString
        } else {
            return xmlString + "####" + tempAttribute
        }
    }
    
    private func parseJSON(value: JSON, dickey: String) -> String {
        
        let xmlSt = createXML(value, key: dickey)
        let attr = xmlSt.components(separatedBy: "####")
        if attr.count > 1 {
            if isElementPresent(key: dickey, xml: attr[0]) {
                if let value = getValueFor(key: dickey, xml: attr[0]) {
                    return "<\(dickey) \(attr[1])>" + value + "</\(dickey)>"
                } else {
                    return "<\(dickey) \(attr[1])>" + "" + "</\(dickey)>"
                }
            } else {
                return "<\(dickey) \(attr[1])>" + attr[0] + "</\(dickey)>"
            }
        } else {
            return "<\(dickey)>" + xmlSt + "</\(dickey)>"
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
