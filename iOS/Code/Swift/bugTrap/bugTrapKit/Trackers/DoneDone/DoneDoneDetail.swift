//
//  DoneDoneDetail.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum DoneDoneDetail: Int, TrackerDetailType {
    case Images = 0, Project, Title, Description, Priority, Fixer, Tester, DueDate, Tags, Notify

    func isPersonDetail () -> Bool {
        switch self {
        case .Images, .Project, .Title, .Description, .Priority, .Tags, .DueDate: return false
        case .Fixer, .Tester, Notify: return true
        }
    }

	var settingsKey: String {
		switch self {
            case .Images: return "DoneDoneDetailImages"
            case .Project: return "DoneDoneDetailProject"
            case .Title: return "DoneDoneDetailTitle"
            case .Description: return "DoneDoneDetailDescription"
            case .Priority: return "DoneDoneDetailPriority"
            case .Fixer: return "DoneDoneDetailFixer"
            case .Tester: return "DoneDoneDetailTester"
            case .DueDate: return "DoneDoneDetailDueDate"
            case .Tags: return "DoneDoneDetailTags"
            case .Notify: return "DoneDoneDetailNotify"
		}
	}
}