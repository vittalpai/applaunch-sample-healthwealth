//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import SwiftCloudant

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        self.kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        self.kolodaView.delegate = self
        self.kolodaView.dataSource = self
        self.kolodaView.animator = BackgroundKolodaAnimator(koloda: self.kolodaView)
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //kolodaView.resetCurrentCardIndex()
        let alert = UIAlertController(title: "Alert", message: "Thanks for the review", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            //Clear Stored Images
            CloudantAdapter.sharedInstance.images = [UIImage]()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
       
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
     //   UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return CloudantAdapter.sharedInstance.images.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: CloudantAdapter.sharedInstance.images[index])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
