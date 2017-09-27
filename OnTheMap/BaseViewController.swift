//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/27/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pinLocation: UIBarButtonItem!

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func refresh(sender: UIBarButtonItem?) {
        self.refreshButton.isEnabled = false
        self.activityIndicator.startAnimating()
        AppModel.instance.fetchLocations { (success) in
            self.activityIndicator.stopAnimating()
            self.refreshButton.isEnabled = true
            if success {
                self.refreshAnnotations()
            } else {
                self.refreshAnnotationsFailed()
            }
            
        }
    }
    
    func refreshAnnotations() {
        
    }
    
    func refreshAnnotationsFailed() {
        let alert = UIAlertController.errorAlert(title: "Failed!", message: "Failed to load Data. Please try again later!!")
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func logout(sender: UIBarButtonItem?) {
        self.activityIndicator.startAnimating()
        StudentLocationAPI().logout { (success) in
            DispatchQueue.main.async {
                if success {
                    self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                } else {
                    let alert = UIAlertController.errorAlert(title: "logoutError", message: "Logout Failed!")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
  

}
