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
        
        MockBPManager.mockSharedInstance.delegate = self
        MockBPManager.mockSharedInstance.killSwitchView = UIView()

        shouldForceUpdateIsCalled = false
        
        MockBPManager.mockSharedInstance.displayKillSwitchIsCalled = false
        MockBPManager.mockSharedInstance.dismissKillSwitchIfNeededIsCalled = false
        MockBPManager.mockSharedInstance.startAutoCheckingIsCalled = false
    }
    
    override func tearDown() {
        MockBPManager.mockSharedInstance.delegate = nil

        super.tearDown()
    }

    func test_checkAppStatus_withResponseOfKillSwitchOffForceUpdateOff() {
        // given
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        
        // when
        MockBPManager.mockSharedInstance.checkAppStatus()

        // then
        XCTAssertFalse(MockBPManager.mockSharedInstance.displayKillSwitchIsCalled, "Internal func displayKillSwitch should not be called")
        XCTAssertFalse(MockBPManager.mockSharedInstance.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "shouldForceUpdate should not be called")
    }

    func test_checkAppStatus_withResponseOfKillSwitchOffForceUpdateOn() {
        // given
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOn.rawValue
        
        // when
        MockBPManager.mockSharedInstance.checkAppStatus()

        // then
        XCTAssertFalse(MockBPManager.mockSharedInstance.displayKillSwitchIsCalled, "Internal func displayKillSwitch should not be called")
        XCTAssertFalse(MockBPManager.mockSharedInstance.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
        XCTAssertTrue(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should be called")
    }

    func test_checkAppStatus_withResponseOfKillSwitchOnForceUpdateOff() {
        // given
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        
        // when
        MockBPManager.mockSharedInstance.checkAppStatus()

        // then
        XCTAssertTrue(MockBPManager.mockSharedInstance.displayKillSwitchIsCalled, "Internal func displayKillSwitch should be called")
        XCTAssertTrue(MockBPManager.mockSharedInstance.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should not be called")
    }

    func test_checkAppStatus_withResponseOfKillSwitchOnForceUpdateOn() {
        // given
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOn.rawValue
        
        // when
        MockBPManager.mockSharedInstance.checkAppStatus()

        // then
        XCTAssertFalse(MockBPManager.mockSharedInstance.displayKillSwitchIsCalled, "Internal func displayKillSwitch should not be called")
        XCTAssertFalse(MockBPManager.mockSharedInstance.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
        // Notice that if both of killSwitch and forceUpdate are on, only forceUpdate is called
        XCTAssertTrue(shouldForceUpdateIsCalled, "The delegate method shouldForceUpdate should be called")
    }

    func test_dismissKillSwitchView() {
        // given
        // Turn on kill switch first
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        MockBPManager.mockSharedInstance.checkAppStatus()
        
        // when
        // Turn off kill switch after
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        MockBPManager.mockSharedInstance.checkAppStatus()

        // then
        XCTAssertTrue(MockBPManager.mockSharedInstance.dismissKillSwitchIfNeededIsCalled, "Internal func dismissKillSwitchIfNeededIsCalled should be called")
    }

}

extension BellerophonTests: BellerophonManagerDelegate {

    func bellerophonStatus(manager: BellerophonManager, completion: (status: BellerophonObservable?, error: NSError?) -> ()) {
        completion(status: responseArray[currentIdx], error: nil)
    }

    func shouldForceUpdate() {
        shouldForceUpdateIsCalled = true
    }

}
