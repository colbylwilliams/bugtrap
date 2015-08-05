//
//  PivotalError.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/11/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalError : JsonSerializable {

	var code = ""
	var error = ""
	var kind = ""

	init(code: String, error: String, kind: String) {

		self.code = code
		self.error = error
		self.kind = kind
	}

	class func deserialize (json: JSON) -> PivotalError? {

		let code = json["code"].stringValue

		let error = json["error"].stringValue

		let kind = json["kind"].stringValue

		return PivotalError(code: code, error: error, kind: kind)
	}

	class func deserializeAll(json: JSON) -> [PivotalError] {

		var items = [PivotalError]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalError = deserialize(item) {
					items.append(pivotalError)
				}
			}
		}

		return items
	}

	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}
