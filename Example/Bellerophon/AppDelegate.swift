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
class AppDelegate: UIResponder, UIApplicationDelegate, BellerophonManagerDelegate {

    var window: UIWindow?
    var killSwitchURL: String?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        killSwitchURL = "http://qa.cms.prolific.io/killswitch/status/vandelay/ios"

        BellerophonManager.sharedInstance.delegate = self

        let screenSize = UIScreen.main.bounds.size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))

        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bellerophon.jpg")!
        view.addSubview(imageView)

        let label = UILabel(frame: view.frame)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Bummer! The App is currently unavailable check back in a little while."
        view.addSubview(label)

        BellerophonManager.sharedInstance.killSwitchView = view
        BellerophonManager.sharedInstance.checkAppStatus()
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BellerophonManager.sharedInstance.fetchAppStatus { result in
            completionHandler(result)
        }
    }

    public func bellerophonStatus(_ manager: BellerophonManager,
                                  completion: @escaping (BellerophonObservable?, NSError?) -> ()) {
        // MAKE API CALL
        assert(killSwitchURL != nil, "Kill switch URL has to be defined.")

        Alamofire.request(killSwitchURL!, method: .get, parameters: nil, encoding: JSONEncoding(), headers: nil)
            .responseObject { (response: DataResponse<💩>) in
                completion(response.result.value, response.result.error as NSError?)
        }
    }

    func shouldForceUpdate() {
        let alertController = UIAlertController(title: "Force Update",
                                                message: "Force update message is received!",
                                                preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)

        guard let rootViewController = window?.rootViewController else {
            return
        }

        alertController.show(rootViewController, sender: nil)
    }

}

