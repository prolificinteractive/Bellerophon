//
//  BPHelperMethods.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import UIKit

/// The Bellerophon helper methods.
public struct BellerophonHelperMethods {

    // MARK: Helper Methods

    public static func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }

    public static func newWindow() -> UIWindow {
        return UIWindow(frame: CGRect(x: 0.0,
                                      y: 0.0,
                                      width: screenSize().width,
                                      height: screenSize().height))
    }

    public static func timerWithStatus(_ status: BellerophonObservable,
                                       target: AnyObject,
                                       selector: Selector) -> Timer {
        return Timer.scheduledTimer(
            timeInterval: status.retryInterval(),
            target: target,
            selector: selector,
            userInfo: nil,
            repeats: false
        )
    }
}
