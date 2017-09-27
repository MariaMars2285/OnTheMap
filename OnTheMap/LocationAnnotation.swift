//
//  LocationAnnotation.swift
//  OnTheMap
//
//  Created by Maria  on 9/20/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import MapKit

/* Annotation for representing the Student Location Information */
class LocationAnnotation: NSObject, MKAnnotation {
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    convenience init(location: StudentLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longtitude!)
        self.init(title: location.name, subtitle: location.mediaUrl, coordinate: coordinate)
    }
}
