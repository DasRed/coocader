//
//  AdHandler.swift
//  Coocader
//
//  Created by Marco Starker on 05.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdHandler: NSObject, GADBannerViewDelegate, GADInterstitialDelegate {
    
    // height of the ad banner form scene art
    static let BANNER_HEIGHT = 100
    
    // google Ad Banner Id
    static let AD_BANNER_ID = "ca-app-pub-3926977073039595/2412083465"

    // google Ad INTERSTITIAL Id
    static let AD_INTERSTITIAL_ID = "ca-app-pub-3926977073039595/3306623465"

    /// events
    /// Events will be triggerd at the shared instance of EventManager
    enum EventType: String, EventTypeProtocol {
        case AdViewWillPresentScreen = "adViewWillPresentScreen"
        case AdViewDidDismissScreen = "adViewDidDismissScreen"
    }
    
    // view to append
    var view: UIView!
    
    // ad banner
    var bannerView: GADBannerView?

    // setting instance
    private var setting: Setting! = Setting.sharedSetting()

    // store handler
    private var store: Store! = Store.shared

    /// INTERSTITIAL ad
    private var interstitialAd: GADInterstitial!

    /// INTERSTITIAL ad viewable
    private var interstitialAdViewable: Bool = false

    /// interstitial ad dissmis block
    private var interstitialAdDismissBlock: (() -> Void) = {}

    // init
    init(_ view: UIView) {
        super.init()
        
        self.view = view
        self.setting.addListener(Setting.EventType.AdEnabledHasChanged, self.settingHasChanged)
        self.store.addListeners([
            Store.EventType.ProductWasBuyed: self.storeProductWasBuyed,
            Store.EventType.ProductWasRestored: self.storeProductWasBuyed
        ])

        #if !AD_DISABLED
            self.createInterstitial()
        #endif
    }
    
    // setting of adBannerEnabled has changed
    func settingHasChanged() {
        if (self.setting.adEnabled == true) {
            self.appendBanner()
        }
        else {
            self.removeAdBanner()
        }
    }

    /// creates the interstitial
    private func createInterstitial() -> AdHandler {
        guard self.setting.adEnabled == true else {
            return self
        }

        self.interstitialAdViewable = false

        let request = GADRequest()

        #if DEBUG
            request.testDevices = [kGADSimulatorID]
        #endif

        self.interstitialAd = GADInterstitial(adUnitID: AdHandler.AD_INTERSTITIAL_ID)
        self.interstitialAd.delegate = self
        self.interstitialAd.loadRequest(request)

        return self
    }

    /// append the ad banner
    func appendBanner() -> AdHandler {
        guard self.setting.adEnabled == true else {
            return self
        }
        
        #if !AD_DISABLED
            let request = GADRequest()
            
            #if DEBUG
                request.testDevices = [kGADSimulatorID]
            #endif
            
            var position = CGPoint()
            position.x = self.view.frame.size.width / 2 - kGADAdSizeBanner.size.width / 2
            position.y = 0
            
            let banner = GADBannerView(adSize: kGADAdSizeBanner, origin: position)
            banner.adUnitID = AdHandler.AD_BANNER_ID
            banner.rootViewController = AppDelegate.shared.controller
            banner.loadRequest(request)
            banner.delegate = self
            banner.hidden = true
            self.view.addSubview(banner)
            self.bannerView = banner
        #endif
        
        return self
    }

    /// remove the ad banner
    func removeAdBanner() -> AdHandler {
        if (self.bannerView != nil) {
            self.bannerView!.removeFromSuperview()
            self.bannerView = nil
        }
        
        return self
    }

    /// shows the interstitial
    func showInterstitial(dismiss: () -> Void = {}) -> AdHandler {
        self.interstitialAdDismissBlock = dismiss

        guard self.setting.adEnabled == true else {
            self.interstitialAdDismissBlock()
            return self
        }

        guard self.interstitialAdViewable == true else {
            self.interstitialAdDismissBlock()
            return self
        }

        self.interstitialAd.presentFromRootViewController(AppDelegate.shared.controller)

        return self
    }

    /// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
    /// the banner view to the view hierarchy if it hasn't been added yet.
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        bannerView.hidden = false
    }
    
    /// Tells the delegate that an ad request failed. The failure is normally due to network
    /// connectivity or ad availablility (i.e., no fill).
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        bannerView.hidden = true
        NSLog("BANNER: adView. didFailToReceiveAdWithError: %@", error.description)
    }
    
    /// Tells the delegate that a full screen view will be presented in response to the user clicking on
    /// an ad. The delegate may want to pause animations and time sensitive interactions.
    func adViewWillPresentScreen(bannerView: GADBannerView!) {
        EventManager.sharedEventManager().trigger(AdHandler.EventType.AdViewWillPresentScreen)
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(bannerView: GADBannerView!) {}
    
    /// Tells the delegate that the full screen view has been dismissed. The delegate should restart
    /// anything paused while handling adViewWillPresentScreen:.
    func adViewDidDismissScreen(bannerView: GADBannerView!) {
        EventManager.sharedEventManager().trigger(AdHandler.EventType.AdViewDidDismissScreen)
    }
    
    /// Tells the delegate that the user click will open another app, backgrounding the current
    /// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
    /// are called immediately before this method is called.
    func adViewWillLeaveApplication(bannerView: GADBannerView!) {}
    
    /// a product was buyed in the store
    func storeProductWasBuyed(event: Event) {
        guard let identifier = event.data as? String else {
            return
        }

        guard identifier == Store.ProductIdentifier.RemoveAd.rawValue else {
            return
        }

        self.setting.adEnabled = false
    }

    /// Called when an interstitial ad request succeeded. Show it at the next transition point in your
    /// application such as when transitioning between view controllers.
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        self.interstitialAdViewable = true
    }

    /// Called when an interstitial ad request completed without an interstitial to
    /// show. This is common since interstitials are shown sparingly to users.
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.interstitialAdViewable = false
        NSLog("interstitial: interstitial. didFailToReceiveAdWithError: %@", error.description)
    }

    /// Called just before presenting an interstitial. After this method finishes the interstitial will
    /// animate onto the screen. Use this opportunity to stop animations and save the state of your
    /// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
    /// Store from a link on the interstitial).
    func interstitialWillPresentScreen(ad: GADInterstitial!) {}

    /// Called before the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(ad: GADInterstitial!) {}

    /// Called just after dismissing an interstitial and it has animated off the screen.
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.interstitialAdDismissBlock()
        self.createInterstitial()
    }

    /// Called just before the application will background or terminate because the user clicked on an
    /// ad that will launch another application (such as the App Store). The normal
    /// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
    /// before this.
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {}
}