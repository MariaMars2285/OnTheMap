//
//  InformationPostingSecondViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/23/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingSecondViewController: UIViewController {
    
    var placemark: CLPlacemark!
    var mapString: String?
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let coordinate = placemark.location?.coordinate
        let region = MKCoordinateRegion(center: coordinate!, span: coordinateSpan)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func submitLink(_ sender: Any) {
        self.activityIndicator.startAnimating()
       
        let coordinate = placemark.location?.coordinate
        var postDict: [String: Any?] = [:]
        postDict["latitude"] = coordinate!.latitude
        postDict["longitude"] = coordinate!.longitude
        postDict["mediaURL"] = self.linkField.text
        postDict["mapString"] = self.mapString
        postDict["firstName"] = "Maria"
        postDict["lastName"] = "Selvam"
        postDict["uniqueKey"] = AppModel.instance.userId
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: postDict, options: .prettyPrinted) {
            addLocation(jsonData)
            return
        }
    }
    
    func addLocation(_ data: Data) {
        StudentLocationAPI().addLocation(data) { (succeeded) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if (succeeded) {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension InformationPostingSecondViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let identifier = "StudentLocationPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
        
    }
}
