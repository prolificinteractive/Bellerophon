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

    lazy var mockManager = MockBPManager(config: BellerophonConfig(window: UIWindow(),
                                                                            killSwitchView: UIView(),
                                                                            forceUpdateView: nil,
                                                                            delegate: self))

    enum ResponseCases: Int {
        case KillSwitchOffForceUpdateOff = 0b00
        case KillSwitchOffForceUpdateOn = 0b01
        case KillSwitchOnForceUpdateOff = 0b10
        case KillSwitchOnForceUpdateOn = 0b11
    }

    var responseArray: [BellerophonResponse]!

    var shouldForceUpdateIsCalled: Bool!
    var shouldKillSwitchIsCalled: Bool!

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


        shouldForceUpdateIsCalled = false
        shouldKillSwitchIsCalled = false
        
        mockManager.displayKillSwitchIsCalled = false
        mockManager.dismissKillSwitchIfNeededIsCalled = false
        mockManager.startAutoCheckingIsCalled = false
    }
    
    override func tearDown() {

        super.tearDown()
    }

    func testConfigForceUpdateInitalization() {
        let window = UIWindow()
        let forceUpdateView = UIView()
        let testForceUpdateManager = MockBPManager(config: BellerophonConfig(window: window,
                                                                  killSwitchView: nil,
                                                                  forceUpdateView: forceUpdateView,
                                                                  delegate: self))
        XCTAssertEqual(testForceUpdateManager.config.window, window)
        XCTAssertNil(testForceUpdateManager.config.killSwitchView)
        XCTAssertEqual(testForceUpdateManager.config.forceUpdateView, forceUpdateView)
        XCTAssertEqual(testForceUpdateManager.config.allViews().count, 1)
        XCTAssertFalse(shouldKillSwitchIsCalled)
    }

    func testConfigNilInitalization() {
        let window = UIWindow()
        let testForceUpdateManager = MockBPManager(config: BellerophonConfig(window: window,
                                                                             killSwitchView: nil,
                                                                             forceUpdateView: nil,
                                                                             delegate: self))
        XCTAssertEqual(testForceUpdateManager.config.window, window)
        XCTAssertNil(testForceUpdateManager.config.killSwitchView)
        XCTAssertNil(testForceUpdateManager.config.forceUpdateView)
        XCTAssertEqual(testForceUpdateManager.config.allViews().count, 0)
        XCTAssertFalse(shouldKillSwitchIsCalled)
    }

    func test_checkAppStatus_withResponseOfKillSwitchOffForceUpdateOff() {
        // given
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        
        // when
        mockManager.checkAppStatus()

        // then
        XCTAssertFalse(mockManager.displayKillSwitchIsCalled, "Internal func displayKillSwitch should not be called")
        XCTAssertFalse(mockManager.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "shouldForceUpdate should not be called")
        XCTAssertFalse(shouldForceUpdateIsCalled, "shouldForceUpdate should not be called")
        XCTAssertFalse(shouldKillSwitchIsCalled)
    }

    func test_checkAppStatus_withResponseOfKillSwitchOffForceUpdateOn() {
        // given
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOn.rawValue
        
        // when
        mockManager.checkAppStatus()

        // then
        XCTAssertFalse(mockManager.displayKillSwitchIsCalled, "Internal func displayWindowIfPossible for killswitch should not be called")
        XCTAssertTrue(mockManager.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
        XCTAssertFalse(shouldKillSwitchIsCalled)
    }

    func test_checkAppStatus_withResponseOfKillSwitchOnForceUpdateOff() {
        // given
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        
        // when
        mockManager.checkAppStatus()

        // then
        XCTAssertTrue(mockManager.displayKillSwitchIsCalled, "Internal func displayWindowIfPossible for killswitch should be called")
        XCTAssertTrue(mockManager.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should be called")
        XCTAssertFalse(mockManager.displayForceUpdateIsCalled, "Internal func displayWindowIfPossible for forceupdate should not be called")
        XCTAssertTrue(shouldKillSwitchIsCalled)
    }

    func test_checkAppStatus_withResponseOfKillSwitchOnForceUpdateOn() {
        // given
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOn.rawValue
        
        // when
        mockManager.checkAppStatus()

        // then
        XCTAssertFalse(mockManager.displayKillSwitchIsCalled, "Internal func displayWindowIfPossible for killswitch should not be called")
        XCTAssertTrue(mockManager.startAutoCheckingIsCalled, "Internal func startAutoCheckingIsCalled should not be called")
    }

    func test_dismissKillSwitchView() {
        // given
        // Turn on kill switch first
        currentIdx = ResponseCases.KillSwitchOnForceUpdateOff.rawValue
        mockManager.checkAppStatus()
        
        // when
        // Turn off kill switch after
        currentIdx = ResponseCases.KillSwitchOffForceUpdateOff.rawValue
        mockManager.checkAppStatus()

        // then
        XCTAssertTrue(mockManager.dismissKillSwitchIfNeededIsCalled, "Internal func dismissKillSwitchIfNeededIsCalled should be called")
        XCTAssertTrue(shouldKillSwitchIsCalled)
    }

}

extension BellerophonTests: BellerophonManagerDelegate {

    func bellerophonStatus(_ manager: BellerophonManager,
                           completion: @escaping (_ status: BellerophonObservable?, _ error: Error?) -> ()) {
        completion(responseArray[currentIdx], nil)
    }

    func shouldForceUpdate() {
        shouldForceUpdateIsCalled = true
    }

    func receivedError(error: Error) {

    }

    func shouldKillSwitch() {
        shouldKillSwitchIsCalled = true
    }
}
