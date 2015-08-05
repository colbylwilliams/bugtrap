//
//  DoneDoneTracker.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class DoneDoneTracker<TNothing> : TrackerInstance<DoneDoneState, DoneDoneProxy> {
    
    override init(trackerType: TrackerType) {
        super.init(trackerType: trackerType)
		 
    }
	

	override func postAuthDataFetch() {
		loadProjects() { _ in }
		loadPriorityLevels() { _ in }
	}
	
	
    override func loadDataForActiveDetail(callback: (Result<Bool>) -> ()) {
		
		let detail = DoneDoneDetail(rawValue: self.State!.ActiveBugDetail)!
		
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
        case .Fixer, .Tester, .Notify:
            if self.State?.ProjectPeople.count == 0 {
				if let projectId = State?.NewIssue.project.id {
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
	
	
	
    func loadProjects(callback: (Result<[DoneDoneProject]>) -> ()) {
		self.Proxy!.getProjects() { result in
            switch result {
            case let .Error(error):
                Log.error("DoneDoneTracker", error)
                callback(.Error(error))
            case let .Value(wrapped):
				if let projects = wrapped.value {
					self.State?.Projects = projects
				}
                callback(.Value(Wrapped(self.State!.Projects)))
            }
        }
    }
	
	
	
    func loadPriorityLevels(callback: (Result<[DoneDoneSimpleItem]>) -> ()) {
        self.Proxy!.getPriorityLevels() { result in
            switch result {
            case let .Error(error):
                Log.error("DoneDoneTracker", error)
                callback(.Error(error))
            case let .Value(wrapped):
				if let levels = wrapped.value {
					self.State?.PriorityLevels = levels
				}
                callback(.Value(Wrapped(self.State!.PriorityLevels)))
            }
        }
    }

	
	
    func loadPeople(projectId: Int, callback: (Result<[DoneDonePerson]>) -> ()) {
        self.Proxy!.getPeople(projectId) { result in
            switch result {
            case let .Error(error):
                Log.error("DoneDoneTracker", error)
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
            if let projectId = project.id {
                Proxy!.getPeople(projectId) { result in
                    switch result {
                    case let .Error(error):
                        Log.error("DoneDoneTracker", error)
                    case let .Value(wrapped):
						if let people = wrapped.value {
							self.State?.ProjectPeople = people
						}
                    }
                }
            }
        }
    }
	
	
	
    override func updateIssueFromSelection(selectedIndex: Int) -> Bool {
		
		let detail = DoneDoneDetail(rawValue: self.State!.ActiveBugDetail)!
		
        switch detail {
			
        case .Project:	setProjectByIndex(selectedIndex)
            
        case .Priority:	State!.NewIssue.priority = State!.PriorityLevels[selectedIndex]
            
        case .Fixer:	State!.NewIssue.fixer = State!.ProjectPeople[selectedIndex]
            
        case .Tester:	State!.NewIssue.tester = State!.ProjectPeople[selectedIndex]
            
        case .Tags:

			let tag = State!.NewIssue.project.tags[selectedIndex]
			
			if let index = State!.NewIssue.tags.indexOf(tag) {
				State!.NewIssue.tags.removeAtIndex(index)
			} else {
				State!.NewIssue.tags.append(tag)
			}
            
        case .Notify:
			
			let user = State!.ProjectPeople[selectedIndex]
			
			if let index = State!.NewIssue.ccdUsers.indexOf(user) {
				State!.NewIssue.ccdUsers.removeAtIndex(index)
			} else {
				State!.NewIssue.ccdUsers.append(user)
			}
			
        default: break
        }
        
        if detail == DoneDoneDetail.Tags || detail == DoneDoneDetail.Notify {
            return true
        }
        
        return false
    }
	
	
	
    override func createIssue(callback: (Result<Bool>) -> ()) {
        
        Proxy?.createIssueForProject(State!.NewIssue, project: State!.NewIssue.project) { result in
            switch result {
            case let .Error(error):
                Log.error("DoneDoneTracker", error)
                callback(.Error(error))
            case let .Value(wrapped):
				Analytics.Shared.issueSent(self.type.googleAnalyticsMetricIndex, trackerName: self.type.rawValue)
				Analytics.Shared.activity(self.type.activityType, completed: true)
                callback(.Value(Wrapped(true)))
            }
        }
    }
}