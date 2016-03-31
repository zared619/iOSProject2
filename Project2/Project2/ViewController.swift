//
//  ViewController.swift
//  Project2
//
//  Created by Andrew Pier on 3/29/16.
//  Copyright © 2016 Andrew Pier. All rights reserved.
//

import UIKit
import MapKit
import Twitter
import TwitterKit

class numPair{
    var first:Double = 0.0
    var second:Double = 0.0
}

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    

    @IBOutlet weak var hashTagOne: UITextField!
    @IBOutlet weak var hashTagTwo: UITextField!
    @IBOutlet weak var hashTagThree: UITextField!
    @IBOutlet weak var Picker: UIPickerView!
    
    let file = NSBundle.mainBundle().pathForResource("Data", ofType: "txt")
    let fm = NSFileManager.defaultManager()
    var data = NSData()
    
    let queue = NSOperationQueue()
    var pickerData = [25,100,500,2000]
    var pinsToSend = [MKPointAnnotation]()
    var pickerNum: Int = 0
    let fileManager = NSFileManager.defaultManager()
    var locData:[AnyObject] = []
    var coordinateData:[numPair] = []
    
    func printer() {
        for data in coordinateData{
            print(data.first)
            print(data.second)
            print("\n")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //First call to Twitter. Looking for tweets that include "Trump"
        getData("https://api.twitter.com/1.1/search/tweets.json?q=%23Trump&result_type=recent&geocode=37.781157%2C-122.398720%2C1000mi&count=100", str: "Data.txt")
        
        //Second call to Twitter. Looking for tweets that include "Hillary"
       //getData("https://api.twitter.com/1.1/search/tweets.json?q=%23Hillary&result_type=recent&geocode=37.781157%2C122.398720%2C10mi&count=100")
//        
//        //Third call to Twitter. Looking for tweets that include "FeelTheBern"
//        getData("https://api.twitter.com/1.1/search/tweets.json?q=%23Hillary&result_type=recent&geocode=37.781157%2C122.398720%2C10mi&count=100")
        
      
        
        hashTagOne.placeholder = "Hash Tag One"
        hashTagTwo.placeholder = "Hash Tag Two"
        hashTagThree.placeholder = "Hash Tag Three"
        //Picker.delegate = self
        //Picker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func readData(){
        let str:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let newPath = str.stringByAppendingPathComponent("Data.txt")
        let path = NSBundle.mainBundle().pathForResource("Data", ofType: "txt")
        var data = String()
        
        if fileManager.isReadableFileAtPath(newPath){
            do{
                data = try String(contentsOfFile: newPath)
                var first = String()
                var second = String()
                var foundComma:Bool = false
                var firstRun: Bool = true
                var count: Int = 0
                for character in data.characters {
                    if(character == ")"){
                        let newPair = numPair()
                        newPair.first = Double(first)!
                        newPair.second = Double(second)!
                        coordinateData.append(newPair)
                        print(first)
                        print(second)
                        first = ""
                        second = ""
                        foundComma = false
                    }
                    if(character == "(" || character == ")" || character == "[" || character == "]" || character == "\\" || character == " " || character == "\n" || character == "\"" ){
                        
                    }
                    else{
                        if !foundComma{
                            if(character != ","){
                                first.append(character)
                            }else{
                                count = count + 1
                                foundComma = true
                                firstRun = true
                            }
                        }
                        if foundComma{
                            if(count % 2 == 0){
                                foundComma = false
                            }
                            else{
                                if(!firstRun){
                                    if(character != ","){
                                        second.append(character)
                                    }
                                }else{
                                    firstRun = false
                                }
                            }
                        }
                    }
                }
            }catch{
                print("An error occured while reading the file")
            }
        }
    }
    
    func saveToFile(strs: String){
        
        let str : NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
       // print(str)
        let path = str.stringByAppendingPathComponent(strs)
//        print("Path starts here:")
//        print(path)
//        print("Path ends here")
        do{
            let text = locData
            try text.description.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch{
            print("error")
        }
        
    }
    
    func getData(query:String, str: String) {
        let client = TWTRAPIClient()
        let statusesShowEndpoint = query
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                let jsonError : NSError?
                do{
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    if let statuses = json!["statuses"] as? [AnyObject] {
                        for status in statuses {
                            let statusDict = status as? [String: AnyObject]
                            if let geo = statusDict!["geo"]{
                                //make sure what we have is not null
                                if statusDict!["geo"] as? [String: AnyObject] != nil{
                                    //get coordinates into what the form we want
                                    let coordinates = geo as? NSDictionary
                                    if let coord = coordinates!["coordinates"]{
                                        //add the coordinates to our locData array
                                        self.locData.append(coord)
                                    }
                                }
                              //  print(self.locData)
                                self.saveToFile("Data.txt")
                            }
                        }
                        self.readData()
                    }
                    
                }catch{
                    print("Error")
                }
            }else {
                print("Error: \(connectionError)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        pickerNum = pickerData[row]
        return pickerData[row].description
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let dest = segue.destinationViewController as! MapView
            var pinArr = [MKPointAnnotation]()
            // for pin in pinArr {

                       //dest.pinArr = OUR PINS
                        //pin login here
                        for c in self.coordinateData {
                            var pin = MKPointAnnotation()
                            let loc  = CLLocationCoordinate2D(latitude: c.first, longitude: c.second)
                            pin.coordinate = loc
                            pinArr.append(pin)
                        }
                        dest.pinArr = pinArr
        
        //}
        
        
    }

}

