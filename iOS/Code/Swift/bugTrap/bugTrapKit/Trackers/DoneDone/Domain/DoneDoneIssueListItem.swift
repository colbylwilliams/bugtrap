//
//  DoneDoneIssueListItem.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneIssueListItem : DoneDoneIssueBase {
	
	var lastUpdatedOn: NSDate?
	
	var lastUpdater: DoneDoneSimpleItem?
	
	var lastViewedOn: NSDate?
	
	var isPublicIssue = false
}