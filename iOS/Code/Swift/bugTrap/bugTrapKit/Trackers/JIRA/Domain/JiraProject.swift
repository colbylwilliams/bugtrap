//
//  JiraProject.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraProject : JiraSimpleItem {
	
	// var lead = JiraUser
	
	var issueTypes = [JiraIssueType]()
	
	var assigneeType = ""
	
	var avatarUrls = JiraAvatarUrls()
	
	override init() {
		super.init()
	}
	
	init(id: Int?, name: String, key: String, selfUrl: String, iconUrl: String, details: String, expand: String, issueTypes: [JiraIssueType], assigneeType: String, avatarUrls: JiraAvatarUrls) {
		super.init(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand)
		self.issueTypes = issueTypes
		self.assigneeType = assigneeType
		self.avatarUrls = avatarUrls
	}
	
	override class func deserialize (json: JSON) -> JiraProject?  {
		
		let id = json["id"].intValue
		
		let name = json["name"].stringValue
		
		let key = json["key"].stringValue
		
		let selfUrl = json["self"].stringValue
		
		let iconUrl = json["iconUrl"].stringValue
		
		let details = json["description"].stringValue
		
		let expand = json["expand"].stringValue
		
		let issueTypes:[JiraIssueType] = JiraIssueType.deserializeAll(json["issuetypes"])
		
		let assigneeType = json["assigneeType"].stringValue
		
		let avatarUrls = JiraAvatarUrls.deserialize(json["avatarUrls"])
		
		return JiraProject(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand, issueTypes: issueTypes, assigneeType: assigneeType, avatarUrls: avatarUrls!)
	}

	class func deserializeAll(json: JSON) -> [JiraProject] {
		
		var items = [JiraProject]()
		
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