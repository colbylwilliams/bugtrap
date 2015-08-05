//
//  PivotalMe.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalMe : JsonSerializable {

	var id = 0
	var name = ""
	var initials = ""
	var username = ""
	// var timeZone time_zone
	var apiToken = ""
	var hasGoogleIdentity = false
	var projectIds = [Int]()
	var workspaceIds = [Int]()
	var email = ""
	var receivesInAppNotifications = false
	// var createdAt NSDate
	// var updatedAt NSDate
	var kind = ""


	init (id: Int, name: String, initials: String, username: String, apiToken: String, hasGoogleIdentity: Bool, projectIds: [Int], workspaceIds: [Int], email: String, receivesInAppNotifications: Bool, kind: String) {

		self.id = id
		self.name = name
		self.initials = initials
		self.username = username
		// self.timeZone = timeZone
		self.apiToken = apiToken
		self.hasGoogleIdentity = hasGoogleIdentity
		self.projectIds = projectIds
		self.workspaceIds = workspaceIds
		self.email = email
		self.receivesInAppNotifications = receivesInAppNotifications
		// self.createdAt = createdAt
		// self.updatedAt = updatedAt
		self.kind = kind
	}


	class func deserialize (json: JSON) -> PivotalMe? {

		// var timeZone time_zone
		// var createdAt NSDate
		// var updatedAt NSDate

		let id = json["id"].intValue
		
		let name = json["name"].stringValue
		
		let initials = json["initials"].stringValue
		
		let username = json["username"].stringValue
		
		// if let timeZoneW = json["time_zone"].time_zone {
		// 	timeZone = timeZoneW
		// }
		
		let apiToken = json["api_token"].stringValue
		
		let hasGoogleIdentity = json["has_google_identity"].boolValue

		var projectIds = [Int]()
		
		for item in json["project_ids"].arrayValue {
			if let idW = item.int {
				projectIds.append(idW)
			}
		}

		var workspaceIds = [Int]()
		
		for item in json["workspace_ids"].arrayValue {
			if let idW = item.int {
				workspaceIds.append(idW)
			}
		}

		let email = json["email"].stringValue

		let receivesInAppNotifications = json["receives_in_app_notifications"].boolValue
		
		// if let createdAtW = json["created_at"].datetime {
		// 	createdAt = createdAtW
		// }
		
		// if let updatedAtW = json["updated_at"].datetime {
		// 	updatedAt = updatedAtW
		// }
		
		let kind = json["kind"].stringValue

		return PivotalMe (id: id, name: name, initials: initials, username: username, apiToken: apiToken, hasGoogleIdentity: hasGoogleIdentity, projectIds: projectIds, workspaceIds: workspaceIds, email: email, receivesInAppNotifications: receivesInAppNotifications, kind: kind)
	}

	class func deserializeAll(json: JSON) -> [PivotalMe] {

		var items = [PivotalMe]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalMe = deserialize(item) {
					items.append(pivotalMe)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}