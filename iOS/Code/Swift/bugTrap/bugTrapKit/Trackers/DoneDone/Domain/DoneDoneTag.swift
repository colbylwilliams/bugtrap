//
//  DoneDoneTag.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneTag : DoneDoneSimpleItem {

	var numberOfIssues = 0


	init(id: Int, value: String, issues: Int) {
		super.init(id: id, value: value)
		self.numberOfIssues = issues
	}

	override class func deserialize (json: JSON) -> DoneDoneTag?  {

		if let id = json["id"].int {

			let name = json["name"].stringValue

			let noi = json["number_of_issues"].intValue

			return DoneDoneTag(id: id, value: name, issues: noi)
		}

		return nil
	}

	class func deserializeAll(json: [JSON]) -> [DoneDoneTag]? {

		var items = [DoneDoneTag]()

        for tagJson: JSON in json {
			if let tag = deserialize(tagJson) {
				items.append(tag)
			}
        }

		return items
	}
}