//
//  CloundantAdapter.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/18/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import Foundation
import SwiftCloudant


internal class CloudantAdapter {
    internal static var sharedInstance = CloudantAdapter()
    
    var images:[UIImage] = [UIImage]()
    
    let client = CouchDBClient(url: URL(string:"https://5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix:3218ea08dfb0870b61c00eb88fa73e2e0236f75bd5e215bc27a62ff1405b1077@5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix.cloudant.com")!, username:"5bf42439-5b18-4464-bbfb-4f38f16fcbea-bluemix", password:"3218ea08dfb0870b61c00eb88fa73e2e0236f75bd5e215bc27a62ff1405b1077")
    let dbName = "healthwealth"
    
    internal func createDocument(_ documentID: String,_ completionHandler:@escaping ((Bool) -> Void)) {
        let create = PutDocumentOperation(id: documentID, revision: nil, body: [:], databaseName: dbName) {(response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while creating a document. Error:\(error)")
                self.getRevisionID(documentID, completionHandler: { (revisionid) in
                    if (!revisionid.isEmpty) {
                        completionHandler(true)
                    } else {
                        self.createDocument(documentID, completionHandler)
                    }
                })
            } else {
                print("Created document \(String(describing: response?["id"])) with revision id \(String(describing: response?["rev"]))")
                completionHandler(true)
            }
        }
        client.add(operation:create)
    }
    
    internal func addImage(_ documentID: String,_ image: Data,_  completionHandler:@escaping ((Bool) -> Void)) {
        getRevisionID(documentID) { (RevisionID) in
            if (!RevisionID.isEmpty) {
                let putAttachment = PutAttachmentOperation(name: "image",
                                                           contentType:"text/plain",
                                                           data: image,
                                                           documentID: documentID,
                                                           revision: RevisionID,
                                                           databaseName: self.dbName) { (response, info, error) in
                                                            if let error = error {
                                                                print("Encountered an error while creating an attachment. Error:\(error)")
                                                                completionHandler(false)
                                                            } else {
                                                                print("Created attachment \(String(describing: response?["id"])) with revision id \(response?["rev"])")
                                                                completionHandler(true)
                                                            }
                }
                self.client.add(operation: putAttachment)
            }
        }
        
    }
    
    internal func deleteDocument(_ documentID: String,_ completionHandler:@escaping ((Bool) -> Void)) {
        // Delete a document
        getRevisionID(documentID) { (revisionID) in
            if (revisionID != "") {
                let delete = DeleteDocumentOperation(id: documentID,
                                                     revision: revisionID,
                                                     databaseName: self.dbName) { (response, httpInfo, error) in
                                                        if let error = error {
                                                            print("Encountered an error while deleting a document. Error: \(error)")
                                                            completionHandler(false)
                                                        } else {
                                                            completionHandler(true)
                                                        }
                }
                self.client.add(operation:delete)
            } else {
                completionHandler(true)
            }
        }
        
    }
    
    
    internal func isDoctor(_ username: String,_ completionHandler:@escaping ((Bool) -> Void)) {
        let readID = GetDocumentOperation(id: "Doctors", databaseName: dbName) { (response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while deleting a document. Error: \(error)")
                completionHandler(false)
            } else {
                let resp:String = response?[username] != nil ?  response?[username] as! String : ""
                if (resp.lowercased() == "enable") {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
        client.add(operation:readID)
    }
    
    private func getRevisionID(_ documentID: String, completionHandler:@escaping ((String) -> Void)) {
        let readID = GetDocumentOperation(id: documentID, databaseName: dbName) { (response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while deleting a document. Error: \(error)")
                completionHandler("")
            } else {
                completionHandler(response?["_rev"] as! String)
            }
        }
        client.add(operation:readID)
    }
    
    internal func getImages(_ completionHandler:@escaping ((Bool) -> Void)) {
        let view = QueryViewOperation(name: "all", designDocumentID: "getimages", databaseName: dbName, rowHandler: { (row) in
            let reteiveImage = ReadAttachmentOperation(name: "image", documentID: row["id"] as! String, databaseName: self.dbName){ (data, info, error) in
                if error != nil {
                    print("Error : Retreiving Image")
                } else {
                    let image = UIImage(data: data!)!
                    self.images.append(image)
                }
            }
            self.client.add(operation: reteiveImage)
        },completionHandler: { (response, status, error) in
            if (error != nil ){
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
        client.add(operation:view)
    }
    
    
}
