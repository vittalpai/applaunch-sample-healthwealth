//
//  Utils.swift
//  HealthWealth
//
//  Created by Vittal Pai on 1/19/18.
//  Copyright © 2018 Vittal Pai. All rights reserved.
//

import Foundation
import UIKit


internal class Utils : NSObject {
    
    class func showOverlay(_ viewController: UIViewController) {
        
        let alert = UIAlertController(title: nil, message: "Please wait..", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func dismissOverlay(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
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
