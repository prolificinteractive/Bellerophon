//
//  BPManagerProtocol.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation

@objc public protocol BellerophonManagerProtocol {

    /**
    Provide Bellerophon's current status according to the status object received

    - parameter manager:    The Bellerophon manager.
    - parameter completion: The completion block.
    */
    func bellerophonStatus(manager: BellerophonManager, completion: (status: BellerophonStatusProtocol?, error: NSError?) -> ())

    /**
    The force update is active, the app should check the app's version and force to update if needed. An alert should be displayed to redirect to the App Store.

    - parameter manager: The Bellerophon manager.
    */
    func checkVersion(manager: BellerophonManager)

    optional
    /**
    Indicates that Bellerophon is about to appear on the screen.

    - parameter manager: The Bellerophon manager.
    */
    func bellerophonWillEngage(manager: BellerophonManager)

    optional
    /**
    Indicates that Bellerophon is about to disappear from the screen.

    - parameter manager: The Bellerophon manager.
    */
    func bellerophonWillDisengage(manager: BellerophonManager)

}