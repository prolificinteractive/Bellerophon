//
//  MockBPManager.swift
//  Bellerophon
//
//  Created by Shiyuan Jiang on 4/27/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

@testable import Bellerophon

class MockBPManager: BellerophonManager {
    static let mockSharedInstance = MockBPManager(window: UIWindow())
    
    var displayKillSwitchIsCalled: Bool!
    var startAutoCheckingIsCalled: Bool!
    var dismissKillSwitchIfNeededIsCalled: Bool!
    
    override func displayKillSwitch(enableForceUpdate: Bool) {
        displayKillSwitchIsCalled = true
    }
    
    override func startAutoChecking(_ status: BellerophonObservable) {
        startAutoCheckingIsCalled = true
    }
    
    override func dismissKillSwitchIfNeeded() {
        dismissKillSwitchIfNeededIsCalled = true
    }
}
