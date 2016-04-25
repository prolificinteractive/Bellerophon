//
//  BellerophonTests.swift
//  BellerophonTests
//
//  Created by Thibault Klein on 1/8/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import XCTest
@testable import Bellerophon

class BellerophonTests: XCTestCase {

    enum ResponseCases: Int {
        case KillSwitchOffForceUpdateOff = 0b00
        case KillSwitchOffForceUpdateOn = 0b01
        case KillSwitchOnForceUpdateOff = 0b10
        case KillSwitchOnForceUpdateOn = 0b11
    }

    var responseArray: [BellerophonResponse]!

    var willEngageIsCalled: Bool!
    var willDisengageIsCalled: Bool!
    var shouldForceUpdateIsCalled: Bool!

    var currentIdx: Int = 0

    override func setUp() {
        super.setUp()

        responseArray = [BellerophonResponse]()

        responseArray.append(BellerophonResponse(isAPIInactive: false, shouldForceUpdate: false,
            interval: Double(ResponseCases.KillSwitchOffForceUpdateOff.rawValue), userMessageStr: "Both killSwitch and forceUpdate are turned off"))
        responseArray.append(BellerophonResponse(isAPIInactive: false, shouldForceUpdate: true,
            interval: Double(ResponseCases.KillSwitchOffForceUpdateOn.rawValue), userMessageStr: "Only forceUpdate is turned on"))
        responseArray.append(BellerophonResponse(isAPIInactive: true, shouldForceUpdate: false,
            interval: Double(ResponseCases.KillSwitchOnForceUpdateOff.rawValue), userMessageStr: "Only killSwitch is turned on"))
        responseArray.append(BellerophonResponse(isAPIInactive: true, shouldForceUpdate: true,
            interval: Double(ResponseCases.KillSwitchOnForceUpdateOn.rawValue), userMessageStr: "Both killSwitch and forceUpdate are turned on"))

        BellerophonManager.sharedInstance.delegate = self
        BellerophonManager.sharedInstance.killSwitchView = UIView()

        willEngageIsCalled = false
        willDisengageIsCalled = false
        shouldForceUpdateIsCalled = false
    }
    
    override func tearDown() {
        BellerophonManager.sharedInstance.delegate = nil

        super.tearDown()
    }

    func testResponseKillSwitchOffForceUpdateOff() {
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()

        XCTAssertFalse(willEngageIsCalled, "The delegate method bellerophonWillEngage should not be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "shouldForceUpdate should not be called")
    }

    func testResponseKillSwitchOffForceUpdateOn() {
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOn.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()

        XCTAssertFalse(willEngageIsCalled, "The delegate method bellerophonWillEngage should not be called")
        XCTAssertTrue(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should be called")
    }

    func testResponseKillSwitchOnForceUpdateOff() {
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()

        XCTAssertTrue(willEngageIsCalled, "The delegate method bellerophonWillEngage should be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should not be called")
    }

    func testResponseKillSwitchOnForceUpdateOn() {
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOn.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()

        XCTAssertTrue(willEngageIsCalled, "The delegate method bellerophonWillEngage should be called")
        // Notice that if both of killSwitch and forceUpdate are on, only killSwitch is called
        XCTAssertFalse(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should not be called")
    }

    func testTurningOffKillSwitch() {
        // Turn on kill switch first
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()
        // Turn off kill switch after
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        BellerophonManager.sharedInstance.checkAppStatus()

        XCTAssertTrue(BellerophonManager.sharedInstance.killSwitchWindow.hidden, "Kill switch view should not be displayed")
    }

}

extension BellerophonTests: BellerophonManagerDelegate {

    func bellerophonStatus(manager: BellerophonManager, completion: (status: BellerophonObservable?, error: NSError?) -> ()) {
        completion(status: responseArray[currentIdx], error: nil)
    }

    func shouldForceUpdate() {
        shouldForceUpdateIsCalled = true
    }

    func bellerophonWillEngage(manager: BellerophonManager) {
        willEngageIsCalled = true
    }

    func bellerophonWillDisengage(manager: BellerophonManager) {
        willDisengageIsCalled = true
    }
}

class BellerophonResponse: BellerophonObservable {

    init(isAPIInactive: Bool, shouldForceUpdate: Bool, interval: NSTimeInterval, userMessageStr: String) {
        self.isAPIInactive = isAPIInactive
        self.shouldForceUpdate = shouldForceUpdate
        self.interval = interval
        self.userMessageStr = userMessageStr
    }

    var isAPIInactive: Bool = false
    var shouldForceUpdate: Bool = false
    var interval: NSTimeInterval = 0
    var userMessageStr: String = ""

    @objc func apiInactive() -> Bool {
        return isAPIInactive
    }

    @objc func forceUpdate() -> Bool {
        return shouldForceUpdate
    }

    @objc func retryInterval() -> NSTimeInterval {
        return interval
    }

    @objc func userMessage() -> String {
        return userMessageStr
    }
}
