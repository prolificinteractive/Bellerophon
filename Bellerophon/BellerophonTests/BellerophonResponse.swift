//
//  BellerophonResponse.swift
//  Bellerophon
//
//  Created by Shiyuan Jiang on 4/27/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

@testable import Bellerophon

@objc public class BellerophonResponse: NSObject, BellerophonObservable {
    
    init(isAPIInactive: Bool, shouldForceUpdate: Bool, interval: TimeInterval, userMessageStr: String) {
        self.isAPIInactive = isAPIInactive
        self.shouldForceUpdate = shouldForceUpdate
        self.interval = interval
        self.userMessageStr = userMessageStr
    }
    
    var isAPIInactive: Bool = false
    var shouldForceUpdate: Bool = false
    var interval: TimeInterval = 0
    var userMessageStr: String = ""
    
    public func apiInactive() -> Bool {
        return isAPIInactive
    }
    
    public func forceUpdate() -> Bool {
        return shouldForceUpdate
    }
    
    public func retryInterval() -> TimeInterval {
        return interval
    }
    
    public func userMessage() -> String {
        return userMessageStr
    }
    
    public func setUserMessage(_ message: String) {
        
    }
}
