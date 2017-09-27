//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Maria  on 9/20/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        if AppModel.instance.getCount() == 0 {
            self.refresh(sender: nil)
        }
    }
    
    override func refreshAnnotations() {
        self.tableView.reloadData()
    }
    
    @IBAction func pinLocation(sender: UIBarButtonItem?) {
    
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
