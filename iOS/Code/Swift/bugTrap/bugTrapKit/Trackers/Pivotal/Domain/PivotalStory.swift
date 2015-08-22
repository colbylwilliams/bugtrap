//
//  PivotalStory.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalStory : JsonSerializable {

	var project: PivotalProject = PivotalProject() {
		willSet {
			projectId = newValue.id!
		}
	}

	var id: Int?
	var projectId: Int?					// int
	var name = ""						// string[5000]
	var description = ""				// string[20000]
	var storyType = "bug" // ""			// enumerated string
	var currentState = ""				// enumerated string
	var estimate = 0					// float
//	var acceptedAt:NSDate?				// datetime
	var deadline:NSDate?				// datetime
	var requestedById = 0				// int
	var ownedById = 0					// int
	var ownerIds = [Int]()				// List[int]
//	var labels = [PivotalLabel]()		// List[label]

	var labels: [PivotalLabel] = [PivotalLabel]() {
		willSet {
			labelIds = newValue.map({$0.id})
		}
	}

	var labelIds = [Int]()				// List[int]
//	var tasks = [tasks]()				// List[task]
	var followerIds = [Int]()			// List[int]
//	var comments = [PivotalComment]()	// List[comment]

	var comments: [PivotalComment] = [PivotalComment]() {
		willSet {
			commentIds = newValue.filter({$0.id != nil}).map({$0.id!})
		}
	}

	var commentIds = [Int]()
	var createdAt: NSDate?				// datetime
	var beforeId = 0					// int
	var afterId = 0						// int
	var integrationId = 0				// int
	var externalId = ""					// string[255]
	var clNumbers = ""					// string

	init () {

	}

	init (id: Int, projectId: Int, name: String, description: String, storyType: String, currentState: String, estimate: Int, requestedById: Int, ownedById: Int, ownerIds: [Int], labelIds: [Int], followerIds: [Int], commentIds: [Int], beforeId: Int, afterId: Int, integrationId: Int, externalId: String, clNumbers: String) {

		self.id = id
		self.projectId = projectId
		self.name = name
		self.description = description
		self.storyType = storyType
		self.currentState = currentState
		self.estimate = estimate
//		self.acceptedAt = acceptedAt
//		self.deadline = deadline
		self.requestedById = requestedById
		self.ownedById = ownedById
		self.ownerIds = ownerIds
//		self.labels = labels
		self.labelIds = labelIds
//		self.tasks = tasks
		self.followerIds = followerIds
//		self.comments = comments
		self.commentIds = commentIds
//		self.createdAt = createdAt
		self.beforeId = beforeId
		self.afterId = afterId
		self.integrationId = integrationId
		self.externalId = externalId
		self.clNumbers = clNumbers
	}

	class func deserialize (json: JSON) -> PivotalStory? {

		var id: Int?
		var projectId : Int?			// int
//		var acceptedAt:NSDate?		// datetime
//		var deadline:NSDate?		// datetime
//		var labels = [label]()		// List[label]
//		var tasks = [tasks]()		// List[task]
//		var comments = [comments]()	// List[comment]
//		let createdAt:NSDate?		// datetime


		if let idW = json["id"].int {
			id = idW

			if let projectIdW = json["project_id"].int {
				projectId = projectIdW
			}
			let name = json["name"].stringValue

			let description = json["description"].stringValue

			let storyType = json["story_type"].stringValue

			let currentState = json["current_state"].stringValue

			let estimate = json["estimate"].intValue

	//		if let acceptedAtW = json["accepted_at"].integer {
	//			acceptedAt = acceptedAtW
	//		}
	//		if let deadlineW = json["deadline"].integer {
	//			deadline = deadlineW
	//		}
			let requestedById = json["requested_by_id"].intValue

			let ownedById = json["owned_by_id"].intValue

			var ownerIds = [Int]()

			for item in json["owner_ids"].arrayValue {
				if let idW = item.int {
					ownerIds.append(idW)
				}
			}
	//		if let labelsW = json["labels"].array {
	//			for item: JSONValue in labelsW {
	//				if let labelsI = item.integer {
	//					labels.append(labelsI)
	//				}
	//			}
	//		}
			var labelIds = [Int]()

			for item in json["label_ids"].arrayValue {
				if let idW = item.int {
					labelIds.append(idW)
				}
			}
	//		if let tasksW = json["tasks"].array {
	//			for item: JSONValue in tasksW {
	//				if let tasksI = item.integer {
	//					tasks.append(tasksI)
	//				}
	//			}
	//		}
			var followerIds = [Int]()

			for item in json["follower_ids"].arrayValue {
				if let idW = item.int {
					followerIds.append(idW)
				}
			}
	//		if let commentsW = json["comments"].array {
	//			for item: JSONValue in commentsW {
	//				if let commentsI = item.integer {
	//					comments.append(commentsI)
	//				}
	//			}
	//		}
			var commentIds = [Int]()

			for item in json["comment_ids"].arrayValue {
				if let idW = item.int {
					commentIds.append(idW)
				}
			}
	//		if let createdAtW = json["created_at"].integer {
	//			createdAt = createdAtW
	//		}
			let beforeId = json["before_id"].intValue

			let afterId = json["after_id"].intValue

			let integrationId = json["integration_id"].intValue

			let externalId = json["external_id"].stringValue

			let clNumbers = json["cl_numbers"].stringValue


			return PivotalStory (id: id!, projectId: projectId!, name: name, description: description, storyType: storyType, currentState: currentState, estimate: estimate, requestedById: requestedById, ownedById: ownedById, ownerIds: ownerIds, labelIds: labelIds, followerIds: followerIds, commentIds: commentIds,  beforeId: beforeId, afterId: afterId, integrationId: integrationId, externalId: externalId, clNumbers: clNumbers)
		}

		return nil
	}



	class func deserializeAll(json: JSON) -> [PivotalStory] {

		var items = [PivotalStory]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalStory = deserialize(item) {
					items.append(pivotalStory)
				}
			}
		}

		return items
	}



	var valid: Bool {
		return projectId != nil && projectId != 0 && !name.isEmpty
	}



	func serialize () -> NSMutableDictionary {

		let dict = NSMutableDictionary()

		dict.setObject(Int(projectId!), forKey: PivotalFields.NewStoryFields.ProjectId.rawValue)

		dict.setObject(name, forKey: PivotalFields.NewStoryFields.Name.rawValue)

		dict.setObject(description + TrapState.Shared.deviceDetails, forKey: PivotalFields.NewStoryFields.Description.rawValue)

		dict.setObject(storyType, forKey: PivotalFields.NewStoryFields.StoryType.rawValue)

		if storyType == PivotalStoryTypes.Release.rawValue {
			if let deadline = deadline {
				dict.setObject(Int(deadline.timeIntervalSince1970 * 1000) , forKey: PivotalFields.NewStoryFields.Deadline.rawValue)
			}
		}

		if comments.count > 0 {
			let commentsJson = comments.map({$0.serialize()})
			dict.setObject(commentsJson, forKey: PivotalFields.NewStoryFields.Comments.rawValue)
		}

		if ownerIds.count > 0 {
			dict.setObject(ownerIds, forKey: PivotalFields.NewStoryFields.OwnerIds.rawValue)
		}

		if labelIds.count > 0 {
			dict.setObject(labelIds, forKey: PivotalFields.NewStoryFields.LabelIds.rawValue)
		}

		if followerIds.count > 0 {
			dict.setObject(followerIds, forKey: PivotalFields.NewStoryFields.FollowerIds.rawValue)
		}

		return dict
	}
}