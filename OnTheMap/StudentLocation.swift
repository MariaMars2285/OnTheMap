//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Maria  on 9/19/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation

struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var mediaUrl: String?
    var latitude: Double?
    var longtitude: Double?
    
    init(dict: [String: Any]) {
        firstName = dict["firstName"] as? String
        lastName = dict["lastName"] as? String
        mediaUrl = dict["mediaUrl"] as? String
        latitude = dict["latitude"] as? Double
        longtitude = dict["longitude"] as? Double

    }
}
