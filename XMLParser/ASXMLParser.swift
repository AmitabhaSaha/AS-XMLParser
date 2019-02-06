//
//  Parser.swift
//  XMLParser
//
//  Created by Amitabha Saha on 25/06/18.
//  Copyright © 2018 ASTech. All rights reserved.
//

// Playground - noun: a place where people can play

import Foundation

public enum XMLReaderOptions: UInt {
    case ZeroValue = 0
    case ProcessNamespaces = 1
    case ReportNamespacePrefixes = 2
    case ResolveExternalEntities = 4
}

let kXMLReaderTextNodeKey: NSString = "text"
let kXMLReaderAttributePrefix: NSString = "@"

public class ASXMLParser: NSObject, XMLParserDelegate {
    
    var dictionaryStack: NSMutableArray?
    var textInProgress = String()
    
    
    open func dictionaryForXMLData(data: Data) -> NSDictionary? {
        
        let rootDictionary: NSDictionary? = self.objectWithData(data: data, options: XMLReaderOptions.ZeroValue)
        return rootDictionary
        
    }
    
    open func dictionaryForXMLString(string: String) -> NSDictionary? {
        if let data: Data = string.data(using: .utf8) {
            return dictionaryForXMLData(data: data)
        } else {
            return nil
        }
    }
    
    open func dictionaryForXMLData(data: Data, options: XMLReaderOptions) -> NSDictionary? {
        
        let rootDictionary: NSDictionary? = self.objectWithData(data: data, options: options)
        return rootDictionary
    }
    
    open func dictionaryForXMLString(string: NSString, options: XMLReaderOptions) -> NSDictionary? {
        
        if let data: Data = string.data(using: String.Encoding.utf8.rawValue) {
            return dictionaryForXMLData(data: data, options: options)
        } else {
            return nil
        }
    }
    
    func objectWithData(data: Data, options: XMLReaderOptions) -> NSDictionary? {
        
        let stringValue = String(data: data, encoding: .utf8)
        
        let removeAndChar = stringValue?.replacingOccurrences(of: "&", with: "!@#$%^*(()")
        guard let filteredData: Data = removeAndChar?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
            return nil
        }
        
        // Clear out any old Data
        dictionaryStack = NSMutableArray()
        textInProgress = String()
        
        // Initialize the stack with a fresh dictionary
        dictionaryStack?.add(NSMutableDictionary())
        let parser: XMLParser = XMLParser(data: filteredData)
        
        parser.shouldProcessNamespaces = (Bool(0 != options.rawValue & XMLReaderOptions.ProcessNamespaces.rawValue))
        parser.shouldReportNamespacePrefixes = (Bool(0 != options.rawValue & XMLReaderOptions.ReportNamespacePrefixes.rawValue))
        parser.shouldResolveExternalEntities = (Bool(0 != options.rawValue & XMLReaderOptions.ResolveExternalEntities.rawValue))
        
        parser.delegate = self
        
        let success: Bool = parser.parse()
        if success {
            
            if let resultDict: NSMutableDictionary = dictionaryStack?.firstObject as? NSMutableDictionary, let resultFiltered = filterResponse(resultDict) {
                removeSpecialChar(dictionnary: resultFiltered)
                return resultFiltered
            } else {
                return nil
            }
        }
        return nil
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // Get the dictionary for the current level in the stack
        guard let parentDict = self.dictionaryStack?.lastObject as? NSMutableDictionary else {
            return
        }
        
        // Create the child dictionary for the new element, and initilaize it with the attributes
        let childDict = NSMutableDictionary()
        attributeDict.keys.forEach({ (dickey) in
            childDict.setValue(attributeDict[dickey], forKey: "\(dickey)_attr")
        })
        
        // If there's already an item for this key, it means we need to create an array
        let existingValue = parentDict[elementName]
        
