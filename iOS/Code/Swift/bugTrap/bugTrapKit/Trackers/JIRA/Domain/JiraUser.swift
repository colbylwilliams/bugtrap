//
//  JiraUser.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraUser : JiraSimpleItem {

	var displayName = ""

	var active = false

	var timeZone = ""

	var locale = ""

	var emailAddress = ""
	
	var avatarUrls = JiraAvatarUrls()

	override init() {
		super.init()
	}


	init(id: Int?, name: String, key: String, selfUrl: String, iconUrl: String, details: String, expand: String, displayName: String, active: Bool, timeZone: String, locale: String, emailAddress: String, avatarUrls: JiraAvatarUrls) {
		super.init(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand)
		self.displayName = displayName
		self.active = active
		self.timeZone = timeZone
		self.locale = locale
		self.emailAddress = emailAddress
		self.avatarUrls = avatarUrls
	}

	override class func deserialize (json: JSON) -> JiraUser?  {

		let id = json["id"].intValue

		let name = json["name"].stringValue

		let key = json["key"].stringValue

		let selfUrl = json["self"].stringValue

		let iconUrl = json["iconUrl"].stringValue

		let details = json["description"].stringValue
		
		let expand = json["expand"].stringValue

		let displayName = json["displayName"].stringValue

		let active = json["active"].boolValue

		let timeZone = json["timeZone"].stringValue

		let locale = json["locale"].stringValue

		let emailAddress = json["emailAddress"].stringValue

		let avatarUrls = JiraAvatarUrls.deserialize(json["avatarUrls"]) ?? JiraAvatarUrls()
		
		return JiraUser(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand, displayName: displayName, active: active, timeZone: timeZone, locale: locale, emailAddress: emailAddress, avatarUrls: avatarUrls)
	}

	class func deserializeAll(json: JSON) -> [JiraUser] {

		var items = [JiraUser]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let si = deserialize(item) {
					items.append(si)
				}
			}
		}

		return items
	}
	
	override func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()
		
		dict.setObject(name, forKey: "name")
		
		return dict
	}
}