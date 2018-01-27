//
//  DashBoardViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/20/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DashBoardViewController: UITableViewController, NVActivityIndicatorViewable
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 130
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (MenuItems.getMenuItems().count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! DashBoardTableViewCell
        cell.cellImage.image = UIImage(named: (MenuItems.getImageName(MenuItems.getMenuItems()[indexPath.row])))
        cell.cellLabel.text = MenuItems.getMenuItems()[indexPath.row]
        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(MenuItems.getMenuItems()[indexPath.row] == "Online Eye Checkup") {
            performSegue(withIdentifier: "examineEye", sender: self)
        } else if (MenuItems.getMenuItems()[indexPath.row] == "Review Submissions") {
            if (CloudantAdapter.sharedInstance.images.count != 0) {
                performSegue(withIdentifier: "submissions", sender: self)
            } else {
                showAlert("There are no pending images for review")
            }
        } else {
            showAlert("This feature is yet to be implemented")
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    internal func showOverlay() {
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: .lineScale)
    }
    
    internal func changeOverlayMessage(_ message: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
    }
    
    internal func removeOverlay() {
        self.stopAnimating()
    }
    
}
