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
    
    func doLogin(email: String, password: String) {
        self.activityIndicator.startAnimating()
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            self.parseData(fromData: newData!)
            
        }
        task.resume()
        
    }
    
    func parseData(fromData data: Data) {
        
        do {
        
            let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        
        
            if let dict = parsedData as? Dictionary<String, Any>  {
                print(dict["account"] as Any)
            
                if let accountDict = dict["account"] as? Dictionary<String, Any> {
                    print(accountDict["key"] as Any)
                
                    if let user_id = accountDict["key"] {
                        AppModel.instance.userId = user_id as! String
                        self.loggedIn()
                    }
                }
            }
            print(AppModel.instance.userId)
            print(parsedData)

            
        }
        catch {
          print("Error")
        }

    }
    
    func loggedIn() {
        self.performSegue(withIdentifier: "MainSegue", sender: nil)
    }
   
    
}

