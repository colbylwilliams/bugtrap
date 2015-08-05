//
//  JsonSerializable.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

protocol JsonSerializable {
	
	typealias ItemType
	
	static func deserializeAll (json: JSON) -> [ItemType]
	
	static func deserialize (json: JSON) -> ItemType?
    
    func serialize () -> NSMutableDictionary
}