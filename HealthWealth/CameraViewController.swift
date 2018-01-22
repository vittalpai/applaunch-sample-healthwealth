//
//  CameraViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/22/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraBtnTapped(_ sender: Any) {
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
            Utils.dismissOverlay(self)
            if(response) {
                let alert = UIAlertController(title: "Alert", message: "Successfully uploaded image for review. We will get back to you shortly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                     self.navigationController?.popViewController(animated: true)
                    //            let alert = UIAlertController(title: "Eye Image Submission Instructions", message: ", preferredStyle: .alert)
                    //            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:  captureImage))
                    //            self.present(alert, animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
