//
//  JiraIssueTypeFieldSchema.swift
//  bugTrap
//
//  Created by Colby L Williams on 1/26/15.
//  Copyright (c) 2015 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueTypeFieldSchema : JsonSerializable {

	var type	= ""
	var system	= ""
	
	
	init() {
		
	}
	
	init(type: String, system: String) {
		self.type = type
		self.system = system
	}
	
	class func deserialize (json: JSON) -> JiraIssueTypeFieldSchema?  {
		
		let type = json["type"].stringValue
		
		let system = json["system"].stringValue
		
		return JiraIssueTypeFieldSchema(type: type, system: system)
	}
	
	class func deserializeAll(json: JSON) -> [JiraIssueTypeFieldSchema] {
		
		var items = [JiraIssueTypeFieldSchema]()
		
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
		
		dict.setObject(type, forKey: "type")
		dict.setObject(system, forKey: "system")
		
		return dict
	}
}