//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/20/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
            
    var annotations: [LocationAnnotation] = []
    
    // Adds annotations according to the student location data.
    func addAnnotations() {
        self.mapView.removeAnnotations(annotations)
        annotations.removeAll()
        for location in AppModel.instance.getLocations() {
            if location.latitude != nil && location.longtitude != nil {
                let annotation = LocationAnnotation(location: location)
                self.mapView.addAnnotation(annotation)
                annotations.append(annotation)
            }
        }
    }
    
    override func refreshAnnotations() {
        self.addAnnotations()
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let identifier = "StudentLocationPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? LocationAnnotation {
            if let mediaURLString = annotation.subtitle, let mediaURL = URL(string: mediaURLString) {
                UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            }
        }
    }
}
