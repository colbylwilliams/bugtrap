//
//  PivotalTracker.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class PivotalTracker<TNothing> : TrackerInstance<PivotalState, PivotalProxy> {
	
	override init(trackerType: TrackerType) {
		super.init(trackerType: trackerType)
		
	}

	override func postAuthDataFetch() {
		loadProjects() { _ in }
	}
	
	override func loadDataForActiveDetail(callback: (Result<Bool>) -> ()) {
		
		let detail = PivotalDetail(rawValue: self.State!.ActiveBugDetail)!
		
		switch detail {
		case .Project:
			if self.State?.Projects.count == 0 {
				loadProjects() { result in
					switch result {
					case let .Error(error):
						callback(.Error(error))
					case let .Value(wrapped):
						callback(.Value(Wrapped(true)))
					}
				}
			} else {
				callback(.Value(Wrapped(true)))
			}
		case .Owners, .Followers:
			if self.State?.ProjectMemberships.count == 0 {
				if let projectId = State?.NewStory.projectId {
					loadPeople(projectId) { result in
						switch result {
						case let .Error(error):
							callback(.Error(error))
						case let .Value(wrapped):
							callback(.Value(Wrapped(true)))
						}
					}
				} else {
					callback(.Value(Wrapped(true)))
				}
			}
		default: callback(.Value(Wrapped(false)))
		}
	}
	
	
	
	func loadProjects(callback: (Result<[PivotalProject]>) -> ()) {
		self.Proxy!.getProjects() { result in
			switch result {
			case let .Error(error):
				Log.error("PivotalTracker", error)
				callback(.Error(error))
			case let .Value(wrapped):
				if let projects = wrapped.value {
					self.State?.Projects = projects
				}
				callback(.Value(Wrapped(self.State!.Projects)))
			}
		}
	}
	
	
	func loadPeople(projectId: Int, callback: (Result<[PivotalProjectMembership]>) -> ()) {
		self.Proxy!.getPeople(projectId) { result in
			switch result {
			case let .Error(error):
				Log.error("PivotalTracker", error)
				callback(.Error(error))
			case let .Value(wrapped):
				if let people = wrapped.value {
					self.State?.ProjectMemberships = people
				}
				callback(.Value(Wrapped(self.State!.ProjectMemberships)))
			}
		}
	}
	
	func setProjectByIndex(index: Int) {
		if let project = State!.setProjectByIndex(index) {
			if let projectId = project.id {
				Proxy!.getPeople(projectId) { result in
					switch result {
					case let .Error(error):
						Log.error("PivotalTracker", error)
					case let .Value(wrapped):
						if let people = wrapped.value {
							self.State?.ProjectMemberships = people
						}
					}
				}
				Proxy!.getProjectLabels(projectId) { result in
					switch result {
					case let .Error(error):
						Log.error("PivotalTracker", error)
					case let .Value(wrapped):
						if let labels = wrapped.value {
							project.labels = labels
						}
					}
				}
			}
		}
	}
	
	override func updateIssueFromSelection(selectedIndex: Int) -> Bool {
		
		let detail = PivotalDetail(rawValue: self.State!.ActiveBugDetail)!
		
		switch detail {
			
		case .Project:
			setProjectByIndex(selectedIndex)
			
		case .StoryType:
			State!.NewStory.storyType = State!.StoryTypes[selectedIndex]
			
		case .Owners:
			
			let membership = State!.ProjectMemberships[selectedIndex]
			
			if let index = State!.NewStory.ownerIds.indexOf(membership.personId) {
				State!.NewStory.ownerIds.removeAtIndex(index)
			} else {
				State!.NewStory.ownerIds.append(membership.personId)
			}
			
		case .Labels:
			
			let label = State!.NewStory.project.labels[selectedIndex]
			
			if let index = State!.NewStory.labels.indexOf(label) {
				State!.NewStory.labels.removeAtIndex(index)
			} else {
				State!.NewStory.labels.append(label)
			}
			
		case .Followers:
			
			let membership = State!.ProjectMemberships[selectedIndex]

			if let index = State!.NewStory.followerIds.indexOf(membership.personId) {
				State!.NewStory.followerIds.removeAtIndex(index)
			} else {
				State!.NewStory.followerIds.append(membership.personId)
			}
			
		default: break
		}
		

//		return (detail == PivotalDetail.Labels || detail == PivotalDetail.Owners)
		return (detail == PivotalDetail.Labels || detail == PivotalDetail.Followers || detail == PivotalDetail.Owners)
	}
	
	override func createIssue(callback: (Result<Bool>) -> ()) {
		
		Log.info("PivotalTracker", "createIssue")

		Proxy?.createIssueForProject(State!.NewStory, project: State!.NewStory.project) { result in
			switch result {
			case let .Error(error):
				Log.error("PivotalTracker", error)
				callback(.Error(error))
			case let .Value(wrapped):
				Analytics.Shared.issueSent(self.type.googleAnalyticsMetricIndex, trackerName: self.type.rawValue)
				Analytics.Shared.activity(self.type.activityType, completed: true)
				callback(.Value(Wrapped(true)))
			}
		}
	}
}

