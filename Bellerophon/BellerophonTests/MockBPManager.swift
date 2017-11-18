//
//  MockBPManager.swift
//  Bellerophon
//
//  Created by Shiyuan Jiang on 4/27/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

@testable import Bellerophon

class MockBPManager: BellerophonManager {
    
    var displayKillSwitchIsCalled: Bool!
    var displayForceUpdateIsCalled: Bool!
    var startAutoCheckingIsCalled: Bool!
    var dismissKillSwitchIfNeededIsCalled: Bool!
    
    override func displayWindowIfPossible(for event: BellerophonEvent) {
        switch event {
        case .killSwitch:
            displayKillSwitchIsCalled = true
            displayForceUpdateIsCalled = false
        case .forceUpdate:
            displayForceUpdateIsCalled = true
            displayKillSwitchIsCalled = false
        }
    }
    
    override func startAutoChecking(_ status: BellerophonObservable) {
        startAutoCheckingIsCalled = true
    }
    
    override func dismissKillSwitchIfNeeded() {
        dismissKillSwitchIfNeededIsCalled = true
    }
}
