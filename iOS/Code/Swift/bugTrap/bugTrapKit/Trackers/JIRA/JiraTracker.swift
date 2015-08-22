//
//  JiraTracker.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class JiraTracker<TNothing> : TrackerInstance<JiraState, JiraProxy> {
	
	override init(trackerType: TrackerType) {
		super.init(trackerType: trackerType)
		
	}
	
	
	override func postAuthDataFetch() {
		loadProjects { _ in }
		// loadPriorityLevels() { _ in }
	}
	
	
	override func loadDataForActiveDetail(callback: (Result<Bool>) -> ()) {
		
		let detail = JiraDetail(rawValue: self.State!.ActiveBugDetail)!
		
		switch detail {
		case .Project:
			if self.State?.Projects.count == 0 {
				loadProjects() { result in
					switch result {
					case let .Error(error):
						callback(.Error(error))
					case .Value(_):
						callback(.Value(Wrapped(true)))
					}
				}
			} else {
				callback(.Value(Wrapped(true)))
			}
		case .Assignee:
			if self.State?.NewIssue.fields.project.id != nil && self.State?.ProjectPeople.count == 0 {
//				if let projectId = State?.NewIssue.fields.project.id {
					loadPeople(State!.NewIssue.fields.project.key) { result in
						switch result {
						case let .Error(error):
							callback(.Error(error))
						case .Value(_):
							callback(.Value(Wrapped(true)))
						}
					}
//				} else {
//					callback(.Value(Wrapped(true)))
//				}
			}
		default: callback(.Value(Wrapped(false)))
		}
	}
	
	
//	func loadIssueCreateMeta(callback: (Result<JiraIssueCreateMeta>) -> ()) {
//		self.Proxy!.getIssueCreateMeta() { result in
//			switch result {
//			case let .Error(error):
//				Log.error("JiraTracker", error)
//				callback(.Error(error))
//			case let .Value(wrapped):
//				if let meta = wrapped.value {
//					self.State?.Projects = meta.projects
//				}
//				callback(.Value(Wrapped(self.State!.Projects)))
//			}
//		}
//	}

	
	
	func loadProjects(callback: (Result<[JiraProject]>) -> ()) {
		self.Proxy!.getIssueCreateMeta() { result in
			switch result {
			case let .Error(error):
				Log.error("JiraTracker", error)
				callback(.Error(error))
			case let .Value(wrapped):
				if let meta = wrapped.value {
					self.State?.Projects = meta.projects
					self.State?.Reset()
					self.loadPeopleAndSetDefault { _ in }
				}
				callback(.Value(Wrapped(self.State!.Projects)))
			}
		}
	}
	
	
	func loadPeopleAndSetDefault(callback: (Result<Bool>) -> ()) {
		if let _ = State?.NewIssue.fields.project.id {
			loadPeople(State!.NewIssue.fields.project.key) { result in
				switch result {
				case let .Error(error):
					callback(.Error(error))
				case let .Value(wrapped):
					if let people = wrapped.value {
						let assigneeKey = Settings.getString(JiraDetail.Assignee.settingsKey)
						if let assignee = people.filter({ !$0.key.isEmpty && $0.key == assigneeKey }).first {
							self.State!.NewIssue.fields.assignee = assignee
						}
					}
					callback(.Value(Wrapped(true)))
				}
			}
		}
	}
	
	
//	func loadPriorityLevels(callback: (Result<[JiraPriority]>) -> ()) {
//		self.Proxy!.getPriorityLevels() { result in
//			switch result {
//			case let .Error(error):
//				Log.error("JiraTracker", error)
//				callback(.Error(error))
//			case let .Value(wrapped):
//				if let levels = wrapped.value {
//					self.State?.PriorityLevels = levels
//				}
//				callback(.Value(Wrapped(self.State!.PriorityLevels)))
//			}
//		}
//	}
	
	
	
	func loadPeople(projectKey: String, callback: (Result<[JiraUser]>) -> ()) {
		self.Proxy!.getPeople(projectKey) { result in
			switch result {
			case let .Error(error):
				Log.error("JiraTracker", error)
				callback(.Error(error))
			case let .Value(wrapped):
				if let people = wrapped.value {
					self.State?.ProjectPeople = people
				}
				callback(.Value(Wrapped(self.State!.ProjectPeople)))
			}
		}
	}
	
	
	
	func setProjectByIndex(index: Int) {
		if let project = State!.setProjectByIndex(index) {
//			if let projectKey = project.key {
				Proxy!.getPeople(project.key) { result in
					switch result {
					case let .Error(error):
						Log.error("JiraTracker", error)
					case let .Value(wrapped):
						if let people = wrapped.value {
							self.State?.ProjectPeople = people
						}
					}
				}
//			}
		}
	}
	
	
	
	override func updateIssueFromSelection(selectedIndex: Int) -> Bool {
		
		let detail = JiraDetail(rawValue: self.State!.ActiveBugDetail)!
		
		switch detail {
			
		case .Project:	setProjectByIndex(selectedIndex)
			
		case .IssueType:
			let issueType = State!.NewIssue.fields.project.issueTypes[selectedIndex]
			State!.NewIssue.fields.issueType = issueType
			if let issueTypeId = issueType.id {
				Settings.setValue(issueTypeId, forKey: detail.settingsKey)
			}
			
		case .Priority:
			let priority = State!.NewIssue.fields.issueType.fields.priority.allowedValues[selectedIndex]
			State!.NewIssue.fields.priority = priority
			if let priorityId = priority.id {
				Settings.setValue(priorityId, forKey: detail.settingsKey)
			}

		case .Assignee:
			let assignee = State!.ProjectPeople[selectedIndex]
			State!.NewIssue.fields.assignee = assignee
			Settings.setValue(assignee.key, forKey: detail.settingsKey)
			
//		case .Labels:
//			
//			let tag = State!.NewIssue.project.tags[selectedIndex]
//			
//			if let index = find(State!.NewIssue.tags, tag) {
//				State!.NewIssue.tags.removeAtIndex(index)
//			} else {
//				State!.NewIssue.tags.append(tag)
//			}
			
		default: break
		}
		
		if detail == JiraDetail.Labels {
			return true
		}
		
		return false
	}
	
	
	
	override func createIssue(callback: (Result<Bool>) -> ()) {
		
		Proxy?.createIssueForProject(State!.NewIssue, project: State!.NewIssue.fields.project) { result in
			switch result {
			case let .Error(error):
				Log.error("JiraTracker", error)
				callback(.Error(error))
			case .Value(_):
				Analytics.Shared.issueSent(self.type.googleAnalyticsMetricIndex, trackerName: self.type.rawValue)
				Analytics.Shared.activity(self.type.activityType, completed: true)
				callback(.Value(Wrapped(true)))
			}
		}
	}
	
	
}