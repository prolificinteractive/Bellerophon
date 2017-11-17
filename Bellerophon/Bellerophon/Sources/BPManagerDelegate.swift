//
//  BPManagerProtocol.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

/// The Bellerophon manager delegate.
@objc public protocol BellerophonManagerDelegate {

    /**
     Provide Bellerophon's current status according to the status object received

     - parameter manager:    The Bellerophon manager.
     - parameter completion: The completion block.
     */
    func bellerophonStatus(_ manager: BellerophonManager,
                           completion: @escaping (_ status: BellerophonObservable?,
        _ error: NSError?) -> ())

    /**
     The app is notified that a force update should occur. An alert should be displayed to redirect to the App Store.
     */
    func shouldForceUpdate()

    /// The app is notified when a error was received.
    ///
    /// - Parameter error: The error received.
    func receivedError(error: NSError)

    @objc optional
    /**
     Indicates that Bellerophon is about to appear on the screen.

     - parameter manager: The Bellerophon manager.
     - parameter enableForceUpdate: Boolean to determine if force update should be shown
     */
    func bellerophonWillEngage(_ manager: BellerophonManager, enableForceUpdate: Bool)

    @objc optional
    /**
     Indicates that Bellerophon is about to disappear from the screen.

     - parameter manager: The Bellerophon manager.
     */
    func bellerophonWillDisengage(_ manager: BellerophonManager)

}

