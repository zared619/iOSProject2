//
//  MapView.swift
//  Project2
//
//  Created by Andrew Pier on 3/29/16.
//  Copyright © 2016 Andrew Pier. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    var pinArr = [ColorPointAnnotation]()
    var pinArr2 = [ColorPointAnnotation]()
    var pinArr3 = [ColorPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Map.delegate = self
        
        let loc  = CLLocationCoordinate2D(latitude: 41.55, longitude: -80.004)
        let span = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        let reg = MKCoordinateRegion(center: loc, span: span)
        Map.setRegion(reg, animated: false)
        
        for pin in pinArr{
            self.Map.addAnnotation(pin)
        }
        for pin in pinArr2{
            self.Map.addAnnotation(pin)
        }
        for pin in pinArr3{
            self.Map.addAnnotation(pin)
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ColorPointAnnotation{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.pinTintColor = annotation.pinColor
            }
            return view
        }
        return nil
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
