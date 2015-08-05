//
//  JiraAvatarUrls.swift
//  bugTrap
//
//  Created by Colby L Williams on 1/27/15.
//  Copyright (c) 2015 bugTrap. All rights reserved.
//

import Foundation

class JiraAvatarUrls : JsonSerializable {

	var size48	= ""
	var size32	= ""
	var size24	= ""
	var size16	= ""

	var isEmpty: Bool {
		return !size48.isEmpty || !size32.isEmpty || !size24.isEmpty || !size16.isEmpty
	}
	
	var largestAvailable: String? {
		return !size48.isEmpty ? size48 : !size32.isEmpty ? size32 : !size24.isEmpty ? size24 : !size16.isEmpty ? size16 : nil
	}
	
	init() {

	}

	init(size48: String, size32: String, size24: String, size16: String) {
		self.size48 = size48
		self.size32 = size32
		self.size24 = size24
		self.size16 = size16
	}

	class func deserialize (json: JSON) -> JiraAvatarUrls?  {

		let size48 = json["48x48"].stringValue

		let size32 = json["32x32"].stringValue

		let size24 = json["24x24"].stringValue

		let size16 = json["16x16"].stringValue

		return JiraAvatarUrls(size48: size48, size32: size32, size24: size24, size16: size16)
	}

	class func deserializeAll(json: JSON) -> [JiraAvatarUrls] {

		var items = [JiraAvatarUrls]()

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

		return dict
	}
}