//
//  BellerophonResponse.swift
//  Bellerophon
//
//  Created by Shiyuan Jiang on 4/27/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

@testable import Bellerophon

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
