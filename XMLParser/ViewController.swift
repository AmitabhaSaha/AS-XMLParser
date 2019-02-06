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
    }
    
    @IBAction func parseAction(_ sender: Any) {
        
        if let path = Bundle.main.path(forResource: "Foods", ofType: "xml"){
            let url = URL(fileURLWithPath: path)
            let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)

            if let dictionary = ASXMLParser().dictionaryForXMLString(string: xmlString) {
                print(dictionary)
                
                if let json = dictionary as? ASXMLCreator.JSON {
                    let xml = ASXMLCreator.init(input: json)
                    print("XML: \(xml.output ?? "")")
                }
            } else {
                print("Nil")
            }

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

