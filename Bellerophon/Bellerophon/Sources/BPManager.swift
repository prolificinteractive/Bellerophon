//
//  BPManager.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

public class BellerophonManager: NSObject {

    // MARK: Singleton instance
    public static let sharedInstance = BellerophonManager()

    // MARK: Public properties
    public var killSwitchView: UIView!
    public var appStatus: BellerophonStatusProtocol?
    public weak var delegate: BellerophonManagerProtocol?

    // MARK: Private properties
    private lazy var killSwitchWindow: UIWindow = {
        let window = BellerophonHelperMethods.newWindow()
        window.windowLevel = UIWindowLevelAlert;
        let rootViewController = UIViewController();
        rootViewController.view.addSubview(self.killSwitchView)
        window.rootViewController = rootViewController;
        return window
    }()
    private var requestPending = false
    private var retryTimer: NSTimer?

    // MARK: Public Methods
    public func checkAppStatus() {
        assert(killSwitchView != nil, "The kill switch view has to be defined.")

        if self.requestPending {
            return;
        }

        self.requestPending = true
        self.stopTimer()

        self.delegate?.bellerophonStatus(self, completion: { (status, error) -> () in
            self.requestPending = false
            if let status = status {
                self.handleAppStatus(status)
            } else {
                self.dismissKillSwitchIfNeeded()
            }
        })
    }

    public func fetchAppStatus(completionHandler: (result: UIBackgroundFetchResult) -> ()) {
        self.delegate?.bellerophonStatus(self, completion: { (status, error) -> () in
            if let status = status {
                self.handleAppStatus(status)
                if status.apiInactive() {
                    // If the kill switch or queue-it is still active we don't need to update anything
                    completionHandler(result: .NoData)
                } else {
                    // If the kill switch and queue-it are back to normal, we can stop fetching
                    completionHandler(result: .NewData)
                }
            } else {
                // An error occurred
                completionHandler(result: .Failed)
            }
        })
    }

    // MARK: Private Methods
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(stopTimer()), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func handleAppStatus(status: BellerophonStatusProtocol) {
        if status.apiInactive() {
            self.displayKillSwitch(status.userMessage())
            self.startAutoChecking(status)
        } else if status.forceUpdate() {
            self.performForceUpdate()
        } else {
            self.dismissKillSwitchIfNeeded()
        }
    }

    private func stopTimer() {
        self.retryTimer?.invalidate()
        self.retryTimer = nil
    }

    // MARK: Force Update Methods
    func performForceUpdate() {
        self.delegate?.checkVersion(self)
    }

    // MARK: Kill Switch Methods
    func displayKillSwitch(message: String) {
        if !self.killSwitchWindow.keyWindow {
            self.killSwitchView.frame = self.killSwitchWindow.bounds
            self.delegate?.bellerophonWillEngage?(self)
            self.killSwitchWindow.makeKeyAndVisible()
        }
    }

    func startAutoChecking(status: BellerophonStatusProtocol) {
        if self.retryTimer == nil {
            self.retryTimer = BellerophonHelperMethods.timerWithStatus(status, target: self, selector: Selector("checkAppStatus"))
        }
    }

    func dismissKillSwitchIfNeeded() {
        if self.killSwitchWindow.keyWindow {
            self.delegate?.bellerophonWillDisengage?(self)
            self.killSwitchWindow.hidden = true;
        }
    }

}
