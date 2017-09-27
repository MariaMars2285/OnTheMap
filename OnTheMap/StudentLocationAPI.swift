//
//  StudentLocationAPI.swift
//  OnTheMap
//
//  Created by Maria  on 9/26/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import UIKit

class StudentLocationAPI {
    
    // Returns a configured NSMutableURLRequest for post requests.
    func getPostRequest(url: String, body: Data) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
    
    // Returns a configured NSMutableURLRequest for get requests.
    func getRequest(url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    // Login API call.
    func login(withUserEmail email: String, andPassword password: String, completionHandler: ((_ data: Data?, _ error: Error?) -> Void)?) {
        
        var postDict: [String: Any?] = [:]
        postDict["username"] = email
        postDict["password"] = password
        
        var dataDict: [String: Any?] = [:]
        dataDict["udacity"] = postDict
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
        
        let request = getPostRequest(url: "https://www.udacity.com/api/session", body: jsonData)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                completionHandler?(nil, error)// Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            completionHandler?(newData,nil)
        }
        task.resume()
        
    }
    
    // Add Location API call.
    func addLocation(_ data: Data, completionHandler: ((_ succeeded: Bool) -> Void)?) {
        let request = getPostRequest(url: "https://parse.udacity.com/parse/classes/StudentLocation", body: data)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler?(false)// Handle error…
                return
            }
            
            completionHandler?(true)
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    // Parse the student location from the response.
    func parseLocation(fromData data: Data) -> [StudentLocation]? {
        
        var studentLocations: [StudentLocation] = []
        var json: Any?
        
        do {
            json = try JSONSerialization.jsonObject(with: data)
        } catch {
            return nil
        }
        
        guard let locationData = json as? [String: Any] else  {
           return nil
        }
        
        guard let results = locationData["results"] as? [Any] else {
            return nil
        }
        
        for result in results {
            let location = StudentLocation(dict: result as! [String: Any])
            studentLocations.append(location)
        }
        return studentLocations
    }
    
    
    //Fetch Locations API call.
    func fetchLocations(completionHandler: (([StudentLocation]?, Error? ) -> Void)?) {
        let request = getRequest(url: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error
                completionHandler?(nil,error)
                return
            }
            
            let locations = self.parseLocation(fromData: data!)
            DispatchQueue.main.async {
                completionHandler?(locations, nil)
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    // Logout API call.
    func logout(completionHandler: @escaping (Bool) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
        task.resume()
    }
    
    // Get User Details API Call.
    func getUserDetails(userId: String, completionHandler: (([String: Any]?) -> Void)?) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userId)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            if newData == nil {
                completionHandler?(nil)
                return
            }
            var json: Any?
            
            do {
                json = try JSONSerialization.jsonObject(with: newData!)
            } catch {
                completionHandler?(nil)
            }
            completionHandler?(json as? [String: Any])
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
