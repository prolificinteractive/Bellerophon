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
    
    let killSwitchURL = "https://api.myjson.com/bins/19bad7"
    let forceUpdateURL = "https://api.myjson.com/bins/13f3h7"
    let perfectApp = "https://api.myjson.com/bins/s3uzf"

    var currentURLIndex = 0
    lazy var urlList: [String] = {
        return [self.killSwitchURL, self.forceUpdateURL, self.killSwitchURL, self.perfectApp]
    }()

    private var killSwitchManager: BellerophonManager?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        let view2 = UIView(frame: UIScreen.main.bounds)
        view2.backgroundColor = .white

        injetImageView(into: view, with: "bellerophon.jpg")
        injectLabel(into: view, with: "Bummer! The App is currently unavailable check back in a little while.\nRetrying in 10 seconds...")

        injetImageView(into: view2, with: "bellerophon.jpg")
        injectLabel(into: view2, with: "Force Update.\nRetrying in 10 seconds...")

        if let window = window {
            let config = BellerophonConfig(window: window, killSwitchView: view, forceUpdateView: view2, delegate: self)
            killSwitchManager = BellerophonManager(config: config)
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
        Alamofire.request(urlList[currentURLIndex],
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
        currentURLIndex += 1
    }

    func shouldForceUpdate() {
        // Add any additional code after force update has been initiated
    }

    func shouldKillSwitch() {
        // Add any additional code after kill switch has been initiated
    }

    func receivedError(error: NSError) {
        // Handle error
    }

    func injectLabel(into view: UIView, with text: String) {
        let label = UILabel(frame: view.frame)
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        view.addSubview(label)
    }

    func injetImageView(into view: UIView, with filename: String) {
        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: filename)!
        imageView.alpha = 0.5
        view.addSubview(imageView)
    }

}

