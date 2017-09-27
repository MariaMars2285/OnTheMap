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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    @IBAction func signUpButton(_ sender: UIButton!) {
        UIApplication.shared.openURL(URL(string: "http://www.udacity.com/account/auth#!/signup")!)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        
        if email == "" || password == "" {
            return
        }
        
        doLogin(email: email, password: password)
    }
    
    func showLoginErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController.errorAlert(title: "Login Error", message: "Login Failed! Please try again!!")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
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
                print("login done")
                if self.parseData(fromData: data!) {
                    self.loggedIn()
                } else {
                    self.showLoginErrorAlert()
                }
            }
        }
    }
    
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

