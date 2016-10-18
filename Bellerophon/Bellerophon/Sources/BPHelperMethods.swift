//
//  BPHelperMethods.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation
import UIKit

public struct BellerophonHelperMethods {

    // MARK: Helper Methods
    public static func screenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }

    public static func newWindow() -> UIWindow {
        return UIWindow(frame: CGRectMake(0.0, 0.0, screenSize().width, screenSize().height))
    }

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
