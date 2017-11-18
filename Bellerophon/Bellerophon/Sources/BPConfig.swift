//
//  BellerophonConfig.swift
//  Bellerophon
//
//  Created by Satinder Singh on 11/17/17.
//

import UIKit

/// Configuration for Bellerophon
public struct BellerophonConfig {

    /// The root window
    public var window: UIWindow

    /// View to be shown when the kill switch is turned on. Must be set by the application using Bellerophon
    public var killSwitchView: UIView?

    /// View to be shown when force updated is required. Must be set by the application using Bellerophon
    public var forceUpdateView: UIView?

    /// Bellerophon manager delegate
    public weak var delegate: BellerophonManagerDelegate?

    /// Initalizer for `BellerophonManager`
    /// - Note: It is possible to supply no views and still handle force update and killswitch by utilzing methods found in
    ///         `BellerophonManagerDelegate` via `shouldForceUpdate` and / or `shouldKillSwitch`
    /// - Parameters:
    ///   - window: Root UIWindow
    ///   - killSwitchView: UIView to display when kill switch is triggered. If nil, no view will be shown for kill switch event.
    ///   - forceUpdateView: UIView to display when force update is triggered. If nil, no view will be shown for force update event.
    ///   - delegate: `BellerophonManagerDelegate` with optional callbacks.
    public init(window: UIWindow, killSwitchView: UIView?, forceUpdateView: UIView?, delegate: BellerophonManagerDelegate?) {
        self.window = window
        self.killSwitchView = killSwitchView
        self.forceUpdateView = forceUpdateView
        self.delegate = delegate
    }

    /// Determines if the config contains at least one view
    ///
    /// - Returns: True if the config contains at least one view
    internal func containsView() -> Bool {
        return [killSwitchView, forceUpdateView].flatMap ({ $0 }).count > 0
    }

    /// Returns list of all views who are not optional
    ///
    /// - Returns: List of UIViews that exist within config
    internal func allViews() -> [UIView] {
        return [killSwitchView, forceUpdateView].flatMap ({ $0 })
    }

}
