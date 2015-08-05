//
//  TrackerType.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum TrackerType: String, Stringable {

    case	None            = "None",
			Assembla		= "Assembla",
			Axosoft			= "Axosoft",
			Basecamp		= "Basecamp",
			Bitbucket		= "Bitbucket",
			DoneDone		= "DoneDone",
			FogBugz			= "FogBugz",
			GitHub			= "GitHub",
			JIRA			= "JIRA",
			Lighthouse		= "Lighthouse",
			PivotalTracker	= "Pivotal Tracker"

	
    static let values = [
		Assembla,
		Axosoft,
		Basecamp,
		Bitbucket,
		DoneDone,
		FogBugz,
		GitHub,
		JIRA,
		Lighthouse,
		PivotalTracker
	]

	
	var enabled: Bool {
		return self.status == TrackerStatus.Enabled
    }


	func valid(creditials: [DataKeys:String]) -> Bool {
		switch self {
		case .None:				return false
		case .Assembla:			return false
		case .Axosoft:			return false
		case .Basecamp:			return false
		case .Bitbucket:		return false
		case .DoneDone:			return creditials[.Subdomain] != nil && creditials[.UserName] != nil && creditials[.Password] != nil
		case .FogBugz:			return false
		case .GitHub:			return false
		case .JIRA:				return creditials[.Server] != nil && creditials[.UserName] != nil && creditials[.Password] != nil
		case .Lighthouse:		return false
		case .PivotalTracker:	return creditials[.Token] != nil || (creditials[.UserName] != nil && creditials[.Password] != nil)
		}
	}


	var status: TrackerStatus {
        switch self {
		case .None:				return TrackerStatus.Disabled
		case .Assembla:			return TrackerStatus.ComingSoon
		case .Axosoft:			return TrackerStatus.ComingSoon
		case .Basecamp:			return TrackerStatus.ComingSoon
		case .Bitbucket:		return TrackerStatus.ComingSoon
		case .DoneDone:			return TrackerStatus.Enabled
		case .FogBugz:			return TrackerStatus.ComingSoon
		case .GitHub:			return TrackerStatus.ComingSoon
		case .JIRA:				return TrackerStatus.Enabled
		case .Lighthouse:		return TrackerStatus.ComingSoon
		case .PivotalTracker:	return TrackerStatus.Enabled
		}
    }

	var smallImageName: String? {
		switch self {
		case .None:				return nil // "logo_none"
		case .Assembla:			return nil // "logo_assembla"
		case .Axosoft:			return nil // "logo_axosoft"
		case .Basecamp:			return nil // "logo_basecamp"
		case .Bitbucket:		return nil // "logo_bitbucket"
		case .DoneDone:			return "logo_donedone"
		case .FogBugz:			return nil // "logo_fogbugz"
		case .GitHub:			return nil // "logo_github"
		case .JIRA:				return "logo_jira"
		case .Lighthouse:		return nil // "logo_lighthouse"
		case .PivotalTracker:	return "logo_pivotaltracker"
		}
	}


	var activityImageName: String? {
		switch self {
		case .None:				return nil // "logo_activity_none"
		case .Assembla:			return nil // "logo_activity_assembla"
		case .Axosoft:			return nil // "logo_activity_axosoft"
		case .Basecamp:			return nil // "logo_activity_basecamp"
		case .Bitbucket:		return nil // "logo_activity_bitbucket"
		case .DoneDone:			return "logo_activity_donedone"
		case .FogBugz:			return nil // "logo_activity_fogbugz"
		case .GitHub:			return nil // "logo_activity_github"
		case .JIRA:				return "logo_activity_jira"
		case .Lighthouse:		return nil // "logo_activity_lighthouse"
		case .PivotalTracker:	return "logo_activity_pivotaltracker"
		}
	}


	var loginControllerName: String? {
		switch self {
		case .None:				return nil // "logo_none"
		case .Assembla:			return nil // "logo_assembla"
		case .Axosoft:			return nil // "logo_axosoft"
		case .Basecamp:			return nil // "logo_basecamp"
		case .Bitbucket:		return nil // "logo_bitbucket"
		case .DoneDone:			return "DoneDoneLogin"
		case .FogBugz:			return nil // "logo_fogbugz"
		case .GitHub:			return nil // "logo_github"
		case .JIRA:				return "JiraLogin"
		case .Lighthouse:		return nil // "logo_lighthouse"
		case .PivotalTracker:	return "PivotalTrackerLogin"
		}
	}


	var activityType: String {
		switch self {
		case .None:				return "io.bugtrap.trackers.None"
		case .Assembla:			return "io.bugtrap.trackers.Assembla"
		case .Axosoft:			return "io.bugtrap.trackers.Axosoft"
		case .Basecamp:			return "io.bugtrap.trackers.Basecamp"
		case .Bitbucket:		return "io.bugtrap.trackers.Bitbucket"
		case .DoneDone:			return "io.bugtrap.trackers.DoneDone"
		case .FogBugz:			return "io.bugtrap.trackers.FogBugz"
		case .GitHub:			return "io.bugtrap.trackers.GitHub"
		case .JIRA:				return "io.bugtrap.trackers.JIRA"
		case .Lighthouse:		return "io.bugtrap.trackers.Lighthouse"
		case .PivotalTracker:	return "io.bugtrap.trackers.PivotalTracker"
		}
	}
	
	
	var googleAnalyticsMetricIndex: UInt {
		switch self {
		case .None:				return 0
		case .Assembla:			return 10
		case .Axosoft:			return 1
		case .Basecamp:			return 2
		case .Bitbucket:		return 3
		case .DoneDone:			return 4
		case .FogBugz:			return 5
		case .GitHub:			return 6
		case .JIRA:				return 7
		case .Lighthouse:		return 8
		case .PivotalTracker:	return 9
		}
	}

	var string: String {
		return self.rawValue
	}
}