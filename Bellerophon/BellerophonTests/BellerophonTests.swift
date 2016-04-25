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
    
    var statusArray: [BellerophonModel]!

    var willEngageIsCalled: Bool!
    var willDisengageIsCalled: Bool!
    var shouldForceUpdateIsCalled: Bool!

    var currentIdx: Int = 0

    override func setUp() {
        super.setUp()

        statusArray = [BellerophonModel]()
        statusArray.append(BellerophonModel(isAPIInactive: false, shouldForceUpdate: false, interval: 0b00, userMessageStr: "Both killSwitch and forceUpdate are turned off"))
        statusArray.append(BellerophonModel(isAPIInactive: false, shouldForceUpdate: true, interval: 0b01, userMessageStr: "Only forceUpdate is turned on"))
        statusArray.append(BellerophonModel(isAPIInactive: true, shouldForceUpdate: false, interval: 0b10, userMessageStr: "Only killSwitch is turned on"))
        statusArray.append(BellerophonModel(isAPIInactive: true, shouldForceUpdate: true, interval: 0b11, userMessageStr: "Both killSwitch and forceUpdate are turned on"))

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
    
    func testCheckAppStatus_FF() {
        currentIdx = 0b00
        BellerophonManager.sharedInstance.checkAppStatus()
    }

    func testCheckAppStatus_FT() {
        currentIdx = 0b01
        BellerophonManager.sharedInstance.checkAppStatus()
    }

    func testCheckAppStatus_TF() {
        currentIdx = 0b10
        BellerophonManager.sharedInstance.checkAppStatus()
    }
    
    func testCheckAppStatus_TT() {
        currentIdx = 0b11
        BellerophonManager.sharedInstance.checkAppStatus()
    }

}

extension BellerophonTests: BellerophonManagerDelegate {

    func bellerophonStatus(manager: BellerophonManager, completion: (status: BellerophonObservable?, error: NSError?) -> ()) {

        switch currentIdx {
        case 0b00:
            completion(status: statusArray[0b00], error: nil)
            XCTAssertEqual(BellerophonManager.sharedInstance.killSwitchWindow.hidden, true)
        case 0b01:
            completion(status: statusArray[0b01], error: nil)
            XCTAssertEqual(shouldForceUpdateIsCalled, true)
        case 0b10:
            completion(status: statusArray[0b10], error: nil)
            XCTAssertEqual(willEngageIsCalled, true)
        case 0b11:
            completion(status: statusArray[0b11], error: nil)
            XCTAssertEqual(willEngageIsCalled, true)
            XCTAssertEqual(shouldForceUpdateIsCalled, false)
        default:
            break
        }
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

class BellerophonModel: BellerophonObservable {

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
