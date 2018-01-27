//
//  CameraViewController.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/22/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NVActivityIndicatorViewable {
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MenuItems.backgroundColor
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
        self.showOverlay()
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage!
        CloudantAdapter.sharedInstance.addImage(TokenStorageManager.sharedInstance.loadUserId()!, (image?.resized(withPercentage: 0.1)!.pngRepresentationData!)!,{ (response) in
            self.removeOverlay()
            if(response) {
                let alert = UIAlertController(title: "Alert", message: "Successfully uploaded image for review. We will get back to you shortly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
    internal func showOverlay() {
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Uploading Image...", type: .lineScale)
    }
    
    internal func removeOverlay() {
        self.stopAnimating()
    }
    
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var pngRepresentationData: Data? {
        return UIImagePNGRepresentation(self)
    }
    
}
