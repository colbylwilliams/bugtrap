//
//  JiraSimpleItem.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraSimpleItem : JsonSerializable, Equatable {

	var id: Int?

	var name	= ""

	var key		= ""

	var selfUrl = ""  // self

	var iconUrl = ""

	var details = ""  // description
	
	var expand = ""


	init() {

	}

	init(id: Int?, name: String, key: String, selfUrl: String, iconUrl: String, details: String, expand: String) {
		self.id = id
		self.name = name
		self.key = key
		self.selfUrl = selfUrl
		self.iconUrl = iconUrl
		self.details = details
		self.expand = expand
	}

	class func deserialize (json: JSON) -> JiraSimpleItem?  {

		let id = json["id"].intValue

		let name = json["name"].stringValue

		let key = json["key"].stringValue

		let selfUrl = json["self"].stringValue

		let iconUrl = json["iconUrl"].stringValue

		let details = json["description"].stringValue
		
		let expand = json["expand"].stringValue

		return JiraSimpleItem(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand)
	}

	class func deserializeAll(json: JSON) -> [JiraSimpleItem] {

		var items = [JiraSimpleItem]()

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
		
		dict.setObject("\(id!)", forKey: "id")
		
		return dict
	}
}

func == (lhs: JiraSimpleItem, rhs: JiraSimpleItem) -> Bool {
	return lhs.id == rhs.id
}