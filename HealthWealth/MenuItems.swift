//
//  MenuItems.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/24/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import Foundation
import UIKit

internal class MenuItems:NSObject  {
    
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
    
    class func getMenuItems() -> [String] {
        if(isDoctorFlagEnabled) {
            return self.doctorMenu
        }
        return self.normalMenu
    }
    
    class func addReviewFeature(name: String) {
        reviewSubmissionsFeatureName = name
        doctorMenu.insert(name, at: 3)
    }
    
    class func addOnlineEyeTestFeature(name: String) {
        onlineEyeTestFeatureName = name
        normalMenu.insert(name, at: 5)
    }
    
    class func changeBackgroundColor(color: String) {
        self.backgroundColor = hexStringToUIColor(color)
    }
    
    class func resetMenu() {
        TokenStorageManager.sharedInstance.clearStoredToken()
        isDoctorFlagEnabled = false
        onlineEyeTestFeatureName = "Online Eye Checkup"
        reviewSubmissionsFeatureName = "Review Submissions"
        backgroundColor =  hexStringToUIColor("#FEC058")
        normalMenu = [
            "About My Doctor",
            "Nearest Hospitals",
            "Prescriptions",
            "My Medicines",
            "First Aid Guide",
            "Daily Dose",
            "Emergency",
            "Donate Organs"]
        doctorMenu = [
            "Today's Appointments",
            "Nearest Hospitals",
            "First Aid Guide",
            "Daily Dose",
            "Emergency",
            "Donate Organs"]
    }
    
    class func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
    
    class func getImageName(_ menu : String) -> String {
        switch menu {
        case "Nearest Hospitals":
            return "Hospital"
        case "Prescriptions":
            return "Prescriptions"
        case "My Medicines":
            return "Medicines"
        case "About My Doctor":
            return "Doctor"
        case "First Aid Guide":
            return "FirstAid"
        case "Daily Dose":
            return "DailyDose"
        case onlineEyeTestFeatureName:
            return "EyeTest"
        case "Today's Appointments":
            return "Schedules"
        case reviewSubmissionsFeatureName:
            return "Review"
        case "Emergency":
            return "Ambulance"
        case "Donate Organs":
            return "Donate"
        default:
            return "FirstAid"
        }
    }
    
}
