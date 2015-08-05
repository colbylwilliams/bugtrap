//
//  PivotalStoryTypes.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum PivotalStoryTypes : String
{
	case Feature =	"feature"
	case Bug =		"bug"
	case Chore =	"chore"
	case Release =	"release"
	
	var toArray: [String] {
		return ["feature", "bug", "chore", "release"]
	}
}