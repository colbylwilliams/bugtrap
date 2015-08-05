//
//  JiraIssueType.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueType : JiraSimpleItem {
	
	var subtask = false
	
	var fields = JiraIssueTypeFields()
	
	override init() {
		super.init()
	}
	
	init(id: Int?, name: String, key: String, selfUrl: String, iconUrl: String, details: String, expand: String, subtask: Bool, fields: JiraIssueTypeFields) {
		super.init(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand)
		self.subtask = subtask
		self.fields = fields
	}
	
	override class func deserialize (json: JSON) -> JiraIssueType?  {
		
		let id = json["id"].intValue
		
		let name = json["name"].stringValue
		
		let key = json["key"].stringValue
		
		let selfUrl = json["self"].stringValue
		
		let iconUrl = json["iconUrl"].stringValue
		
		let details = json["description"].stringValue
		
		let expand = json["expand"].stringValue
		
		let subtask = json["subtask"].boolValue
		
		let fields = JiraIssueTypeFields.deserialize(json["fields"])
		
		return JiraIssueType(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand, subtask: subtask, fields: fields!)
	}
	
	class func deserializeAll(json: JSON) -> [JiraIssueType] {
		
		var items = [JiraIssueType]()
		
		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let si = deserialize(item) {
					items.append(si)
				}
			}
		}
		
		return items
	}
}