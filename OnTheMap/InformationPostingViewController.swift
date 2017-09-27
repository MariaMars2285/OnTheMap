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
    
    @IBAction func cancel(sender: UIBarButtonItem!) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnMap(sender: UIButton!) {
        
        if locationField.text == nil || locationField.text == "" {
            self.showEmptyAlert()
            return;
        }
        self.activityIndicator.startAnimating()
        
        let address = locationField.text!
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if error != nil {
                UIAlertController.errorAlert(title: "Error", message: "Error. Please try again!")
                return
            }
            
            if placemarks == nil {
                UIAlertController.errorAlert(title: "Placemark Error", message: "Placemark Error. Please try again!")
                return
            }
            
            let first = placemarks?.first
            
            if first == nil {
                UIAlertController.errorAlert(title: "Empty Error", message: "Empty. Please try again later!")
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

extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
