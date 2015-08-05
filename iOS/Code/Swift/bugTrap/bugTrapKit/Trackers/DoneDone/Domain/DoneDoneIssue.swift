//
//  DoneDoneIssue.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneIssue : DoneDoneIssueBase {

	var description = ""

	var ccdUsers = [DoneDoneSimpleItem]()

	var attachments = [DoneDoneAttachment]()

	var histories = [DoneDoneHistory]()

	var tags = [DoneDoneTag]()

	var valid: Bool {
		return !value.isEmpty && priority.id != nil && fixer.id != nil && tester.id	!= nil
	}

    override func serialize () -> NSMutableDictionary {

        let dict = NSMutableDictionary()

        dict.setObject(self.title, forKey: DoneDoneFields.NewIssueFields.Title.string)

		let detailedDescription = self.description + TrapState.Shared.deviceDetails

		// Log.debug(detailedDescription)

        dict.setObject(detailedDescription, forKey: DoneDoneFields.NewIssueFields.Description.string)

        if let dueDate = self.dueDate {
			let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "Z"
			let dateString = NSString(format: "/Date(%.0f000%@)/", dueDate.timeIntervalSince1970, dateFormatter.stringFromDate(dueDate))
				dict.setObject(dateString, forKey: DoneDoneFields.NewIssueFields.DueDate.string)
        }

        if self.tags.count > 0 {
            dict.setObject(", ".join(tags.map({ $0.value })), forKey: DoneDoneFields.NewIssueFields.Tags.string)
        }

        dict.setObject(self.priority.id!, forKey: DoneDoneFields.NewIssueFields.PriorityLevelId.string)
        dict.setObject(self.fixer.id!, forKey: DoneDoneFields.NewIssueFields.FixerId.string)
        dict.setObject(self.tester.id!, forKey: DoneDoneFields.NewIssueFields.TesterId.string)

        if ccdUsers.count > 0 {
            let ccdUserIds = ", ".join(ccdUsers.map({ String($0.id!) }))
            dict.setObject(ccdUserIds, forKey: DoneDoneFields.NewIssueFields.UserIdsToCc.string)
        }

        return dict
    }

    override class func deserialize (json: JSON) -> DoneDoneIssue?  {

		if let id = json["id"].int {

			let title = json[DoneDoneFields.NewIssueFields.Title.string].stringValue

			let desc = json[DoneDoneFields.NewIssueFields.Description.string].stringValue

			return DoneDoneIssue(id: id, value: title)
		}

		return nil
    }
}