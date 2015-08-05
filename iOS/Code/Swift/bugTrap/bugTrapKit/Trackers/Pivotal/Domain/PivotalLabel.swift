//
//  PivotalLabel.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/31/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalLabel : JsonSerializable, Equatable {

	var id = 0
	var projectId = 0
	var name = ""
	var kind = ""

	init(id: Int, projectId: Int, name: String, kind: String) {

		self.id = id
		self.projectId = projectId
		self.name = name
		self.kind = kind
	}

	class func deserialize (json: JSON) -> PivotalLabel? {

		let id = json["id"].intValue
		
		let projectId = json["project_id"].intValue
		
		let name = json["name"].stringValue
		
		let kind = json["kind"].stringValue

		return PivotalLabel(id: id, projectId: projectId, name: name, kind: kind)
	}

	class func deserializeAll(json: JSON) -> [PivotalLabel] {

		var items = [PivotalLabel]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalLabel = deserialize(item) {
					items.append(pivotalLabel)
				}
			}
		}

		return items
	}

	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}

func == (lhs: PivotalLabel, rhs: PivotalLabel) -> Bool {
	return lhs.id == rhs.id
}