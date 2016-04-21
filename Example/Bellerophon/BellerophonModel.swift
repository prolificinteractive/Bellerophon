//
//  BellerophonModel.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Foundation
import ObjectMapper
import Bellerophon

//{
//    "apiInactive": false,
//    "forceUpdate": false,
//    "retryInterval": null,
//    "userMessage": null
//}
class 💩: Mappable, BellerophonObservable {

    var isAPIInactive: Bool = false
    var shouldForceUpdate: Bool = false
    var interval: NSTimeInterval = 0
    var userMessageStr: String = ""

    required init?(_ map: Map) {
        isAPIInactive <- map["apiInactive"]
        shouldForceUpdate <- map["forceUpdate"]
        interval <- map["retryInterval"]
        userMessageStr <- map["userMessage"]
    }

    func mapping(map: Map) {
        isAPIInactive <- map["apiInactive"]
        shouldForceUpdate <- map["forceUpdate"]
        interval <- map["retryInterval"]
        userMessageStr <- map["userMessage"]
    }

    @objc func apiInactive() -> Bool {
        return self.isAPIInactive
    }

    @objc func forceUpdate() -> Bool {
        return self.shouldForceUpdate
    }

    @objc func retryInterval() -> NSTimeInterval {
        return self.interval
    }

    @objc func userMessage() -> String {
        return self.userMessageStr
    }

}