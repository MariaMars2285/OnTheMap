//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/20/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    @IBOutlet weak var pinLocation: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        if AppModel.instance.getCount() == 0 {
            self.refresh(sender: nil)
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem?) {
        self.refreshButton.isEnabled = false
        self.activityIndicator.startAnimating()
        AppModel.instance.getLocations {
            self.activityIndicator.stopAnimating()
            //self.mapView.reload
            self.refreshButton.isEnabled = true
        }
    }

  
}

extension MapViewController: MKMapViewDelegate {
    
}
