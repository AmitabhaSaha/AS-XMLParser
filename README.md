
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0+-orange.svg)
![Swift 3.2](https://img.shields.io/badge/Swift-3.2-orange.svg)
![Build](https://img.shields.io/badge/build-passing-green.svg)
![License](https://img.shields.io/cocoapods/l/SwiftyXMLParser.svg?style=flat)
![Platform](https://img.shields.io/badge/Platform-iOS10%2B-green.svg)

#ASXMLParser

One-Stop XML Parsing solution in swift

# What's this?
This is a XML parser inspired by [XML-Parser by Troy Brant](http://troybrant.net/blog/2010/09/simple-xml-to-nsdictionary-converter/).

[NSXMLParser](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSXMLParser_Class/) is inbuild XML parsing solution which is available in iOS and part of Foundation framework & is a kind of "SAX" parser. Which is a great framework but its not easy to use. 

# Feature
-  Parse XML Doument as NSDictionary.
-  Create XML from Dictionary.

# Requirement
+ iOS 8.0+
+ Swift 4.0+ (or Swift 3.2)

# Installation

#### 2. install

### CocoaPods
#### 1. create Podfile
```ruby:Podfile
platform :ios, '8.0'
use_frameworks!

pod "ASXMLParser"
```

#### 2. install
```
> pod install
```

# Example

```swift
    let xmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Books>
        <Book id="1">
        <title>Circumference</title>
        <author>Nicholas Nicastro</author>
        <summary>Eratosthenes and the Ancient Quest to Measure the Globe.</summary>
        </Book>
        <Book id="2">
        <title>Copernicus Secret</title>
        <author>Jack Repcheck</author>
        <summary>How the scientific revolution began</summary>
        </Book>
        <Book id="3">
        <title>Angels and Demons</title>
        <author>Dan Brown</author>
        <summary>Robert Langdon is summoned to a Swiss research facility to analyze a cryptic symbol seared into the chest of a murdered physicist.</summary>
        </Book>
        <Book id="4">
        <title>Keep the Aspidistra Flying</title>
        <author>George Orwell</author>
        <summary>A poignant and ultimately hopeful look at class and society, Keep the Aspidistra Flying pays tribute to the stubborn virtues of ordinary people who keep the aspidistra flying.</summary>
        </Book>
        </Books>
        """
        
        if let dictionary = XML().dictionaryForXMLString(string: xmlString) {
            print(dictionary)
        }
```

Output be like

```
 {
    Books = {
        Book = (
                		{   
                author = "Nicholas Nicastro";
                id = 1;
                summary = "Eratosthenes and the Ancient Quest to Measure the Globe.";
                title = Circumference;
            },
                        {
                author = "Jack Repcheck";
                id = 2;
                summary = "How the scientific revolution began";
                title = "Copernicus Secret";
            },
                        {
                author = "Dan Brown";
                id = 3;
                summary = "Robert Langdon is summoned to a Swiss research facility to analyze a cryptic symbol seared into the chest of a murdered physicist.";
                title = "Angels and Demons";
            },
                        {
                author = "George Orwell";
                id = 4;
                summary = "A poignant and ultimately hopeful look at class and society, Keep the Aspidistra Flying pays tribute to the stubborn virtues of ordinary people who keep the aspidistra flying.";
                title = "Keep the Aspidistra Flying";
            }
        );
    };
}
```

instead of using XML strings directly you can pass data object also, 

```
if let path = Bundle.main.path(forResource: "Foods", ofType: "xml"){
     let url = URL(fileURLWithPath: path)
     let xmlString = try! String(contentsOf: url, encoding: String.Encoding.utf8)

     if let dictionary = XML().dictionaryForXMLString(string: xmlString) {
         print(dictionary)
     }
}

```

Now, lets see how we can create XML from Dictionary,

```
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
```

Output will be, 

```
XML: <?xml version="1.0" encoding="UTF-8" ?>
		<root>
		<fisrtname>John</fisrtname>
		<age>36<age>
		<email>john@doe.com</email>
		<lastname>Doe</lastname>
		<gender>male</gender>
		<education>
			<from>2007</from>
			<institutation>IITD</institutation>
			<course>graduation</course>
			<to>2011</to>
			</education>
		<education>
			<from>2005</from>
			<institutation>DPS</institutation>
			<course>10+2</course>
			<to>2007</to>
			</education>
		<education>
			<from>2000</from>
			<institutation>DPS</institutation>
			<course>10</course>
			<to>2005</to>
		</education>
		</root>
```
p.s: this is formatted output, orogially it will be single line output.  

# License

This software is released under the MIT License, see LICENSE.
