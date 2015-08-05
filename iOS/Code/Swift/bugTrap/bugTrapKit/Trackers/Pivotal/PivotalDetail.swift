//
//  PivotalDetail.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum PivotalDetail: Int, TrackerDetailType {
	case Images = 0, Project, Name, Description, StoryType, Deadline, Owners, Labels, Followers

	func isPersonDetail () -> Bool {
		switch self {
		case .Images, .Project, .Name, .Description, .StoryType, .Deadline, .Labels: return false
//		case .Owners: return true
		case .Owners, .Followers: return true
		}
	}

		var settingsKey: String {
		switch self {
			case .Images: return "PivotalDetailImages"
			case .Project: return "PivotalDetailProject"
			case .Name: return "PivotalDetailName"
			case .Description: return "PivotalDetailDescription"
			case .StoryType: return "PivotalDetailStoryType"
			case .Deadline: return "PivotalDetailDeadline"
			case .Owners: return "PivotalDetailOwners"
			case .Labels: return "PivotalDetailLabels"
			case .Followers: return "PivotalDetailFollowers"
		}
	}
}