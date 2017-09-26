//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/23/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    var geoCoder = CLGeocoder()
    var placemark: CLPlacemark!
    
    @IBOutlet weak var locationField: UITextField!


    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Geocode Error. Please try later!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEmptyAlert() {
        let alert = UIAlertController(title: "No Error", message: "Empty. Please try later!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func findOnMap(sender: UIButton!) {
        if locationField.text == nil || locationField.text == "" {
            self.showEmptyAlert()
            return;
        }
        
        let address = locationField.text!
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                self.showErrorAlert()
                return
            }
            
            if placemarks == nil {
                self.showErrorAlert()
                return
            }
            
            let first = placemarks?.first
            
            if first == nil {
                self.showErrorAlert()
                return
            }
            
            self.placemark = first
            print(self.placemark.location)
            print(self.placemark.country)

            self.performSegue(withIdentifier: "InfoPostSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoPostSegue" {
            let vc = segue.destination as! InformationPostingSecondViewController
            vc.placemark = placemark
        }
    }
    
}
