//
//  JiraIssueCreateMeta.swift
//  bugTrap
//
//  Created by Colby L Williams on 1/26/15.
//  Copyright (c) 2015 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueCreateMeta : JsonSerializable {

	var projects = [JiraProject]()
	
	init() {
		
	}
	
	init (projects: [JiraProject]) {
		self.projects = projects
	}
	
	class func deserialize (json: JSON) -> JiraIssueCreateMeta?  {
		
		let projects: [JiraProject] = JiraProject.deserializeAll(json["projects"])
		
		return JiraIssueCreateMeta(projects: projects)
	}
	
	class func deserializeAll(json: JSON) -> [JiraIssueCreateMeta] {
		
		var items = [JiraIssueCreateMeta]()
		
		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let si = deserialize(item) {
					items.append(si)
				}
			}
		}
		
		return items
	}
	
	
	func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()
		
		
		return dict
	}
	
}