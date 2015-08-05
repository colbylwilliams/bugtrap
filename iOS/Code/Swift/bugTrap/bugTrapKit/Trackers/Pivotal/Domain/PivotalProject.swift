//
//  PivotalProject.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalProject : JsonSerializable {

	var id: Int? = 0 								// int
	var name = "" 							// string[50]
	var version = 0 						// int
	var iterationLength = 0 				// int
	var weekStartDay = "" 					// enumerated string
	var pointScale = "" 					// string[255]
	var pointScaleIsCustom = false 			// boolean
	var bugsAndChoresAreEstimatable = false // boolean
	var automaticPlanning = false 			// boolean
	var enableFollowing = false 			// boolean
	var enableTasks = false 				// boolean
	var startDate : NSDate? 				// date
	var timeZone = "" 						// time_zone
	var velocityAveragedOver = 0 			// int
	var shownIterationsStartTime : NSDate? 	// datetime
	var startTime : NSDate? 				// datetime
	var numberOfDoneIterationsToShow = 0 	// int
	var hasGoogleDomain = false 			// boolean
	var description = "" 					// string[140]
	var profileContent = "" 				// string[65535]
	var enableIncomingEmails = false 		// boolean
	var initialVelocity = 0 				// int
//	var public = false 						// boolean
	var atomEnabled = false 				// boolean
	var currentVelocity = 0 				// int
	var currentVolatility = 0				// float
	var accountId = 0 						// int
	var storyIds = [Int]() 					// List[int]
	var epicIds = [Int]() 					// List[int]
	var membershipIds = [Int]() 			// List[int]
	var labelIds = [Int]() 					// List[int]
	var integrationIds = [Int]() 			// List[int]
	var iterationOverrideNumbers = [Int]() 	// List[int]
	var createdAt : NSDate? 				// datetime
	var updatedAt : NSDate? 				// datetime
	var kind = "" 							// string

	var labels: [PivotalLabel] = [PivotalLabel]() {
		willSet {
			labelIds = newValue.map({$0.id})
		}
	}

	init () {

	}

	init(id: Int, name: String, version: Int, iterationLength: Int, weekStartDay: String, pointScale: String, pointScaleIsCustom: Bool, bugsAndChoresAreEstimatable: Bool, automaticPlanning: Bool, enableFollowing: Bool, enableTasks: Bool, velocityAveragedOver: Int, numberOfDoneIterationsToShow: Int, hasGoogleDomain: Bool, description: String, profileContent: String, enableIncomingEmails: Bool, initialVelocity: Int, atomEnabled: Bool, currentVelocity: Int, currentVolatility: Int, accountId: Int, storyIds: [Int]?, epicIds: [Int]?, membershipIds: [Int]?, labelIds: [Int]?, integrationIds: [Int]?, iterationOverrideNumbers: [Int]?, kind: String) {

		self.id = id
		self.name = name
		self.version = version
		self.iterationLength = iterationLength
		self.weekStartDay = weekStartDay
		self.pointScale = pointScale
		self.pointScaleIsCustom = pointScaleIsCustom
		self.bugsAndChoresAreEstimatable = bugsAndChoresAreEstimatable
		self.automaticPlanning = automaticPlanning
		self.enableFollowing = enableFollowing
		self.enableTasks = enableTasks
		self.velocityAveragedOver = velocityAveragedOver
		self.numberOfDoneIterationsToShow = numberOfDoneIterationsToShow
		self.hasGoogleDomain = hasGoogleDomain
		self.description = description
		self.profileContent = profileContent
		self.enableIncomingEmails = enableIncomingEmails
		self.initialVelocity = initialVelocity
	//	self.public = public
		self.atomEnabled = atomEnabled
		self.currentVelocity = currentVelocity
		self.currentVolatility = currentVolatility
		self.accountId = accountId

		if let storyIdsArray = storyIds {
			self.storyIds = storyIdsArray
		}
		if let epicIdsArray = epicIds {
			self.epicIds = epicIdsArray
		}
		if let membershipIdsArray = membershipIds {
			self.membershipIds = membershipIdsArray
		}
		if let labelIdsArray = labelIds {
			self.labelIds = labelIdsArray
		}
		if let integrationIdsArray = integrationIds {
			self.integrationIds = integrationIdsArray
		}
		if let iterationOverrideNumbersArray = iterationOverrideNumbers {
			self.iterationOverrideNumbers = iterationOverrideNumbersArray
		}

		self.kind = kind
	}



	class func deserialize (json: JSON) -> PivotalProject? {

		if let id = json["id"].int {


			// var id = 0 								// int
			//	var public = false 						// boolean


			let name = json["name"].stringValue

			let version = json["version"].intValue

			let iterationLength = json["iteration_length"].intValue

			let weekStartDay = json["week_start_day"].stringValue

			let pointScale = json["point_scale"].stringValue

			let pointScaleIsCustom = json["point_scale_is_custom"].boolValue

			let bugsAndChoresAreEstimatable = json["bugs_and_chores_are_estimatable"].boolValue

			let automaticPlanning = json["automatic_planning"].boolValue

			let enableFollowing = json["enable_following"].boolValue

			let enableTasks = json["enable_tasks"].boolValue

			// if let startDateW = json["start_date"] date {
			// 	startDate = startDateW
			// }

			// if let timeZoneW = json["time_zone"].string {
			// 	timeZone = timeZoneW
			// }

			let velocityAveragedOver = json["velocity_averaged_over"].intValue

			// if let shownIterationsStartTimeW = json["shown_iterations_start_time"] datetime {
			// 	shownIterationsStartTime = shownIterationsStartTimeW
			// }

			// if let startTimeW = json["start_time"] datetime {
			// 	startTime = startTimeW
			// }

			let numberOfDoneIterationsToShow = json["number_of_done_iterations_to_show"].intValue

			let hasGoogleDomain = json["has_google_domain"].boolValue

			let description = json["description"].stringValue

			let profileContent = json["profile_content"].stringValue

			let enableIncomingEmails = json["enable_incoming_emails"].boolValue

			let initialVelocity = json["initial_velocity"].intValue

			// if let publicW = json["public"].bool {
			//	public = publicW
			// }

			let atomEnabled = json["atom_enabled"].boolValue

			let currentVelocity = json["current_velocity"].intValue

			let currentVolatility = json["current_volatility"].intValue

			let accountId = json["account_id"].intValue

			var storyIds = [Int]()

			for item in json["story_ids"].arrayValue {
				if let idW = item.int {
					storyIds.append(idW)
				}
			}

			var epicIds = [Int]()

			for item in json["epic_ids"].arrayValue {
				if let idW = item.int {
					epicIds.append(idW)
				}
			}

			var membershipIds = [Int]()

			for item in json["membership_ids"].arrayValue {
				if let idW = item.int {
					membershipIds.append(idW)
				}
			}

			var labelIds = [Int]()

			for item in json["label_ids"].arrayValue {
				if let idW = item.int {
					labelIds.append(idW)
				}
			}

			var integrationIds = [Int]()

			for item in json["integration_ids"].arrayValue {
				if let idW = item.int {
					integrationIds.append(idW)
				}
			}

			var iterationOverrideNumbers = [Int]()

			for item in json["iteration_override_numbers"].arrayValue {
				if let idW = item.int {
					iterationOverrideNumbers.append(idW)
				}
			}

			// if let createdAtW = json["created_at"] datetime {
			// 	createdAt = createdAtW
			// }

			// if let updatedAtW = json["updated_at"] datetime {
			// 	updatedAt = updatedAtW
			// }

			let kind = json["kind"].stringValue

			return PivotalProject(id: id, name: name, version: version, iterationLength: iterationLength, weekStartDay: weekStartDay, pointScale: pointScale, pointScaleIsCustom: pointScaleIsCustom, bugsAndChoresAreEstimatable: bugsAndChoresAreEstimatable, automaticPlanning: automaticPlanning, enableFollowing: enableFollowing, enableTasks: enableTasks, velocityAveragedOver: velocityAveragedOver, numberOfDoneIterationsToShow: numberOfDoneIterationsToShow, hasGoogleDomain: hasGoogleDomain, description: description, profileContent: profileContent, enableIncomingEmails: enableIncomingEmails, initialVelocity: initialVelocity, atomEnabled: atomEnabled, currentVelocity: currentVelocity, currentVolatility: currentVolatility, accountId: accountId, storyIds: storyIds, epicIds: epicIds, membershipIds: membershipIds, labelIds: labelIds, integrationIds: integrationIds, iterationOverrideNumbers: iterationOverrideNumbers, kind: kind)
		}

		return nil
	}


	class func deserializeAll(json: JSON) -> [PivotalProject] {

		var items = [PivotalProject]()

		if let jsonArray = json.array {
			for item: JSON in jsonArray {
				if let pivotalProject = deserialize(item) {
					items.append(pivotalProject)
				}
			}
		}

		return items
	}


	func serialize () -> NSMutableDictionary {
		return NSMutableDictionary()
	}
}