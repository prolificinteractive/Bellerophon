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
    
    /// Determines if the killswitch or force update view is presenting.
    public var isDisplaying: Bool {
        return bellerophonWindow.isKeyWindow
    }
    
    // MARK: - Initializers

    /// The default initializer.
    ///
    /// - Parameter config: BellerophonConfig
    public init(config: BellerophonConfig) {
        self.config = config
        super.init()
        mainWindow = config.window

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopTimer),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: internal properties
    /// The kill switch window.
    internal lazy var bellerophonWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        let rootViewController = UIViewController()
        let viewList = [self.config.killSwitchView, self.config.forceUpdateView]
        viewList.flatMap ({ $0 }).forEach {
            $0.isHidden = true
            rootViewController.view.addSubview($0)
        }
        window.rootViewController = rootViewController
        return window
    }()

    private weak var mainWindow: UIWindow?
    internal let config: BellerophonConfig
    internal var currentEvent: BellerophonEvent?

    internal var requestPending = false
    internal var retryTimer: Timer?

    // MARK: Public Methods

    /**
     Retrieves and handles the app status from the AMS endpoint
     */
    @objc public func checkAppStatus() {
        guard !requestPending else {
            return
        }

        requestPending = true
        stopTimer()

        config.delegate?.bellerophonStatus(self) { [weak self] status, error in
            self?.requestPending = false
            if let status = status {
                self?.updateDisplay(status)
            } else if let error = error {
                self?.handleError(error: error)
            } else {
                self?.dismissKillSwitchIfNeeded()
            }
        }
    }

    /// Updates the display with the given status.
    ///
    /// - Parameter status: Kill switch status to check if the kill switch view should be displayed.
    @objc public func updateDisplay(_ status: BellerophonObservable) {
        if status.forceUpdate() {
            displayForceUpdate()
        } else if status.apiInactive() {
            displayKillSwitch()
        } else {
            dismissKillSwitchIfNeeded()
        }

        if (status.forceUpdate() || status.apiInactive()) {
            startAutoChecking(status)
        }
    }

    /// Dismisses the kill switch window.
    @objc public func dismissKillSwitchIfNeeded() {
        guard isDisplaying, let currentEvent = currentEvent else {
            return
        }
        config.delegate?.bellerophonWillDisengage(self, event: currentEvent)
        config.allViews().forEach { $0.isHidden = true }
        mainWindow?.makeKeyAndVisible()
        bellerophonWindow.isHidden = true
    }
    
    /**
     Use this function to retrieve and handle app status when the app has background mode enabled.

     - parameter completionHandler: Completion handler
     */
    public func fetchAppStatus(_ completionHandler: @escaping (_ result: UIBackgroundFetchResult) -> ()) {
        config.delegate?.bellerophonStatus(self) { status, error in
            if let status = status {
                self.updateDisplay(status)
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

// MARK: Internal Methods

    @objc internal func stopTimer() {
        retryTimer?.invalidate()
        retryTimer = nil
    }

    internal func handleError(error: Error) {
        config.delegate?.receivedError(error: error)
    }

    internal func displayForceUpdate() {
        if let forceUpdateView = config.forceUpdateView {
            displayWindow(for: .forceUpdate(view: forceUpdateView))
        }
        config.delegate?.shouldForceUpdate()
    }

    internal func displayKillSwitch() {
        if let killSwitchView = config.killSwitchView {
            displayWindow(for: .killSwitch(view: killSwitchView))
        }
        config.delegate?.shouldKillSwitch()
    }

    internal func displayWindow(for event: BellerophonEvent) {
        let view = event.view
        currentEvent = event
        view.frame = bellerophonWindow.bounds
        config.allViews().forEach { $0.isHidden = true }
        view.isHidden = false
        config.delegate?.bellerophonWillEngage(self, event: event)
        bellerophonWindow.makeKeyAndVisible()
    }

    internal func startAutoChecking(_ status: BellerophonObservable) {
        if retryTimer == nil {
            retryTimer =  Timer.scheduledTimer(timeInterval: status.retryInterval(),
                                               target: self,
                                               selector: #selector(checkAppStatus),
                                               userInfo: nil,
                                               repeats: false)
        }
    }

}
