//
//  NSMutableDataExtensions.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/11/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

extension NSMutableData {
	
	func appendString(string: String) {
		// println(string)
		let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		appendData(data!)
	}
}