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
    
    private var studentLocations: [StudentLocation] = []
    
    private init() { }
    
    func getLocations(completionHandler: (() -> Void)?) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            self.parseLocation(fromData: data!)
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
        task.resume()
    }
    
    func parseLocation(fromData data: Data) {
        var json: Any?
        
        do {
            
            json = try JSONSerialization.jsonObject(with: data)
        } catch {
            print(error)
        }
        
        guard let locationData = json as? Dictionary<String, Any> else {
            return
        }
        guard let results = locationData["results"] as? [Any] else {
            return
        }
        
        studentLocations.removeAll()
        for result in results {
            let location = StudentLocation(dict: result as! [String: Any])
            studentLocations.append(location)
            
        }
    }
    
    func getCount() -> Int {
        return studentLocations.count
    }
    
    func getLocation(atIndex index: Int) -> StudentLocation {
        return studentLocations[index]
    }
}
