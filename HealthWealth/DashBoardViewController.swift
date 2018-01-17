//
//  DashBoardViewController.swift
//  AppLaunchEyeCare
//
//  Created by Vittal Pai on 1/16/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit
import BluemixAppID
import BMSCore
import SwiftCloudant

class DashBoardViewController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    // Create a CouchDBClient
    let client = CouchDBClient(url: URL(string:"https://5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix:3218ea08dfb0870b61c00eb88fa73e2e0236f75bd5e215bc27a62ff1405b1077@5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix.cloudant.com")!, username:"5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix", password:"3218ea08dfb0870b61c00eb88fa73e2e0236f75bd5e215bc27a62ff1405b1077")
    let dbName = "healthwealth"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a document
        var revision:String? = nil
        if TokenStorageManager.sharedInstance.loadRevisionID() != nil {
            revision = TokenStorageManager.sharedInstance.loadRevisionID()!
        }
        let create = PutDocumentOperation(id: TokenStorageManager.sharedInstance.loadUserId(), revision: revision, body: ["token":TokenStorageManager.sharedInstance.loadStoredToken()], databaseName: dbName) {(response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while creating a document. Error:\(error)")
            } else {
                TokenStorageManager.sharedInstance.storeRevisionID(id: response?["rev"] as! String)
                print("Created document \(response?["id"]) with revision id \(response?["rev"])")
            }
        }
        client.add(operation:create)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func CaptureImage(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        // create an attachment
        let imageData:Data = (UIImagePNGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!) as Data?)!
        let putAttachment = PutAttachmentOperation(name: "image",
                                                   contentType:"text/plain",
                                                   data: imageData,
                                                   documentID: TokenStorageManager.sharedInstance.loadUserId()!,
                                                   revision: TokenStorageManager.sharedInstance.loadRevisionID()!,
                                                   databaseName: dbName) { (response, info, error) in
                                                    if let error = error {
                                                        print("Encountered an error while creating an attachment. Error:\(error)")
                                                    } else {
                                                        print("Created attachment \(response?["id"]) with revision id \(response?["rev"])")
                                                         TokenStorageManager.sharedInstance.storeRevisionID(id: response?["rev"] as! String)
                                                    }
        }
        client.add(operation: putAttachment)
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
