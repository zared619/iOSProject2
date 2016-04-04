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

class numPair: NSObject{
    var first:Double = 0.0
    var second:Double = 0.0
}

class TextData: NSObject{
    var text: String = ""
}

class ColorPointAnnotation: MKPointAnnotation{
    var pinColor: UIColor
    let coord: CLLocationCoordinate2D
    
    init(color: UIColor, coordinate: CLLocationCoordinate2D) {
        self.coord = coordinate
        self.pinColor = color
        
        super.init()
    }
}
class ViewController: UIViewController {
    @IBOutlet weak var hashTagOne: UITextField!
    @IBOutlet weak var hashTagTwo: UITextField!
    @IBOutlet weak var hashTagThree: UITextField!
    @IBOutlet weak var lat: UITextField!
    @IBOutlet weak var lon: UITextField!
    
    
    let file = NSBundle.mainBundle().pathForResource("Data", ofType: "txt")
    let fm = NSFileManager.defaultManager()
    var data = NSData()
    
    let queue = NSOperationQueue()
    var pinsToSend = [MKPointAnnotation]()
    let fileManager = NSFileManager.defaultManager()
    var locData: [AnyObject] = []
    var coordinateData:[numPair] = []
    var coordinateData2:[numPair] = []
    var coordinateData3:[numPair] = []
    var textData:[TextData] = []
    let file1 = "FirstHashtag"
    let file2 = "SecondHashtag"
    let file3 = "ThirdHashtag"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashTagOne.placeholder = "Hash Tag One"
        hashTagTwo.placeholder = "Hash Tag Two"
        hashTagThree.placeholder = "Hash Tag Three"
        lat.placeholder = "Location One"
        lon.placeholder = "Location Two"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
   @IBAction func Done(segue: UIStoryboardSegue){
        
    }
    @IBAction func SearchPress(){
        let dataStr = "https://api.twitter.com/1.1/search/tweets.json?q=%23" + hashTagOne.text! + "&result_type=recent&geocode="
        let dataStr2 = dataStr + lat.text! + "%2C" + lon.text! + "%2C1000mi&count=100"
        
        getData(dataStr2, fileName: file1 + ".txt")
        readData(file1, whichHashtag: 1)
        
        let searchForCoords = "https://api.twitter.com/1.1/search/tweets.json?q=%23" + hashTagTwo.text! + "&result_type=recent&geocode="
        let getDataFromCoords = searchForCoords + lat.text! + "%2C" + lon.text! + "%2C1000mi&count=100"
        
        getData(getDataFromCoords, fileName: file2 + ".txt")
        readData(file2, whichHashtag: 2)
        
        let searchForCoords2 = "https://api.twitter.com/1.1/search/tweets.json?q=%23" + hashTagThree.text! + "&result_type=recent&geocode="
        let getDataFromCoords2 = searchForCoords2 + lat.text! + "%2C" + lon.text! + "%2C1000mi&count=100"
        
        getData(getDataFromCoords2, fileName: file3 + ".txt")
        readData(file2, whichHashtag: 3)
    }
    
    func readData(strs: String, whichHashtag: Int){
        let str:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let newPath = str.stringByAppendingPathComponent((strs as String) + ".txt")
        //let path = NSBundle.mainBundle().pathForResource(strs as String, ofType: "txt")
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
                        switch whichHashtag{
                        case 1:
                             coordinateData.append(newPair)
                        case 2:
                             coordinateData2.append(newPair)
                        default:
                             coordinateData3.append(newPair)
                        }
                        foundComma = false
                        first = ""
                        second = ""
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
        let path = str.stringByAppendingPathComponent(strs)
        do{
            let text = locData
            try text.description.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch{
            print("error")
        }
        
    }
    
    func getData(query:String, fileName: String) {
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
                            let textFromJSON = statusDict! as Dictionary<String, AnyObject>
                            for (i,j) in textFromJSON{
                                let temp = TextData()
                                if(temp.respondsToSelector(Selector(i))){
                                    temp.setValue(String(j), forKey: i)
                                    self.textData.append(temp)
                                }
                            }
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
                                self.saveToFile(fileName)
                            }
                        }
                        self.readData(fileName, whichHashtag: 1)
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
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let dest = segue.destinationViewController as! UINavigationController
            let destin = dest.childViewControllers[0] as! MapView
            var pinArr = [ColorPointAnnotation]()
            var count = 0
            for c in self.coordinateData {
                let loc  = CLLocationCoordinate2D(latitude: c.first, longitude: c.second)
                let pin = ColorPointAnnotation(color: UIColor.greenColor(), coordinate: loc)
                pin.title = "#" + hashTagOne.text!
                pin.coordinate = loc
                pinArr.append(pin)
            }
        
            for c in self.coordinateData2 {
                let loc  = CLLocationCoordinate2D(latitude: c.first, longitude: c.second)
                let pin = ColorPointAnnotation(color: UIColor.redColor(), coordinate: loc)
                pin.title = "#" + hashTagTwo.text!
                pin.coordinate = loc
                pinArr.append(pin)
            }
            for c in self.coordinateData3 {
                let loc  = CLLocationCoordinate2D(latitude: c.first, longitude: c.second)
                let pin = ColorPointAnnotation(color: UIColor.blueColor(), coordinate: loc)
                pin.title = "#" + hashTagThree.text!
                pin.coordinate = loc
                pinArr.append(pin)
            }
            destin.pinArr = pinArr
    }

}

