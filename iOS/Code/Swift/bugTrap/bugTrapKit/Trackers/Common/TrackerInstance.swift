//
//  TrackerBase.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class TrackerInstance<TState : TrackerState, TProxy : TrackerProxy> : Tracker {

    var State : TState?
    var Proxy : TProxy?
    
    override init(trackerType: TrackerType) {
    
        super.init(trackerType: trackerType)
        
        _ = keychain.GetStoredKeyValues()
        //create the specific state and proxy types
        self.State = TState()
		//self.Proxy = TProxy(data: trackerData)
		self.Proxy = TProxy()
        
        self.trackerState = State
        self.trackerProxy = Proxy
        
        TrackerDetails = trackerState.TrackerDetails
    }
}