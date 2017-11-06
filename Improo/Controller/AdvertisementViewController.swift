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
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-1829214457085802/2822142769"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "f74bec2a8ec746202a77d38886ba6a00" ]
        adBannerView.load(request)
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
}
