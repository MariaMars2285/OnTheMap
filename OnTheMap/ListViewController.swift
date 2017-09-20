//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/20/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pinLocation: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        if AppModel.instance.getCount() == 0 {
            self.refresh(sender: nil)
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem?) {
        self.refreshButton.isEnabled = false
        self.activityIndicator.startAnimating()
        AppModel.instance.getLocations {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.refreshButton.isEnabled = true
        }
    }
    
    @IBAction func pinLocation(sender: UIBarButtonItem?) {
    
    }
    
    @IBAction func logout(sender: UIBarButtonItem?) {
    
    }
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppModel.instance.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = AppModel.instance.getLocation(atIndex: indexPath.row)
        cell.textLabel?.text = location.firstName ?? "No Name"
        cell.detailTextLabel?.text = location.mediaUrl ?? "No Link"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
}

extension ListViewController: UITableViewDelegate {
    
}
