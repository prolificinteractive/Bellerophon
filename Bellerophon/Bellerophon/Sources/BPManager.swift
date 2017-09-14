//
//  BPManager.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import UIKit

/// The Bellerophon manager.
public class BellerophonManager: NSObject {

    // MARK: - Initializers

    /// The default initializer.
    ///
    /// - Parameter window: The root window.
    public init(window: UIWindow) {
        super.init()
        mainWindow = window

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopTimer),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Properties

    /// View to be shown when the kill switch is turned on. Must be set by the application using Bellerophon
    public var killSwitchView: UIView!

    /// BellerophonManager delegate
    public weak var delegate: BellerophonManagerDelegate?

    // MARK: internal properties

    /// The kill switch window.
    internal lazy var killSwitchWindow: UIWindow = {
        let window = BellerophonHelperMethods.newWindow()
        window.windowLevel = UIWindowLevelAlert
        let rootViewController = UIViewController()
        rootViewController.view.addSubview(self.killSwitchView)
        window.rootViewController = rootViewController

        return window
    }()

    private weak var mainWindow: UIWindow?

    internal var requestPending = false
    internal var retryTimer: Timer?

    // MARK: Public Methods

    /**
     Retrieves and handles the app status from the AMS endpoint
     */
    public func checkAppStatus() {
        assert(killSwitchView != nil, "The kill switch view has to be defined.")

        guard !requestPending else {
            return
        }

        requestPending = true
        stopTimer()

        delegate?.bellerophonStatus(self) { [weak self] status, error in
            self?.requestPending = false
            if let status = status {
                self?.handleAppStatus(status)
            } else if let error = error {
                self?.handleError(error: error)
            } else {
                self?.dismissKillSwitchIfNeeded()
            }
        }
    }

    /**
     Use this function to retrieve and handle app status when the app has background mode enabled.

     - parameter completionHandler: Completion handler
     */
    public func fetchAppStatus(_ completionHandler: @escaping (_ result: UIBackgroundFetchResult) -> ()) {
        delegate?.bellerophonStatus(self) { status, error in
            if let status = status {
                self.handleAppStatus(status)
                if status.apiInactive() {
                    // If the kill switch or queue-it is still active we don't need to update anything
                    completionHandler(.noData)
                } else {
                    // If the kill switch and queue-it are back to normal, we can stop fetching
                    completionHandler(.newData)
                }
            } else {
                // An error occurred
                completionHandler(.failed)
            }
        }
    }
    
    public func dismissKillSwitchIfNeeded() {
        guard killSwitchWindow.isKeyWindow else {
            return
        }
        
        delegate?.bellerophonWillDisengage?(self)
        mainWindow?.makeKeyAndVisible()
        killSwitchWindow.isHidden = true
    }

    // MARK: internal Methods

    internal func handleAppStatus(_ status: BellerophonObservable) {
        if status.forceUpdate() {
            performForceUpdate()
        } else if status.apiInactive() {
            displayKillSwitch()
            startAutoChecking(status)
        } else {
            dismissKillSwitchIfNeeded()
        }
    }

    internal func stopTimer() {
        retryTimer?.invalidate()
        retryTimer = nil
    }

    internal func performForceUpdate() {
        delegate?.shouldForceUpdate()
    }

    internal func handleError(error: NSError) {
        delegate?.receivedError(error: error)
    }

    internal func displayKillSwitch() {
        guard !killSwitchWindow.isKeyWindow else {
            return
        }

        killSwitchView.frame = killSwitchWindow.bounds
        delegate?.bellerophonWillEngage?(self)
        killSwitchWindow.makeKeyAndVisible()
    }


    internal func startAutoChecking(_ status: BellerophonObservable) {
        if retryTimer == nil {
            retryTimer = BellerophonHelperMethods.timerWithStatus(status,
                                                                  target: self,
                                                                  selector: #selector(BellerophonManager.checkAppStatus))
        }
    }
}
