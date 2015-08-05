//
//  PivotalProjectMembership.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalProjectMembership : JsonSerializable {

	var id = 0

	var personId = 0

	var person = PivotalPerson()

	var kind = ""


	init (id: Int, person: PivotalPerson, kind: String) {
		self.id = id
		self.person = person
		self.personId = person.id
		self.kind = kind
	}


	class func deserialize (json: JSON) -> PivotalProjectMembership? {

		var person = PivotalPerson()

		let id = json["id"].intValue

		if let personW = PivotalPerson.deserialize(json["person"]) {
			person = personW
		} else {
			person.id = json["person_id"].intValue
		}

		let kind = json["kind"].stringValue

		return PivotalProjectMembership (id: id, person: person, kind: kind)
	}

	class func deserializeAll(json: JSON) -> [PivotalProjectMembership] {

		var items = [PivotalProjectMembership]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalProjectMembership = deserialize(item) {
					items.append(pivotalProjectMembership)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}