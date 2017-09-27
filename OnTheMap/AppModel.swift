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

    public var userId: String! {
        didSet {
            fetchUserDetails()
        }
    }
    
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
    
    func fetchUserDetails() {
        StudentLocationAPI().getUserDetails(userId: userId) { (dataDict) in
            if let dict = dataDict, let userDict = dict["user"] as? [String: Any] {
                print("test---- \(userDict)")
                self.firstName = userDict["first_name"] as! String
                self.lastName = userDict["last_name"] as! String
            }
        }
    }
}
