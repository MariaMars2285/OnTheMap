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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.text = ""
        passwordField.text = ""
    }
   
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
    
    func showIncorrectCredentialsAlert() {
        let alert = UIAlertController.errorAlert(title: "Login Failed Error", message: "Incorrect Username or Password! Please try again!!")
        self.present(alert, animated: true, completion: nil)
    }
    
    // Makes a API call to create new session and on success takes user to the data view.
    func doLogin(email: String, password: String) {
        self.activityIndicator.startAnimating()
        StudentLocationAPI().login(withUserEmail: email, andPassword: password)
        { (userId, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if error != nil  {
                    self.showLoginErrorAlert()
                    return
                } else if userId == nil {
                    self.showIncorrectCredentialsAlert()
                    return
                }
                AppModel.instance.userId = userId
                self.loggedIn()
            }
        }
    }
    
    
    
    func loggedIn() {
        self.performSegue(withIdentifier: "MainSegue", sender: nil)
    }
   
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField == textField {
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
        }
        return true
    }
}
