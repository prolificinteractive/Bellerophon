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

    public static func screenFrame() -> CGRect {
        return CGRectMake(0.0, 0.0, screenSize().width, screenSize().height)
    }

    public static func newWindow() -> UIWindow {
        return UIWindow(frame: CGRectMake(0.0, 0.0, screenSize().width, screenSize().height))
    }

    public static func timerWithStatus(status: BellerophonStatusProtocol, target: AnyObject, selector: Selector) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(
            status.retryInterval(),
            target: target,
            selector: selector,
            userInfo: nil,
            repeats: false
        )
    }

    public static func defaultBellerophonView(message: String, image: UIImage) -> UIView {
        let view = UIView(frame: screenFrame())

        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        view.addSubview(imageView)

        let label = UILabel(frame: view.frame)
        label.font = UIFont.systemFontOfSize(30.0)
        label.textAlignment = .Center
        label.text = message
        view.addSubview(label)

        return view
    }

}