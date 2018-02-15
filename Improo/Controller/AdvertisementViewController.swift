//
//  AdvertisementViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 01.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdvertisementViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var advertisementView: UIView?
    @IBOutlet weak var advertisementViewHeightConstraint: NSLayoutConstraint?
    
    fileprivate var adBannerView: GADBannerView?

    var userHasFullAccess: Bool {
        return UserDefaults.standard.bool(forKey: FullAccessID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userHasFullAccess { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AdvertisementViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: PurchaseNotification),
                                               object: nil)
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "f74bec2a8ec746202a77d38886ba6a00" ]
        
        adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView?.adUnitID = "ca-app-pub-1829214457085802/2822142769"
        adBannerView?.delegate = self
        adBannerView?.rootViewController = self
        adBannerView?.load(request)
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        UIView.animate(withDuration: 0.5) {
            self.advertisementViewHeightConstraint?.constant = bannerView.frame.height
            self.view.layoutIfNeeded()
        }
        advertisementView?.addSubview(bannerView)
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        UIView.animate(withDuration: 0.5) {
            self.advertisementViewHeightConstraint?.constant = 0
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        if productID == FullAccessID {
            //Hide Advertisement Banner
            if let bannerView = self.adBannerView {
                bannerView.delegate = nil
                adViewWillDismissScreen(bannerView)
            }
            adBannerView = nil
        } else {
            showAlert(title: "Purchase Error", message: productID)
        }
    }
}
