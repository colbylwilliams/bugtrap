//
//  HttpMethod.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum HttpMethod : String, Stringable
{
    case Get =		"GET"
    case Post =		"POST"
    case Put =		"PUT"
    case Delete =	"DELETE"
    
	var string: String {
		return self.rawValue
	}
}