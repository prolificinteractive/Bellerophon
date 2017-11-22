//
//  BPManagerProtocol.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

/// The Bellerophon manager delegate.
public protocol BellerophonManagerDelegate: class {

    // MARK: - Required
    /**
     Provide Bellerophon's current status according to the status object received

     - parameter manager:    The Bellerophon manager.
     - parameter completion: The completion block.
     */
    func bellerophonStatus(_ manager: BellerophonManager, completion: @escaping (_ status: BellerophonObservable?, _ error: Error?) -> ())


    // MARK: - Optional
    /// The app is notified when a error was received.
    ///
    /// - Parameter error: The error received.
    func receivedError(error: Error)

    /**
     The app is notified that a force update should occur. An alert should be displayed to redirect to the App Store.
     */
    func shouldForceUpdate()

    /**
     The app is notified that a kill switch should occur.
     */
    func shouldKillSwitch()

    /**
     Indicates that Bellerophon is about to appear on the screen.

     - parameter manager: The Bellerophon manager.
     - parameter event: BellerophonEvent that will engage
     */
    func bellerophonWillEngage(_ manager: BellerophonManager, event: BellerophonEvent)

    /**
     Indicates that Bellerophon is about to disappear from the screen.

     - parameter manager: The Bellerophon manager.
     - parameter event: BellerophonEvent that will disengage
     */
    func bellerophonWillDisengage(_ manager: BellerophonManager, event: BellerophonEvent)
    
}

public extension BellerophonManagerDelegate {
    func receivedError(error: Error) { }
    func shouldForceUpdate() { }
    func shouldKillSwitch() { }
    func bellerophonWillEngage(_ manager: BellerophonManager, event: BellerophonEvent) { }
    func bellerophonWillDisengage(_ manager: BellerophonManager, event: BellerophonEvent) { }
}
