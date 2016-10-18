//
//  BPHelperMethods.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

/// Bellerophon helper methods.
public struct BellerophonHelperMethods {

    // MARK: Helper Methods

    /// Returns the screen size.
    ///
    /// - returns: The screen size.
    public static func screenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }

    /// Returns a new window with the current screen size.
    ///
    /// - returns: The new window.
    public static func newWindow() -> UIWindow {
        return UIWindow(frame: CGRectMake(0.0, 0.0, screenSize().width, screenSize().height))
    }

    /// Returns a timer with the Bellerophon retry interval.
    ///
    /// - parameter status:   The Bellerophon current status.
    /// - parameter target:   The target for the timer.
    /// - parameter selector: The selector for the timer.
    ///
    /// - returns: The timer.
    public static func timerWithStatus(status: BellerophonObservable, target: AnyObject, selector: Selector) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(
            status.retryInterval(),
            target: target,
            selector: selector,
            userInfo: nil,
            repeats: false
        )
    }
}
