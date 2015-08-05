//
//  TrackerService.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class TrackerService
{
    class var Shared : TrackerService {
		struct Static {
			static let instance: TrackerService = TrackerService()
		}
        return Static.instance
    }
	
	
    init() {
		for type in TrackerType.values.filter({ $0.enabled }) {
			if let credentials = trackerHasAuthCredentials(type) {
				getTrackerInstance(type)?.authenticate(data: credentials) { result in
					switch result {
					case let .Error(error):
						Log.error("TrackerService (\(type.string))", error)
					case let .Value(wrapped):
						Log.info("TrackerService (\(type.string))", "Authenticated")
					}
				}
			}
		}
    }
	
	
	// trackerType drives the state of the app 
	// (i.e. if there is a trackerType set, we know we're in a 'new Issue' flow)
	// So it's very important to set it back to .None
	private var trackerType = TrackerType.None
	
	private var trackers = [TrackerType : Tracker]()

	
	var currentTracker: Tracker? {
		return trackerType.enabled ? trackers[trackerType] ?? getTrackerInstance(trackerType) : nil
	}

	
	var hasCurrentAuthenticatedTracker: Bool {
		return trackerType != .None && currentTracker != nil && currentTracker!.Authenticated
	}
	
	
	func resetAndRemoveCurrentTracker() {
		currentTracker?.trackerState.Reset()
		trackerType = .None
	}
	
	
    func getTrackerTypesByStatus(status: TrackerStatus) -> [TrackerType] {

		var trackerTypes = [TrackerType]()
        
        for type in TrackerType.values {
            if (type.status == status) {
                trackerTypes.append(type)
            }
        }
        
        return trackerTypes
    }
	
	
	
	func getTrackerTypesByStatus() -> [TrackerStatus : [TrackerType]] {

		var trackerTypes = [TrackerStatus : [TrackerType]]()
        
        for type in TrackerType.values {
			
            let statusType = type.status
            
            if var statusGroup = trackerTypes[statusType] {
				
				statusGroup.append(type)
                trackerTypes[statusType] = statusGroup
            } else {
				
				var statusGroup = [TrackerType]()
                statusGroup.append(type)
                trackerTypes[statusType] = statusGroup
            }
        }
        
        return trackerTypes
    }
	
	
	
	func getUsernamesForEnabledTrackerTypes(enabledTrackerTypes: [TrackerType]!) -> [TrackerType : String] {
		
		var usernames = [TrackerType : String]()
		
		for type in enabledTrackerTypes {
			
			let keychain = Keychain<TrackerType>(service: type)
			
			let trackerData = keychain.GetStoredKeyValues()
			
			if let username = trackerData[DataKeys.UserName] {
			
				usernames[type] = username
			} else {
				
				usernames[type] = ""
			}
		}
		
		return usernames
	}
	
	
	
	func setCurrentTrackerType(trackerType: TrackerType) -> Bool { // returns true if the keys needed are in the keychain, otherwise false
		
		self.trackerType = trackerType
		
		return trackerType == .None || trackerHasAuthCredentials(trackerType) != nil
    }
	
	
	
	func trackerHasAuthCredentials(trackerType: TrackerType) -> [DataKeys : String]? { // returns the dictionary if the keys needed are in the keychain, otherwise nil
		
		let keychain = Keychain<TrackerType>(service: trackerType)
		
		let storedValues = keychain.GetStoredKeyValues()
		
		return trackerType.valid(storedValues) ? storedValues : nil
	}
	
	
	
    func getTrackerInstance(trackerType: TrackerType) -> Tracker? {
		
		if trackers.keys.contains(trackerType) {
			return trackers[trackerType]
		}
        
        switch trackerType {
        case .DoneDone:         trackers[trackerType] = DoneDoneTracker<String> (trackerType: trackerType)
        case .PivotalTracker:   trackers[trackerType] = PivotalTracker<String> (trackerType: trackerType)
		case .JIRA:				trackers[trackerType] = JiraTracker<String> (trackerType: trackerType)
        default:                return nil
        }
		
        return trackers[trackerType]
    }
}