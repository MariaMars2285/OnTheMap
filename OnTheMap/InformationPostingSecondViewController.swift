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
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            }
        
        let coordinate = placemark.location?.coordinate
        var postDict: [String: Any?] = [:]
        postDict["latitude"] = coordinate!.latitude
        postDict["longitude"] = coordinate!.longitude
        postDict["mediaURL"] = self.linkField.text
        postDict["mapString"] = self.mapString
        postDict["firstName"] = "Maria"
        postDict["lastName"] = "Selvam"
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: postDict, options: .prettyPrinted) {
            print("5")
            addLocation(jsonData)
            print("4")
            return
        }
    }
    
    func addLocation(_ data: Data) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let session = URLSession.shared
        print("1")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print("2")
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        print("3")
        task.resume()
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
