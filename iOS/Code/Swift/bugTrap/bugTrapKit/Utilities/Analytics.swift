//
//  Analytics.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/20/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

public class Analytics {
	
	public class var Shared : Analytics {
		
		struct Static {
			static let instance: Analytics = Analytics()
		}
		
		return Static.instance
	}
	
	init() {
		GAI.sharedInstance().trackUncaughtExceptions = true
		GAI.sharedInstance().dispatchInterval = 30
		GAI.sharedInstance().logger.logLevel = .Error // .Warning // .Info // .Verbose // .None
		GAI.sharedInstance().trackerWithTrackingId(GAIKeys.trackingID)
	}
	
	public var inActionExtension = false
	
	private var contextSent = false
	
	private var context: String {
		return inActionExtension ? "Action Extension" : "Application"
	}
	
	private var tracker: GAITracker {
		return GAI.sharedInstance().defaultTracker
	}
	
	private var screenNameCache = ""
	
	public func screenView(screenName: String) {
		
		screenNameCache = inActionExtension ? "Ext: " + screenName : screenName
		
		tracker.set(kGAIScreenName, value: screenNameCache)
		if contextSent {
//			tracker.send(GAIDictionaryBuilder.createScreenView().build())
		} else {
			Log.info("Analytics", "sendingSession -- " + context)
//			tracker.send(GAIDictionaryBuilder.createScreenView().set(context, forKey: GAIFields.customDimensionForIndex(1)).build())
			contextSent = true
		}
	}
	

	public func issueSent(trackerIndex: UInt, trackerName: String) {
		tracker.set(GAIFields.customMetricForIndex(trackerIndex), value: "1")
//		tracker.send(GAIDictionaryBuilder.createEventWithCategory(GAIEventCategory.Tracker.rawValue, action: GAIEventAction.SubmitIssue.rawValue, label: trackerName, value: 1).build())
	}
	
	
	public func trackerLogin(trackerName: String) {
//		tracker.send(GAIDictionaryBuilder.createEventWithCategory(GAIEventCategory.Tracker.rawValue, action: GAIEventAction.Login.rawValue, label: trackerName, value: 1).build())
	}
	
	
	public func activity(activityType: String, completed: Bool) {
//		tracker.send(GAIDictionaryBuilder.createEventWithCategory(GAIEventCategory.Activity.rawValue, action: completed ? GAIEventAction.Completed.rawValue : GAIEventAction.Cancelled.rawValue, label: activityType, value: 1).build())
	}
	
	
	public func logError(description: String, fatal: Bool = false) {
//		tracker.send(GAIDictionaryBuilder.createExceptionWithDescription(description, withFatal: fatal).build())
	}
	
	
	
	enum GAIEventCategory : String {
		case Tracker	= "Tracker"
		case Activity	= "Activity"
	}
	
	enum GAIEventAction : String {
		case Login			= "Login"
		case SubmitIssue	= "Submit Issue"
		case Completed		= "Completed"
		case Cancelled		= "Cancelled"
	}

}