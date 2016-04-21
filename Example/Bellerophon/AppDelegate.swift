//
//  AppDelegate.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Bellerophon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BellerophonManagerProtocol {

    var window: UIWindow?
    var killSwitchURL: String?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        killSwitchURL = "http://qa.cms.prolific.io/killswitch/status/vandelay/ios"

        BellerophonManager.sharedInstance.delegate = self

        let screenSize = UIScreen.mainScreen().bounds.size
        let view = UIView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))

        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "bellerophon.jpg")!
        view.addSubview(imageView)

        BellerophonManager.sharedInstance.killSwitchView = view
        BellerophonManager.sharedInstance.checkAppStatus()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        BellerophonManager.sharedInstance.fetchAppStatus { result in
            //Handle result
        }
    }

    @objc func bellerophonStatus(manager: BellerophonManager, completion: (status: BellerophonStatusProtocol?, error: NSError?) -> ()) {
        // MAKE API CALL
        assert(killSwitchURL != nil, "Kill switch URL has to be defined.")

        Alamofire.request(.GET, killSwitchURL!, parameters: nil, encoding: .JSON, headers: nil).responseObject {
            (response: Response<💩, NSError>) in
                completion(status: response.result.value, error: response.result.error)
        }
    }

    func shouldForceUpdate() {
        let alert = UIAlertView(title: "Force Update", message: "Force update message is received!", delegate: self, cancelButtonTitle: "Got it")
        alert.show()
    }

}

