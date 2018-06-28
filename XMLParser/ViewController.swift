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
        
        let education = [["course":"graduation",
                          "institutation":"st thomas",
                          "from":"2008",
                          "to":"2012"],
                         ["course":"10+2",
                          "institutation":"madhyamgram high school",
                          "from":"2005",
                          "to":"2007"],
                         ["course":"10",
                          "institutation":"madhyamgram high school",
                          "from":"2000",
                          "to":"2005"]]
        let dic : [String : Any] = ["fisrtname":"Amitabha",
                                    "lastname":"Saha",
                                    "heightQualification":"B.Tech",
                                    "education":education]
        let xml = ASXMLCreator.init(input: dic)
        print("XML: \(xml.output ?? "")")
        
        if let path = Bundle.main.path(forResource: "Foods", ofType: "xml"){
            let url = URL(fileURLWithPath: path)
            let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)

            if let dictionary = ASXMLParser().dictionaryForXMLString(string: xmlString) {
                print(dictionary)
            }

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

