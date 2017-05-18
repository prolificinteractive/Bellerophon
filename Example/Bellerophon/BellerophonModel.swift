//
//  BellerophonModel.swift
//  Bellerophon
//
//  Created by Thibault Klein on 8/22/15.
//  Copyright (c) 2015 Prolific Interactive. All rights reserved.
//

import Bellerophon

typealias JSON = [String: Any]

//{
//    "apiInactive": false,
//    "forceUpdate": false,
//    "retryInterval": null,
//    "userMessage": null
//}
class BellerophonModel: BellerophonObservable {

    let isAPIInactive: Bool
    let shouldForceUpdate: Bool
    let interval: TimeInterval
    let userMessageStr: String

    required init?(json: JSON) {
        isAPIInactive = json["apiInactive"] as? Bool ?? false
        shouldForceUpdate = json["forceUpdate"] as? Bool ?? false

        guard let retryInterval = json["retryInterval"] as? TimeInterval else {
            return nil
        }

        self.interval = retryInterval

        guard let userMessage = json["userMessage"] as? String else {
            return nil
        }

        self.userMessageStr = userMessage
    }

    @objc func apiInactive() -> Bool {
        return self.isAPIInactive
    }

    @objc func forceUpdate() -> Bool {
        return self.shouldForceUpdate
    }

    @objc func retryInterval() -> TimeInterval {
        return self.interval
    }

    @objc func userMessage() -> String {
        return self.userMessageStr
    }

}
