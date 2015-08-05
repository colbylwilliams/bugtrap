//
//  DoneDoneProject.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneProject : DoneDoneSimpleItem {

	var totalIssuesInProject = 0

	var releaseBuildsEnabled = false

    var tags = [DoneDoneTag]()

	override init() {
		super.init()
	}


	override init(id: Int?, value: String) {
		super.init(id: id, value: value)
	}


	init(id: Int, value: String, totalIssues: Int, releaseBuild: Bool, tagsArray: [DoneDoneTag]?) {
		super.init(id: id, value: value)
		self.totalIssuesInProject = totalIssues
		self.releaseBuildsEnabled = releaseBuild

        if let tags = tagsArray {
            self.tags = tags
        }
	}


	override class func deserialize (json: JSON) -> DoneDoneProject? {

		if let id = json["id"].int {

			var tags : [DoneDoneTag]?

			let value = json["title"].stringValue

			let totalIssues = json["total_issues_in_project"].intValue

			let releaseBuild = json["release_builds_enabled"].boolValue

			if let tagJsonArray = json["tags"].array {
				tags = DoneDoneTag.deserializeAll(tagJsonArray)
			}

			return DoneDoneProject(id: id, value: value, totalIssues: totalIssues, releaseBuild: releaseBuild, tagsArray: tags)
		}

		return nil
	}
}