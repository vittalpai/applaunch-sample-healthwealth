//
//  DashBoardViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/20/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IBMAppLaunch

class DashBoardViewController: UITableViewController, NVActivityIndicatorViewable
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 130
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            AppLaunchAdapter.sharedInstance.displayMessage()
        }
        
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
        cell.cellView.backgroundColor = MenuItems.backgroundColor
        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(MenuItems.getMenuItems()[indexPath.row] == "Online Eye Checkup") {
             AppLaunchAdapter.sharedInstance.sendMetrics(value: "_awbeicwyj")
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
   
    @IBAction func logout(_ sender: Any) {
        MenuItems.resetMenu()
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }
    
}
