//
//  JiraIssueFields.swift
//  bugTrap
//
//  Created by Colby L Williams on 12/5/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueFields : JsonSerializable {

	private struct fields {
		static let project 		= "project"
		static let summary	 	= "summary"
		static let issueType	= "issuetype"
		static let assignee		= "assignee"
//		static let reporter		= "reporter"
		static let priority		= "priority"
//		static let labels		= "labels"
		static let description 	= "description"
//		static let dueDate	 	= "duedate"
//		static let environment	= "environment"
//		static let fixVersions	= "fixVersions"
//		static let versions		= "versions"
	}

	var project: JiraProject = JiraProject() {
		willSet {
			issueType = JiraIssueType()
			priority  = JiraSimpleItem()
//			labels	  = [JiraLabel]()
		}
	}


	var summary		= ""

	var issueType	= JiraIssueType()

	var assignee	= JiraUser()

//	var reporter	= JiraUser()

	var priority	= JiraSimpleItem()

//	var labels		= [JiraLabel]()

	var description = ""

//	var dueDate : NSDate?

	init () {

	}

//	init (project: JiraProject, summary: String, issueType: JiraIssueType, assignee: JiraUser, reporter: JiraUser, priority: JiraSimpleItem, labels: [JiraLabel], description: String, dueDate: NSDate?) {
	init (project: JiraProject, summary: String, issueType: JiraIssueType, assignee: JiraUser, priority: JiraSimpleItem, description: String) {
		self.project	 = project
		self.summary	 = summary
		self.issueType	 = issueType
		self.assignee	 = assignee
//		self.reporter	 = reporter
		self.priority	 = priority
//		self.labels		 = labels
		self.description = description
//		self.dueDate	 = dueDate
	}



	func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()

		dict.setObject(project.serialize(),		forKey: fields.project)
		dict.setObject(summary,					forKey: fields.summary)
		dict.setObject(issueType.serialize(),	forKey: fields.issueType)
		// dict.setObject(assignee.serialize(),	forKey: fields.assignee)
		// dict.setObject(reporter.name,		forKey: fields.reporter)
		dict.setObject(priority.serialize(),	forKey: fields.priority)

//		if self.labels.count > 0 {
//			dict.setObject(", ".join(labels.map({ $0.name })), forKey: fields.labels)
//		}


//		if let dueDate = self.dueDate {
//			let dateFormatter = NSDateFormatter()
//			dateFormatter.dateFormat = "yyyy-MM-dd" // "yyyy-MM-ddTHH:mm.ssZ"
//			dict.setObject(dateFormatter.stringFromDate(dueDate), forKey: fields.dueDate)
//		}

		description += TrapState.Shared.deviceDetailsJira

		dict.setObject(description, forKey: fields.description)

		return dict
	}



	class func deserialize (json: JSON) -> JiraIssueFields? {

		var project		= JiraProject()
		var issueType	= JiraIssueType()
		var assignee	= JiraUser()
//		var reporter	= JiraUser()
		var priority	= JiraSimpleItem()
//		var labels		= [JiraLabel]()
//		var dueDate : NSDate?


		if let projectW = JiraProject.deserialize(json[fields.project]) {
			project = projectW
		}

		let summary = json[fields.summary].stringValue

		if let issueTypeW = JiraIssueType.deserialize(json[fields.issueType]) {
			issueType = issueTypeW
		}

		if let assigneeW = JiraUser.deserialize(json[fields.assignee]) {
			assignee = assigneeW
		}

//		if let reporterW = JiraUser.deserialize(json[fields.reporter]) {
//			reporter = reporterW
//		}

		if let priorityW = JiraSimpleItem.deserialize(json[fields.priority]) {
			priority = priorityW
		}

		// labels

		let description = json[fields.description].stringValue

		//dueDate


		// return JiraIssueFields (project: project, summary: summary, issueType: issueType, assignee: assignee, reporter: reporter, priority: priority, labels: labels, description: description, dueDate: dueDate)
		return JiraIssueFields (project: project, summary: summary, issueType: issueType, assignee: assignee, priority: priority, description: description)
	}

	class func deserializeAll(json: JSON) -> [JiraIssueFields] {

		var items = [JiraIssueFields]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let jiraIssueFields = deserialize(item) {
					items.append(jiraIssueFields)
				}
			}
		}

		return items
	}
}