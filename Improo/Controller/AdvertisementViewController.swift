//
//  AdvertisementViewController.swift
//  Improo
//
//  Created by Zakhar Garan on 01.11.17.
//  Copyright © 2017 GaranZZ. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdvertisementViewController: UIViewController {
    
    var interstitial: GADInterstitial?

    func createAndLoadInterstitial() {
        let currentInterstitial = GADInterstitial(adUnitID: "ca-app-pub-1829214457085802/9626079055")
        let request = GADRequest()
        
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID, "f74bec2a8ec746202a77d38886ba6a00" ]
        
        currentInterstitial.load(request)
        currentInterstitial.delegate = self
        interstitial = currentInterstitial
    }
}

extension AdvertisementViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
        FirestoreManager.shared.uploadError(error)
    }
}
