//
//  ViewController.swift
//  Project2
//
//  Created by Andrew Pier on 3/29/16.
//  Copyright © 2016 Andrew Pier. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var hashTagOne: UITextField!
    @IBOutlet weak var hashTagTwo: UITextField!
    @IBOutlet weak var hashTagThree: UITextField!
    let queue = NSOperationQueue()
    var pinsToSend = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagOne.placeholder = "Hash Tag One"
        hashTagTwo.placeholder = "Hash Tag Two"
        hashTagThree.placeholder = "Hash Tag Three"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

