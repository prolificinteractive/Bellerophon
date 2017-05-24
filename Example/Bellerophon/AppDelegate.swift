//
//  AppDelegate.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import UIKit
import Alamofire
import Bellerophon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BellerophonManagerDelegate {

    var window: UIWindow?
    let killSwitchURL = "http://qa.cms.prolific.io/killswitch/status/vandelay/ios"
    private var killSwitchManager: BellerophonManager?

    func applicationDidFinishLaunching(_ application: UIApplication) {
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

        if let window = window {
            killSwitchManager = BellerophonManager(window: window)
            killSwitchManager?.delegate = self
            killSwitchManager?.killSwitchView = view
            killSwitchManager?.checkAppStatus()
        }
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        killSwitchManager?.fetchAppStatus { result in
            completionHandler(result)
        }
    }

    public func bellerophonStatus(_ manager: BellerophonManager,
                                  completion: @escaping (BellerophonObservable?, NSError?) -> ()) {
        // MAKE API CALL
        Alamofire.request(killSwitchURL,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding(),
                          headers: nil)
            .responseJSON { (response) in
                if let json = response.result.value as? JSON {
                    let model = BellerophonModel(json: json)
                    completion(model, nil)
                } else if let error = response.result.error as NSError? {
                    completion(nil, error)
                }
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

    func receivedError(error: NSError) {
        // Handle error
    }

}