        if existingValue != nil {
            
            var array: NSMutableArray? = nil
            
            if let arrayValue =  existingValue as? NSMutableArray{
                
                // The array exists, so use it
                array = arrayValue
            } else {
                
                // Create an array if it doesn't exist
                array = NSMutableArray()
                array?.add(existingValue!)
                
                // Replace the child dictionary with an array of children dictionaries
                parentDict.setObject(array!, forKey: elementName as NSCopying)
            }
            
            // Add the new child dictionary to the array
            array?.add(childDict)
            
        } else {
            // Add the new child dictionary to the array
            parentDict.setObject(childDict, forKey: elementName as NSCopying)
        }
        
        // No existing value, so update the dictionary
        self.dictionaryStack?.add(childDict)
        
    }
    
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        textInProgress += string
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // Update the parent dict with text info
        if let dictInProgress: NSMutableDictionary = self.dictionaryStack?.lastObject as? NSMutableDictionary{
            
            if self.textInProgress.count > 0 {
                
                let trimmedString = self.textInProgress.trimmingCharacters(in: .whitespacesAndNewlines)
                dictInProgress.setObject(trimmedString, forKey: elementName as NSCopying)
                self.textInProgress = String()
            }
            
        }
        
        // Pop the current dict
        self.dictionaryStack?.removeLastObject()
    }
    
    private func removeSpecialChar(dictionnary: NSMutableDictionary?) {
        
        if let keys = dictionnary?.allKeys as? [String] {
            for key in keys {
                if let value = dictionnary?.value(forKey: key) as? NSMutableDictionary {
                    removeSpecialChar(dictionnary: value)
                } else if let values = dictionnary?.value(forKey: key) as? [NSMutableDictionary] {
                    values.forEach { (value) in
                        removeSpecialChar(dictionnary: value)
                    }
                } else if let value = dictionnary?.value(forKey: key) as? String {
                    dictionnary?.setValue(value.replaceSpecialCharSet(), forKey: key.replaceAttributeCharSet())
                }
            }
        }
    }
    
    private func filterResponse(_ input: NSMutableDictionary?, key: String? = nil, count: Int = 0) -> NSMutableDictionary?{
        
        let filterdDic = NSMutableDictionary()
        
        if let keys = input?.allKeys as? [String] {
            for key in keys {
                if let value = input?.value(forKey: key) as? NSMutableDictionary {
                    
                    if value.count == 1 {
                        if let valueD = value.object(forKey: key) {
                            if let stringValue = valueD as? String {
                                input?.setValue(stringValue.replaceSpecialCharSet(), forKey: key)
                            } else {
                                input?.setValue(valueD, forKey: key)
                            }
                        }
                    } else {
                        
                        let dic = removeKeyFromDic(value, keyToRemove: key)
                        let _ = filterResponse(dic, key: key, count: count+1)
                        filterdDic.setValue(dic, forKey: key)
                    }
                    
                    
                } else if let values = input?.value(forKey: key) as? [NSMutableDictionary] {
                    
                    for value in values {
                        if value.count == 1 {
                            if let valueD = value.object(forKey: key) {
                                if let stringValue = valueD as? String {
                                    input?.setValue(stringValue.replaceSpecialCharSet(), forKey: key)
                                } else {
                                    input?.setValue(valueD, forKey: key)
                                }
                            }
                        } else {
                            
                            let dic = removeKeyFromDic(value, keyToRemove: key)
                            let _ = filterResponse(dic, key: key, count: count+1)
                            filterdDic.setValue(dic, forKey: key)
                        }
                    }
                }
            }
        }
        
        if count == 0 {
            return filterdDic
        } else {
            return nil
        }
    }
    
    private func removeKeyFromDic(_ dictionnary: NSMutableDictionary, keyToRemove: String) -> NSMutableDictionary {
        
        if let value = dictionnary.value(forKey: keyToRemove) as? String {
            if value.isEmpty == true{
                dictionnary.removeObject(forKey: keyToRemove)
            }
        }
        
        return dictionnary
    }
}

extension String {
    
    func replaceSpecialCharSet() -> String {
        return self.replacingOccurrences(of: "!@#$%^*(()", with: "&")
    }
    
    func replaceAttributeCharSet() -> String {
        return self.replacingOccurrences(of: "_attr", with: "")
    }
}
