////
////  PivotalMembershipBase.swift
////  bugTrap
////
////  Created by Colby L Williams on 11/10/14.
////  Copyright (c) 2014 bugTrap. All rights reserved.
////
//
//import Foundation
//
//class PivotalMembershipBase : JsonSerializable {
//
//	var id = 0
//
//	var personId = 0
//
//	var person = PivotalPerson()
//
//	var kind = ""
//
//
//	init (id: Int, name: String, initials: String, username: String, apiToken: String, hasGoogleIdentity: Bool, projectIds: [Int], workspaceIds: [Int], email: String, receivesInAppNotifications: Bool, kind: String) {
//
//		self.id = id
//		self.personId = person
//		self.kind = kind
//	}
//
//
//	class func deserialize (json: JSONValue) -> PivotalMe? {
//
//		var id = 0
//		var name = ""
//		var initials = ""
//		var username = ""
//		// var timeZone time_zone
//		var apiToken = ""
//		var hasGoogleIdentity = false
//		var projectIds = [Int]()
//		var workspaceIds = [Int]()
//		var email = ""
//		var receivesInAppNotifications = false
//		// var createdAt NSDate
//		// var updatedAt NSDate
//		var kind = ""
//
//		if let idW = json["id"].integer {
//			id = idW
//		}
//		if let nameW = json["name"].string {
//			name = nameW
//		}
//		if let initialsW = json["initials"].string {
//			initials = initialsW
//		}
//		if let usernameW = json["username"].string {
//			username = usernameW
//		}
//		// if let timeZoneW = json["time_zone"].time_zone {
//		// 	timeZone = timeZoneW
//		// }
//		if let apiTokenW = json["api_token"].string {
//			apiToken = apiTokenW
//		}
//		if let hasGoogleIdentityW = json["has_google_identity"].bool {
//			hasGoogleIdentity = hasGoogleIdentityW
//		}
//		if let projectIdsW = json["project_ids"].array {
//			for item: JSONValue in projectIdsW {
//				if let projectIdsI = item.integer {
//					projectIds.append(projectIdsI)
//				}
//			}
//		}
//		if let workspaceIdsW = json["workspace_ids"].array {
//			for item: JSONValue in workspaceIdsW {
//				if let workspaceIdsI = item.integer {
//					workspaceIds.append(workspaceIdsI)
//				}
//			}
//		}
//		if let emailW = json["email"].string {
//			email = emailW
//		}
//		if let receivesInAppNotificationsW = json["receives_in_app_notifications"].bool {
//			receivesInAppNotifications = receivesInAppNotificationsW
//		}
//		// if let createdAtW = json["created_at"].datetime {
//		// 	createdAt = createdAtW
//		// }
//		// if let updatedAtW = json["updated_at"].datetime {
//		// 	updatedAt = updatedAtW
//		// }
//		if let kindW = json["kind"].string {
//			kind = kindW
//		}
//
//		return PivotalMe (id: id, name: name, initials: initials, username: username, apiToken: apiToken, hasGoogleIdentity: hasGoogleIdentity, projectIds: projectIds, workspaceIds: workspaceIds, email: email, receivesInAppNotifications: receivesInAppNotifications, kind: kind)
//	}
//
//	class func deserializeAll(json: JSONValue) -> [PivotalMe] {
//
//		var items = [PivotalMe]()
//
//		if let jsonArray = json.array {
//			for item: JSONValue in jsonArray {
//				if let pivotalMe = deserialize(item) {
//					items.append(pivotalMe)
//				}
//			}
//		}
//
//		return items
//	}
//
//
//	func serialize () -> NSMutableDictionary {
//		return NSMutableDictionary()
//	}
//}