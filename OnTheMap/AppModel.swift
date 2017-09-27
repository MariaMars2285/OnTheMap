//
//  AppModel.swift
//  OnTheMap
//
//  Created by Maria  on 9/19/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation

class AppModel {
    
    static let instance = AppModel()

    public var userId: String!
    
    public var firstName: String!
    
    public var lastName: String!
    
    private var studentLocations: [StudentLocation] = []
    
    private init() { }
    
    func fetchLocations(completionHandler: ((Bool) -> Void)?) {
        StudentLocationAPI().fetchLocations { (locations, error) in
            if error != nil || locations == nil {
                DispatchQueue.main.async {
                    completionHandler?(false)
                }
            }
            self.studentLocations = locations!
            DispatchQueue.main.async {
                completionHandler?(true)
            }
        }
    }
    
    func getCount() -> Int {
        return studentLocations.count
    }
    
    func getLocation(atIndex index: Int) -> StudentLocation {
        return studentLocations[index]
    }
    
    func getLocations() -> [StudentLocation] {
        return studentLocations
    }
}
