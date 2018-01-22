//
//  DashBoardViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/20/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit

class DashBoardViewController: UITableViewController
{
    
    static var menuItems = ["About My Doctor","Nearest Hospitals", "Prescriptions","Online Eye Checkup","My Medicines","First Aid Guide","Daily Dose","Emergency","Donate Organs"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 130
        Utils.showOverlay(self)
        CloudantAdapter.sharedInstance.createDocument(TokenStorageManager.sharedInstance.loadUserId()!,  { (response) in
            if(response) {
                print("Successfully created User Doc")
                CloudantAdapter.sharedInstance.getImages{(response) in
                    Utils.dismissOverlay(self)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (DashBoardViewController.menuItems.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! DashBoardTableViewCell
        var imageName:String
        switch DashBoardViewController.menuItems[indexPath.row] {
        case "Nearest Hospitals":
            imageName = "Hospital"
        case "Prescriptions":
             imageName = "Prescriptions"
        case "My Medicines":
             imageName = "Medicines"
        case "About My Doctor":
            imageName = "Doctor"
        case "First Aid Guide":
             imageName = "FirstAid"
        case "Daily Dose":
            imageName = "DailyDose"
        case "Online Eye Checkup":
            imageName = "EyeTest"
        case "Today's Appointments":
            imageName = "Schedules"
        case "Review Submissions":
            imageName = "Review"
        case "Emergency":
            imageName = "Ambulance"
        case "Donate Organs":
            imageName = "Donate"
        default:
            imageName = "FirstAid"
        }
        cell.cellImage.image = UIImage(named: (imageName))
        cell.cellLabel.text = DashBoardViewController.menuItems[indexPath.row]
        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(DashBoardViewController.menuItems[indexPath.row] == "Online Eye Checkup") {
            performSegue(withIdentifier: "examineEye", sender: self)
        } else if (DashBoardViewController.menuItems[indexPath.row] == "Review Submissions") {
            if (CloudantAdapter.sharedInstance.images.count != 0) {
                performSegue(withIdentifier: "submissions", sender: self)
            } else {
                showAlert("There is no pending images for review")
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

}
