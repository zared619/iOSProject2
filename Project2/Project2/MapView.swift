//
//  MapView.swift
//  Project2
//
//  Created by Andrew Pier on 3/29/16.
//  Copyright © 2016 Andrew Pier. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController {

    @IBOutlet weak var Map: MKMapView!
    var pinArr = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let loc  = CLLocationCoordinate2D(latitude: 41.55, longitude: -80.004)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let reg = MKCoordinateRegion(center: loc, span: span)
        Map.setRegion(reg, animated: false)
        let pin = MKPointAnnotation()
        pin.coordinate = loc
        pin.title = "Look overe here"
        Map.addAnnotation(pin)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(segue: UIStoryboardSegue, sender: AnyObject?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
