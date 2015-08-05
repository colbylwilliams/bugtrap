//
//  JiraDetail.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum JiraDetail: Int, TrackerDetailType {
	case Images = 0, Project, IssueType, Summary, Priority, Description, Assignee, DueDate, Environment, FixVersions, Versions, Labels

	func isPersonDetail () -> Bool {
        switch self {
		case .Assignee: return true
		default: return false
        }
    }

	var settingsKey: String {
		switch self {
			case .Images: return "JiraDetailImages"
			case .Project: return "JiraDetailProject"
			case .IssueType: return "JiraDetailIssueType"
			case .Summary: return "JiraDetailSummary"
			case .Priority: return "JiraDetailPriority"
			case .Description: return "JiraDetailDescription"
			case .Assignee: return "JiraDetailAssignee"
			case .DueDate: return "JiraDetailDueDate"
			case .Environment: return "JiraDetailEnvironment"
			case .FixVersions: return "JiraDetailFixVersions"
			case .Versions: return "JiraDetailVersions"
			case .Labels: return "JiraDetailLabels"
		}
	}
}