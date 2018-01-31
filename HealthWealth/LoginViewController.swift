//
//  ViewController.swift
//  AppLaunchEyeCare
//
//  Created by Vittal Pai on 1/16/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import UIKit
import BluemixAppID
import BMSCore
import NVActivityIndicatorView

class LoginViewController: UIViewController, NVActivityIndicatorViewable {
    
    private var isShowingOverlay:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class delegate : AuthorizationDelegate {
        
        var viewController: LoginViewController
        
        init(viewController: LoginViewController) {
            self.viewController = viewController
        }
        
        func onAuthorizationSuccess(accessToken: AccessToken?, identityToken: IdentityToken?, response: Response?) {
            viewController.showOverlay()
            if (accessToken?.isAnonymous)! {
                TokenStorageManager.sharedInstance.storeToken(token: accessToken?.raw)
            } else {
                TokenStorageManager.sharedInstance.clearStoredToken()
            }
            
            let mailID = identityToken?.email != nil ? identityToken?.email : ""
            let name = identityToken?.name != nil ? identityToken?.name : (accessToken?.subject != nil ? accessToken?.subject : "guest")
            TokenStorageManager.sharedInstance.storeUserId(userId: name)
            
            CloudantAdapter.sharedInstance.isDoctor(mailID!) { (resp) in
                var userType = ""
                if(resp) {
                    MenuItems.isDoctorFlagEnabled = true
                    userType = "doctor"
                } else {
                    userType = "normal"
                }
                self.viewController.changeOverlayMessage("Initializing AppLaunch..")
                AppLaunchAdapter.sharedInstance.initialize(username: name!, userType: userType, completionHandler: { (Success, Failure) in
                    if (Success != nil) {
                        self.viewController.checkForEnabledFeatures({ (resp) in
                            self.viewController.changeOverlayMessage("Preparing DashBoard..")
                            CloudantAdapter.sharedInstance.createDocument(TokenStorageManager.sharedInstance.loadUserId()!,  { (response) in
                                if(response) {
                                    if AppLaunchAdapter.sharedInstance.isSubmissionMenuEnabled() && MenuItems.isDoctorFlagEnabled {
                                        self.viewController.changeOverlayMessage("Loading Images")
                                        CloudantAdapter.sharedInstance.getImages{(response) in
                                            self.viewController.removeOverlay()
                                            self.viewController.displayDashBoardView()
                                        }
                                    } else {
                                        self.viewController.removeOverlay()
                                        self.viewController.displayDashBoardView()
                                    }
                                }
                            })
                        })
                    }
                    else {
                        self.viewController.removeOverlay()
                        let alert = UIAlertController(title: "Alert", message: "AppLaunch Service Intialization Failed, Try again some", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.viewController.present(alert, animated: true)
                    }
                })
            }
        }
        
        public func onAuthorizationCanceled() {
            print("cancel")
            self.viewController.removeOverlay()
        }
        
        public func onAuthorizationFailure(error: AuthorizationError) {
            print(error)
            self.viewController.removeOverlay()
        }
    }
    @IBAction func login_anonymously(_ sender: AnyObject) {
        showOverlay()
        let token = TokenStorageManager.sharedInstance.loadStoredToken()
        AppID.sharedInstance.loginAnonymously(accessTokenString: token, authorizationDelegate: delegate(viewController: self))
    }
    
    @IBAction func log_in(_ sender: AnyObject) {
        let token = TokenStorageManager.sharedInstance.loadStoredToken()
        AppID.sharedInstance.loginWidget?.launch(accessTokenString: token, delegate: delegate(viewController: self))
        
    }
    
    internal func checkForEnabledFeatures(_ completionHandler:@escaping ((Bool) -> Void)) {
        // Check whether online eye test menu enabled
        if(AppLaunchAdapter.sharedInstance.isOnlineEyeTestMenuEnabled()) {
            MenuItems.addOnlineEyeTestFeature(name: AppLaunchAdapter.sharedInstance.getOnlineEyeTestMenuName())
        }
        // Check whether Submission Menu is enabled
        if(AppLaunchAdapter.sharedInstance.isSubmissionMenuEnabled() && MenuItems.isDoctorFlagEnabled) {
            MenuItems.addReviewFeature(name: AppLaunchAdapter.sharedInstance.getSubmissionMenuName())
        }
        // Update Background Color
        if(AppLaunchAdapter.sharedInstance.isBackgroundColorChanged()) {
            MenuItems.changeBackgroundColor(color: AppLaunchAdapter.sharedInstance.getBackGroundColor())
        }
        completionHandler(true)
    }
    
    internal func showOverlay() {
        if (!isShowingOverlay) {
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: .lineScale)
            isShowingOverlay = true
        }
        
    }
    
    internal func changeOverlayMessage(_ message: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
    }
    
    internal func removeOverlay() {
        self.stopAnimating()
        isShowingOverlay = false
    }
    
    internal func displayDashBoardView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationView") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

