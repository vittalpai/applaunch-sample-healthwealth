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

class LoginViewController: UIViewController {

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
            
            if (accessToken?.isAnonymous)! {
                TokenStorageManager.sharedInstance.storeToken(token: accessToken?.raw)
            } else {
                TokenStorageManager.sharedInstance.clearStoredToken()
            }
            TokenStorageManager.sharedInstance.storeUserId(userId: accessToken?.subject)
            let name = identityToken?.name != nil ? identityToken?.name : ""
            if (name?.lowercased().starts(with: "v"))! {
                DashBoardViewController.menuItems = ["Today's Appointments","Review Submissions","Nearest Hospitals","First Aid Guide","Daily Dose","Emergency","Donate Organs"]
            }
            let mainView  = UIApplication.shared.keyWindow?.rootViewController
            let afterLoginView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationView") as! UINavigationController
            DispatchQueue.main.async {
                mainView?.present(afterLoginView, animated: true, completion: nil)
                }
           
        }
       
        
        public func onAuthorizationCanceled() {
            print("cancel")
        }
        
        public func onAuthorizationFailure(error: AuthorizationError) {
            print(error)
        }
    }
    @IBAction func login_anonymously(_ sender: AnyObject) {
        let token = TokenStorageManager.sharedInstance.loadStoredToken()
        AppID.sharedInstance.loginAnonymously(accessTokenString: token, authorizationDelegate: delegate(viewController: self))
    }
  
    @IBAction func log_in(_ sender: AnyObject) {
        let token = TokenStorageManager.sharedInstance.loadStoredToken()
        AppID.sharedInstance.loginWidget?.launch(accessTokenString: token, delegate: delegate(viewController: self))
        
    }


}

