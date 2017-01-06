//
//  BPStatusProtocol.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation

@objc public protocol BellerophonObservable {

    /**
    Is the API is active or inactive?

    - returns: YES if the API is inactive. A specific view should be presented. NO if not.
    */
    func apiInactive() -> Bool

    /**
    Is the app should force the user to update?

    - returns: YES if the API should force the user to update. An alert redirecting to the App Store should be presented. NO if not.
    */
    func forceUpdate() -> Bool

    /**
    Indicates the retry interval for the app to hit the status endpoint.

    - returns: A time interval.
    */
    func retryInterval() -> TimeInterval

    /**
    Indicates the message to display to the custom view presented when the API is inactive.

    - returns: The user message to display.
    */
    func userMessage() -> String

    @objc optional
    /**
    Set the user message to your custom view.

    - parameter message: The message to display.
    */
    func setUserMessage(_ message: String)

    /**
     Whether the kill switch view should be a priority.

     - returns: Whether the kill switch view has priority. By default this value is false.
     */
    func killSwitchPriority() -> Bool

}
