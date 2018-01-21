//
//  DashBoardViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/20/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit

class DashBoardViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    var imagePicker: UIImagePickerController!
    static var menuItems = ["Health", "Medcines","Profile","Claims","Nearest Hospitals","Capture"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
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
        cell.cellImage.image = UIImage(named: ("gamburger"))
        cell.cellLabel.text = DashBoardViewController.menuItems[indexPath.row]
        return (cell)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(DashBoardViewController.menuItems[indexPath.row] == "Capture") {
            captureImage()
        } else if (DashBoardViewController.menuItems[indexPath.row] == "Submissions") {
            if (CloudantAdapter.sharedInstance.images.count != 0) {
                performSegue(withIdentifier: "submissions", sender: self)
            } else {
                showAlert("There is no pending images for review")
            }
        } else {
            showAlert("This feature is yet to be implemented")
        }
    }
    
    private func captureImage() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        Utils.showOverlay(self)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage!
        CloudantAdapter.sharedInstance.addImage(TokenStorageManager.sharedInstance.loadUserId()!, (image?.resized(withPercentage: 0.1)!.pngRepresentationData!)!,{ (response) in
            if(response) {
                Utils.dismissOverlay(self)
                print("Successfully uploaded image")
            }
        })
    }
    
  
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
