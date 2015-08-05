//
//  JiraIssueTypeFields.swift
//  bugTrap
//
//  Created by Colby L Williams on 1/26/15.
//  Copyright (c) 2015 bugTrap. All rights reserved.
//

import Foundation

class JiraIssueTypeFields : JsonSerializable {

	private struct fields {
		static let summary		= "summary"
		static let issuetype	= "issuetype"
		static let parent		= "parent"
		static let attachment	= "attachment"
		static let description	= "description"
		static let project		= "project"
		static let priority		= "priority"
		static let environment	= "environment"
		static let fixVersions	= "fixVersions"
		static let versions		= "versions"
	}

	var summary = JiraIssueTypeField()
	var issuetype = JiraIssueTypeField()
	var parent = JiraIssueTypeField()
	var attachment = JiraIssueTypeField()
	var description = JiraIssueTypeField()
	var project = JiraIssueTypeField()
	var priority = JiraIssueTypeField()
	var environment	= JiraIssueTypeField()
	var fixVersions	= JiraIssueTypeField()
	var versions = JiraIssueTypeField()


	init() {

	}

	init(summary: JiraIssueTypeField?, issuetype: JiraIssueTypeField?, parent: JiraIssueTypeField?, attachment: JiraIssueTypeField?, description: JiraIssueTypeField?, project: JiraIssueTypeField?, priority: JiraIssueTypeField?, environment: JiraIssueTypeField?, fixVersions: JiraIssueTypeField?, versions: JiraIssueTypeField?) {
		self.summary =		summary		?? JiraIssueTypeField()
		self.issuetype =	issuetype	?? JiraIssueTypeField()
		self.parent =		parent		?? JiraIssueTypeField()
		self.attachment =	attachment	?? JiraIssueTypeField()
		self.description =	description ?? JiraIssueTypeField()
		self.project =		project		?? JiraIssueTypeField()
		self.priority =		priority	?? JiraIssueTypeField()
		self.environment =	environment ?? JiraIssueTypeField()
		self.fixVersions =	fixVersions	?? JiraIssueTypeField()
		self.versions =		versions	?? JiraIssueTypeField()
	}
	

	class func deserialize (json: JSON) -> JiraIssueTypeFields?  {

		let summary = JiraIssueTypeField.deserialize(json[fields.summary])

		let issuetype = JiraIssueTypeField.deserialize(json[fields.issuetype])

		let parent = JiraIssueTypeField.deserialize(json[fields.parent])

		let attachment = JiraIssueTypeField.deserialize(json[fields.attachment])

		let description = JiraIssueTypeField.deserialize(json[fields.description])

		let project = JiraIssueTypeField.deserialize(json[fields.project])

		let priority = JiraIssueTypeField.deserialize(json[fields.priority])
		
		let environment = JiraIssueTypeField.deserialize(json[fields.environment])
		
		let fixVersions = JiraIssueTypeField.deserialize(json[fields.fixVersions])
		
		let versions = JiraIssueTypeField.deserialize(json[fields.versions])

		return JiraIssueTypeFields(summary: summary, issuetype: issuetype, parent: parent, attachment: attachment, description: description, project: project, priority: priority, environment: environment, fixVersions: fixVersions, versions: versions)
	}

	class func deserializeAll(json: JSON) -> [JiraIssueTypeFields] {

		var items = [JiraIssueTypeFields]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let si = deserialize(item) {
					items.append(si)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		let dict = NSMutableDictionary()

		return dict
	}
}
