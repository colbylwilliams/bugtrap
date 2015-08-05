//
//  JiraIssue.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraIssue : JiraSimpleItem {
	
	var fields = JiraIssueFields()
	
	
	override func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()
		
		dict.setObject(fields.serialize(), forKey: "fields")
		
		return dict
	}
	
	
	var valid: Bool {
		return fields.project.id != nil && fields.issueType.id != nil && fields.priority.id != nil && !fields.assignee.name.isEmpty && !fields.summary.isEmpty && !fields.description.isEmpty
	}
}