//
//  DoneDoneIssueBase.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneIssueBase : DoneDoneSimpleItem {
	
	var orderNumber: Int?
	
	// var project: Project?
	
	var project = DoneDoneProject()
	
	// var project: SimpleItem?
	
	var dueDate: NSDate?
	
	var createdOn: NSDate?
	
	var status = DoneDoneSimpleItem()
	
	var tester = DoneDoneSimpleItem()
	
	var fixer = DoneDoneSimpleItem()
	
	var priority = DoneDoneSimpleItem()	
}