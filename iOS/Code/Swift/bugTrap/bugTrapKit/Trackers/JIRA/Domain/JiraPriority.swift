//
//  JiraPriority.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraPriority : JiraSimpleItem {
	
	var statusColor = ""
	
	override init() {
		super.init()
	}
	
	init(id: Int?, name: String, key: String, selfUrl: String, iconUrl: String, details: String, expand: String, statusColor: String) {
		super.init(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand)
		self.statusColor = statusColor
	}
	
	override class func deserialize (json: JSON) -> JiraPriority?  {
		
		let id = json["id"].intValue
		
		let name = json["name"].stringValue
		
		let key = json["key"].stringValue
		
		let selfUrl = json["self"].stringValue
		
		let iconUrl = json["iconUrl"].stringValue
		
		let details = json["description"].stringValue
		
		let expand = json["expand"].stringValue
		
		let statusColor = json["statusColor"].stringValue
		
		return JiraPriority(id: id, name: name, key: key, selfUrl: selfUrl, iconUrl: iconUrl, details: details, expand: expand, statusColor: statusColor)
	}
	
	class func deserializeAll(json: JSON) -> [JiraPriority] {
		
		var items = [JiraPriority]()
		
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