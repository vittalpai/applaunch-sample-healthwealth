//
//  AppLaunchAdapter.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/24/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import Foundation
import IBMAppLaunch

internal class AppLaunchAdapter {
    
    internal static var sharedInstance = AppLaunchAdapter()
    
    internal func initialize(username: String, userType: String, completionHandler: @escaping AppLaunchCompletionHandler) {
        let config = AppLaunchConfig.Builder().fetchPolicy(.REFRESH_ON_EVERY_START).cacheExpiration(1).eventFlushInterval(100).build()
        let user = AppLaunchUser.Builder(userId: username).custom(key: "type", value: userType).build()
        AppLaunch.sharedInstance.initialize(region: .US_SOUTH, appId: "48fdee1d-3261-469b-bddc-bc8d4e6aa7b7", clientSecret: "c4591d8f-ca5d-4158-9e36-5702eb40310a", config: config, user: user, completionHandler: completionHandler)
    }
    
    internal func isOnlineEyeTestMenuEnabled() -> Bool {
        do {
            return try AppLaunch.sharedInstance.isFeatureEnabled(featureCode: "_5otjezpky")
        } catch {
            return false
        }
    }
    
    internal func getOnlineEyeTestMenuName() -> String {
        do {
            return try AppLaunch.sharedInstance.getPropertyofFeature(featureCode: "_5otjezpky", propertyCode: "_0qa7zj374")
        } catch {
            return "sd"
        }
    }
    
    internal func isSubmissionMenuEnabled() -> Bool {
        do {
            return try AppLaunch.sharedInstance.isFeatureEnabled(featureCode: "_gj705ri9d")
        } catch {
            return false
        }
    }
    
    internal func getSubmissionMenuName() -> String {
        do {
            return try AppLaunch.sharedInstance.getPropertyofFeature(featureCode: "_gj705ri9d", propertyCode: "_l4pwv1wtn")
        } catch {
            return "sd"
        }
    }
    
    internal func isBackgroundColorChanged() -> Bool {
        do {
            return try AppLaunch.sharedInstance.isFeatureEnabled(featureCode: "_6deefh571")
        } catch {
            return false
        }
    }
    
    internal func getBackGroundColor() -> String {
        do {
            return try AppLaunch.sharedInstance.getPropertyofFeature(featureCode: "_6deefh571", propertyCode: "_g2kgxscod")
        } catch {
            return "#FEC058"
        }
    }
    
    internal func displayMessage() {
        do {
            try AppLaunch.sharedInstance.displayMessage()
        } catch {
            
        }
    }
    
    internal func sendMetrics(value: String) {
        do {
            try AppLaunch.sharedInstance.sendMetrics(codes: [value])
        } catch {
            
        }
    }
    
    
    internal func destroy() {
        AppLaunch.sharedInstance.destroy { (Success, Failure) in
            if(Success != nil) {
                print("Successfully unregistered from AppLaunch Service")
            }
        }
    }
}
