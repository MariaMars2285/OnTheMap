//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/2/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userId: String!
   
    // Sign Up Action: Takes user to Udacity Sign up page
    @IBAction func signUp(_ sender: UIButton!) {
        UIApplication.shared.open(URL(string: "http://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    // Login Action: Validates Email and Password and creates Udacity session by making appropriate API Call.
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else {
            self.showLoginEmptyAlert()
            return
        }
        if email == "" || password == "" {
            self.showLoginEmptyAlert()
            return
        }
        doLogin(email: email, password: password)
    }
    
    func showLoginEmptyAlert() {
        let alert = UIAlertController.errorAlert(title: "Login Error", message: "Email and Password should not be empty.")
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginErrorAlert() {
        let alert = UIAlertController.errorAlert(title: "Login Error", message: "Login Failed! Please try again!!")
        self.present(alert, animated: true, completion: nil)
    }
    
    // Makes a API call to create new session and on success takes user to the data view.
    func doLogin(email: String, password: String) {
        self.activityIndicator.startAnimating()
        StudentLocationAPI().login(withUserEmail: email, andPassword: password)
        { (data, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if error != nil || data == nil {
                    self.showLoginErrorAlert()
                    return
                }
                
                if self.parseData(fromData: data!) {
                    self.loggedIn()
                } else {
                    self.showLoginErrorAlert()
                }
            }
        }
    }
    
    // Parses the user data and gets the user id.
    func parseData(fromData data: Data) -> Bool {
        
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            
            guard let dict = parsedData as? [String: Any] else {
                return false
            }
            
            guard let accountDict = dict["account"] as? [String: Any] else {
                return false
            }
        
            if let user_id = accountDict["key"] {
                AppModel.instance.userId = user_id as! String
                return true
            } else {
                return false
            }
        } catch {
            print("Error")
            return false
        }
    }
    
    func loggedIn() {
        self.performSegue(withIdentifier: "MainSegue", sender: nil)
    }
   
    
}

