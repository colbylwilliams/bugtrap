//
//  DoneDoneSimpleItem.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneSimpleItem : JsonSerializable, Equatable {
	
	var id: Int?
	
	var name = ""
	
	var title = ""
	
	var value: String! {
		return !title.isEmpty ? title : !name.isEmpty ? name : ""
	}
	
	init() {

	}
	
	init(id: Int?, value: String) {
		self.id = id
		self.name = value
		self.title = value
	}
	
	class func deserialize (json: JSON) -> DoneDoneSimpleItem?  {
		
		if let id = json["id"].int {
		
			var value = ""
		
			if let t = json["title"].string {
				value = t
			} else if let n = json["name"].string {
				value = n
			}
        
            return DoneDoneSimpleItem(id: id, value: value)
        }
		
		return nil
	}
	
	class func deserializeAll(json: JSON) -> [DoneDoneSimpleItem] {
		
		var items = [DoneDoneSimpleItem]()
        
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
        return NSMutableDictionary()
    }
}

func == (lhs: DoneDoneSimpleItem, rhs: DoneDoneSimpleItem) -> Bool {
	return lhs.id == rhs.id
}