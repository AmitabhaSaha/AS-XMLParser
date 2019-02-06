//
//  ViewController.swift
//  XMLParser
//
//  Created by Amitabha Saha on 25/06/18.
//  Copyright © 2018 ASTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let time = timeConversion(s: "07:05:45PM")
        print(time)
        
    }
    
    @IBAction func parseAction(_ sender: Any) {
        
        let education = [["course":"graduation",
                          "institutation":"IITD",
                          "from":"2007",
                          "to":"2011"],
                         ["course":"10+2",
                          "institutation":"DPS",
                          "from":"2005",
                          "to":"2007"],
                         ["course":"10",
                          "institutation":"DPS",
                          "from":"2000",
                          "to":"2005"]]
        
        let dic : [String : Any] = ["fisrtname":"John",
                                    "lastname":"Doe",
                                    "email":"john@doe.com",
                                    "age":"36",
                                    "gender":"male",
                                    "education":education]
        let xml = ASXMLCreator.init(input: dic)
        print("XML: \(xml.output ?? "")")
        
//        if let path = Bundle.main.path(forResource: "Elements", ofType: "xml"){
//            let url = URL(fileURLWithPath: path)
//            let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)
//
//            if let dictionary = ASXMLParser().dictionaryForXMLString(string: xmlString) {
//                print(dictionary)
//            
//            }
//        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timeConversion(s: String) -> String {
        
        if let date = convertToDate(string:s){
            return formattedDate(date: date)
        } else {
            return ""
        }
        
    }
    
    func convertToDate(string: String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ssa"
        let date = formatter.date(from: string)
        
        return date
    }
    
    func formattedDate(date: Date) -> String {
        
        let format = "HH:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    



}

