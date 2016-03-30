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

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    

    @IBOutlet weak var hashTagOne: UITextField!
    @IBOutlet weak var hashTagTwo: UITextField!
    @IBOutlet weak var hashTagThree: UITextField!
    @IBOutlet weak var Picker: UIPickerView!
    
    let queue = NSOperationQueue()
    var pickerData = [25,100,500,2000]
    var pinsToSend = [MKPointAnnotation]()
    var pickerNum: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=%23FeeltheBern&result_type=recent&geocode=37.781157%2C-122.398720%2C10mi"
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
        if (connectionError == nil) {
            var jsonError : NSError?
              do{
                   let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                print(json)

                 }catch{
                     print("Error")
                 }
              }else {
                    print("Error: \(connectionError)")
                }
            }
        
        hashTagOne.placeholder = "Hash Tag One"
        hashTagTwo.placeholder = "Hash Tag Two"
        hashTagThree.placeholder = "Hash Tag Three"
        Picker.delegate = self
        Picker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
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
        print(pickerNum)
        return pickerData[row].description
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let dest = segue.destinationViewController
            // for pin in pinArr {
            let op = NSOperation()
            op.completionBlock = {
                if(!op.cancelled){
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                       //dest.pinArr = OUR PINS
                        //pin login here
                    })
                }
            }
            queue.addOperation(op)
        //}
        
        
    }

}

