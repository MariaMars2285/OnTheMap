//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Maria  on 9/19/17.
//  Copyright © 2017 Maria . All rights reserved.
//

/* Student Location Struct for Information about the students */

import Foundation

struct StudentLocation {
    var firstName: String?
    var lastName: String?
    var mediaUrl: String?
    var latitude: Double?
    var longtitude: Double?
    
    var name: String {
        get {
            return (firstName ?? "") + " " + (lastName ?? "")
        }
    }
    
    init(dict: [String: Any]) {
        firstName = dict["firstName"] as? String
        lastName = dict["lastName"] as? String
        mediaUrl = dict["mediaURL"] as? String
        latitude = dict["latitude"] as? Double
        longtitude = dict["longitude"] as? Double

    }
}
