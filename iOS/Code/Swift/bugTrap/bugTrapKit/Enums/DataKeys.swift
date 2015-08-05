//
//  DataKeys.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum DataKeys : String, Stringable {

    case None				= "None"
    case Tracker			= "Tracker"
    case Server				= "Server"
    case Subdomain			= "Subdomain"
    case UserName			= "UserName"
    case Password			= "Password"
    case Project			= "Project"
    case Title				= "Title"
    case Detail				= "Detail"
    case Auxiliary			= "Auxiliary"
    case Priority			= "Priority"
    case Fixer				= "Fixer"
    case ImageUrl			= "ImageUrl"
	case Token				= "Token"
	case LocalIdentifier	= "LocalIdentifier"
    
	var string: String {
		return self.rawValue
	}
}