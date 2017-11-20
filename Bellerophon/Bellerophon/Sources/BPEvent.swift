//
//  BPTypes.swift
//  Bellerophon
//
//  Created by Satinder Singh on 11/17/17.
//

/// Different types of events for Bellerophon
public enum BellerophonEvent {

    /// Kill Switch
    case killSwitch(view: UIView)

    /// Force Update
    case forceUpdate(view: UIView)

    /// UIView associated with event case
    var view: UIView {
        switch self {
        case .forceUpdate(view: let forceUpdateView):
            return forceUpdateView
        case .killSwitch(view: let killSwitchView):
            return killSwitchView
        }
    }

}
