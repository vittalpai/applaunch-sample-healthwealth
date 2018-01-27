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
        cell.cellView.backgroundColor = MenuItems.backgroundColor
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
    static var isDoctorFlagEnabled: Bool = false
    static var onlineEyeTestFeatureName: String = "Online Eye Checkup"
    static var reviewSubmissionsFeatureName: String = "Review Submissions"
    static var backgroundColor: UIColor =  hexStringToUIColor("#FEC058")
    
    static var normalMenu:[String] = [
        "About My Doctor",
        "Nearest Hospitals",
        "Prescriptions",
        "My Medicines",
        "First Aid Guide",
        "Daily Dose",
        "Emergency",
        "Donate Organs"]
    
    static var doctorMenu:[String] = [
        "Today's Appointments",
        "Nearest Hospitals",
        "First Aid Guide",
        "Daily Dose",
        "Emergency",
        "Donate Organs"]
    @IBAction func logout(_ sender: Any) {
        MenuItems.resetMenu()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginBarView") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
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
