//
//  NSDateExtensions.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

extension NSDate {
	
	func string() -> String {
		
		let format = NSDateFormatter()
			format.dateStyle = .LongStyle
		
		return format.stringFromDate(self)
	}
}