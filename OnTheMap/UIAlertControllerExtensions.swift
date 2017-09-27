//
//  UIAlertControllerExtensions.swift
//  OnTheMap
//
//  Created by Maria  on 9/27/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func errorAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        return alert
    }
}
