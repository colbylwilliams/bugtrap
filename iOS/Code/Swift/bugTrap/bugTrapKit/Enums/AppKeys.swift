//
//  AppKeys.swift
//  bugTrap
//
//  Created by Colby L Williams on 9/21/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum AppKeys : String, Stringable {
	
	case BundlePrefix	= "T32UVX74Z3"
	case AccessGroup	= "T32UVX74Z3.io.bugtrap.bugTrap.group"
	case ContactEmail	= "support@bugtrap.io"
	case GAITrackingID	= "UA-56018703-2"
	
	var string: String {
		return self.rawValue
	}
}