//
//  XMLParserTests.swift
//  XMLParserTests
//
//  Created by Amitabha Saha on 06/02/19.
//  Copyright © 2019 IBM. All rights reserved.
//

import XCTest
@testable import XMLParser

class XMLParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_XML_to_JSON_without_special_charSet(){
        
        if let path = Bundle(for: XMLParserTests.self).path(forResource: "Books", ofType: "xml"){
            let url = URL(fileURLWithPath: path)
            let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)
            
            let dictionary = ASXMLParser().dictionaryForXMLString(string: xmlString)
            
            if let values = dictionary?.value(forKeyPath: "Books.Book.id") as? [String], let first = values.first {
                XCTAssertEqual(first, "1", "Parsed value Should be 1")
            }
            
            if let values = dictionary?.value(forKeyPath: "Books.Book.title") as? [String], let first = values.first {
                XCTAssertEqual(first, "Circumference", "Parsed value Should be Circumference")
            }
            
            if let values = dictionary?.value(forKeyPath: "Books.Book.author") as? [String], let first = values.first {
                XCTAssertEqual(first, "Nicholas Nicastro", "Parsed Should be Nicholas Nicastro")
            }
            
            XCTAssertNotNil(dictionary, "Parsed Result should not be nil")
            
        } else {
            print("File Not Found")
        }
    }
    
    func test_XML_to_JSON_with_special_charSet(){
        
        if let path = Bundle(for: XMLParserTests.self).path(forResource: "Foods", ofType: "xml"){
            let url = URL(fileURLWithPath: path)
            let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)
            
            let dictionary = ASXMLParser().dictionaryForXMLString(string: xmlString)
            
            if let values = dictionary?.value(forKeyPath: "breakfast_menu.food.name") as? [String], let first = values.first {
                XCTAssertEqual(first, "Belgian Waff&#233;les", "Parsed value not equal")
            }
            
            if let values = dictionary?.value(forKeyPath: "breakfast_menu.food.price") as? [String], let first = values.first {
                XCTAssertEqual(first, "$5.95&#233;", "Parsed value not equal")
            }
            
            if let values = dictionary?.value(forKeyPath: "breakfast_menu.food.calories") as? [String], let first = values.first {
                XCTAssertEqual(first, "650&#233;", "Parsed value not equal")
            }
            
            XCTAssertNotNil(dictionary, "Parsed Result should not be nil")
            
            
        } else {
            print("File Not Found")
        }
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
