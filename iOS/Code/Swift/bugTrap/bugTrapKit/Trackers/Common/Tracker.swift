//
//  Trackers.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class Tracker {
	
	let type: TrackerType
	
	let details: BugDetails
    
	
	
	let keychain: Keychain<TrackerType>
	
	var Authenticated = false
	
	var hasAuthCredentials: Bool {
		return type.valid(keychain.GetStoredKeyValues())
	}
	
	
	func authenticate(data trackerData: [DataKeys : String], callback: (Result<Bool>) -> ()) {
		
		if hasAuthCredentials {
			trackerProxy.authenticate(data: trackerData, callback: { authResult in
				switch authResult {
				case let .Error(error):
					Log.error(self.type.string, error)
					self.Authenticated = false
					callback(.Error(error))
				case let .Value(result):
					if let success = result.value {
						self.Authenticated = success
						callback(.Value(Wrapped(true)))
						self.postAuthDataFetch()
					} else {
						self.Authenticated = false
						callback(.Error(NSError(domain: self.type.string, code: 401, userInfo: nil)))
					}
				}
			})
		} else {
			self.Authenticated = false
			callback(.Error(NSError(domain: type.string, code: 401, userInfo: nil)))
		}
	}
	
	func postAuthDataFetch() { }
	
    var trackerState: TrackerState!
    
    var trackerProxy: TrackerProxy!
    
    var TrackerDetails: Dictionary<Int, BugDetails.DetailType>

    init(trackerType: TrackerType) {
		self.type = trackerType
		self.details = BugDetails()
        self.keychain = Keychain<TrackerType>(service: trackerType)
        self.TrackerDetails = Dictionary<Int, BugDetails.DetailType>()// [Int : BugDetails.DetailType]()
	}
	
	
	
    func loadDataForActiveDetail(callback: (Result<Bool>) -> ()) { }
    
    func updateIssueFromSelection(selectedIndex: Int) -> Bool {
        return false
    }
    
    func createIssue(callback: (Result<Bool>) -> ()) { }
}