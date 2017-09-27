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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // Dismiss the current navigation controller.
    @IBAction func cancel(sender: UIBarButtonItem!) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.errorAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Find On Map action: takes location address and geocodes it. If geocoding succeeds, it takes to next screen.
    @IBAction func findOnMap(sender: UIButton!) {
        
        if locationField.text == nil || locationField.text == "" {
            self.showAlert(title: "Error", message: "Location Field cannot be empty!")
            return;
        }
        self.activityIndicator.startAnimating()
        
        let address = locationField.text!
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if error != nil {
                self.showAlert(title: "Error", message: "Geocode Error. Please try later!")
                return
            }
            
            if placemarks == nil {
                self.showAlert(title: "Error", message: "Placemark Error. Please try later!")
                return
            }
            
            let first = placemarks?.first
            
            if first == nil {
                self.showAlert(title: "Error", message: "Placemark Error. Please try later!")
                return
            }
            
            self.placemark = first
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

extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
