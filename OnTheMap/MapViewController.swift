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

    override func viewDidLoad() {
        super.viewDidLoad()
        if AppModel.instance.getCount() == 0 {
            self.refresh(sender: nil)
        } else {
            self.addAnnotations()
        }
    }
    
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
