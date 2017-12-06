//
//  MockBPManager.swift
//  Bellerophon
//
//  Created by Shiyuan Jiang on 4/27/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

@testable import Bellerophon

class MockBPManager: BellerophonManager {

    override var isDisplaying: Bool {
        return true
    }

    var displayKillSwitchIsCalled: Bool!
    var displayForceUpdateIsCalled: Bool!
    var startAutoCheckingIsCalled: Bool!
    var dismissKillSwitchIfNeededIsCalled: Bool!

    var displayForceUpdateFunctionIsCalled: Bool!
    var displayKillSwitchFunctionIsCalled: Bool!
    var updateDisplayIsCalled: Bool!

    override func displayWindow(for event: BellerophonEvent) {
        switch event {
        case .killSwitch:
            displayKillSwitchIsCalled = true
            displayForceUpdateIsCalled = false
        case .forceUpdate:
            displayForceUpdateIsCalled = true
            displayKillSwitchIsCalled = false
        }
    }

    override func updateDisplay(_ status: BellerophonObservable) {
        updateDisplayIsCalled = true
        super.updateDisplay(status)
    }

    override func displayForceUpdate() {
        displayForceUpdateFunctionIsCalled = true
        super.displayForceUpdate()
    }

    override func displayKillSwitch() {
        displayKillSwitchFunctionIsCalled = true
        super.displayKillSwitch()
    }
    
    override func startAutoChecking(_ status: BellerophonObservable) {
        startAutoCheckingIsCalled = true
    }
    
    override func dismissKillSwitchIfNeeded() {
        dismissKillSwitchIfNeededIsCalled = true
        super.dismissKillSwitchIfNeeded()
    }
}
