//
//  PivotalPerson.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalPerson : JsonSerializable {

	var id = 0
	var name = ""
	var initials = ""
	var username = ""
	var email = ""
	var kind = ""


	init() {

	}


	init (id: Int, name: String, initials: String, username: String, email: String, kind: String) {

		self.id = id
		self.name = name
		self.initials = initials
		self.username = username
		self.email = email
		self.kind = kind
	}


	class func deserialize (json: JSON) -> PivotalPerson? {

		let id = json["id"].intValue
		
		let name = json["name"].stringValue
		
		let initials = json["initials"].stringValue
		
		let username = json["username"].stringValue
		
		let email = json["email"].stringValue
		
		let kind = json["kind"].stringValue

		return PivotalPerson (id: id, name: name, initials: initials, username: username, email: email, kind: kind)
	}

	class func deserializeAll(json: JSON) -> [PivotalPerson] {

		var items = [PivotalPerson]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalPerson = deserialize(item) {
					items.append(pivotalPerson)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}