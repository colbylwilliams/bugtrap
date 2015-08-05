//
//  GAIKeys.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/20/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

struct GAIKeys {
	
	#if DEBUG
	static let trackingID = "UA-56018703-2"
	#else
	static let trackingID = "UA-56018703-3"
	#endif
	
	struct ScreenNames {
		
		static let annotateSnapshot	= "Annotate Snapshot"
		static let selectSnapshot	= "Select Snapshot"
		static let editSnapshots	= "Edit Snapshots"
		static let addSnapshots		= "Add Snapshots"
		static let trackerAccounts	= "Tracker Accounts"
		static let bugDetails		= "Bug Details"
		static let bugDetailsSelect = "Bug Details Select"
	}
}