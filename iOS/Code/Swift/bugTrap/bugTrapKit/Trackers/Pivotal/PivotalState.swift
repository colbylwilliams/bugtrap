//
//  PivotalState.swift
//  bugTrap
//
//  Created by Colby L Williams on 10/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class PivotalState : TrackerState {
	
	required init() {
	}
	
	var keychain : Keychain<TrackerType>!
	
	var Authenticated = false
	
	var Projects = [PivotalProject]()
	
	var NewStory = PivotalStory()
	
	var StoryTypes = [ "feature", "bug", "chore", "release" ]
	
	// var Labels = [PivotalLabel]()
	
	var ProjectMemberships = [PivotalProjectMembership]()
	
	var ActiveBugDetail = PivotalDetail.Project.rawValue
	
	
	
	var ActivePivotalDetail : PivotalDetail {
		return PivotalDetail(rawValue: ActiveBugDetail)!
	}
	
	
	
	var IsActiveTopLevelDetail: Bool {
		return ActivePivotalDetail == PivotalDetail.Project
	}
	
	
	
	func Reset() {
		
		NewStory = PivotalStory()
		
		if Projects.count == 1 {
			setProjectByIndex(0)
		}
	}
	
	
	
	var hasProject: Bool {
		return NewStory.projectId != nil
	}
		
	var bugTitle: String {
		get {
			return NewStory.name
		}
		set {
			self.NewStory.name = newValue
		}
	}
	
	var bugDescription: String {
		get {
			return NewStory.description
		}
		set {
			self.NewStory.description = newValue
		}
	}
	
	var bugDueDate: NSDate? {
		get {
			return NewStory.deadline
		}
		set {
			self.NewStory.deadline = newValue
		}
	}
	
	var isValid: Bool {
		return NewStory.valid
	}
	
	
	func sortActiveBugDetailValues ()
	{
		switch ActivePivotalDetail {
		case .Images, .Project, .Name, .Description, .StoryType, .Deadline:
			break
		case .Labels:
			NewStory.project.labels = NewStory.project.labels.sort({ $0.name < $1.name })
//		case .Owners:
		case .Owners, .Followers:
			ProjectMemberships = ProjectMemberships.sort({ $0.person.name < $1.person.name })
		}
	}
	
	
	
	func getValueForDetail(detailIndex: Int) -> String {
		
		let detail = PivotalDetail(rawValue: detailIndex)!
		
		switch detail {
		case .Images:		return ""
		case .Project:		return NewStory.project.name
		case .Name:			return NewStory.name
		case .Description:	return NewStory.description
		case .StoryType:	return NewStory.storyType
		case .Deadline:		return NewStory.deadline != nil ? NewStory.deadline!.string() : ""
		case .Owners:		return NewStory.ownerIds.isEmpty ? "none" : NewStory.ownerIds.count > 1 ? "\(NewStory.ownerIds.count) people" : "\(getPersonNameById(NewStory.ownerIds.first))"
		case .Labels:		return NewStory.labels.isEmpty ? "none" : "\(NewStory.labels.count) " + (NewStory.labels.count > 1 ? "labels" : "label")
		case .Followers:	return NewStory.followerIds.isEmpty ? "none" : NewStory.followerIds.count > 1 ? "\(NewStory.followerIds.count) people" : "\(getPersonNameById(NewStory.followerIds.first))"
		}
	}
	
	
	func getPersonNameById(personId: Int?) -> String {
		if personId == nil {
			return ""
		}
		if let membership = ProjectMemberships.filter({ $0.id == personId }).first {
			return membership.person.name
		} else {
			return ""
		}
	}
	
	
	var ActiveBugDetailTitle: String {
		switch ActivePivotalDetail {
		case .Images:		return ""
		case .Project:		return "Project"
		case .Name:			return ""
		case .Description:	return ""
		case .StoryType:	return "Story Type"
		case .Deadline:		return ""
		case .Owners:		return "Owners"
		case .Labels:		return "Labels"
		case .Followers:	return "Followers"
		}
	}
	
	
	
	var TrackerDetails: Dictionary<Int, BugDetails.DetailType> {
		get {
			return [
				PivotalDetail.Images.rawValue		: .Images,
				PivotalDetail.Project.rawValue		: .Selection		("Project *", "Project"),
				PivotalDetail.Name.rawValue			: .TextField		("Story title *", "Title"),
				PivotalDetail.Description.rawValue	: .TextView			("Description", "Description"),
				PivotalDetail.StoryType.rawValue	: .Selection		("Story Type", "Story Type"),
				PivotalDetail.Deadline.rawValue		: .DateDisplay		("Deadline", "Deadline"),
				PivotalDetail.Owners.rawValue		: .Selection		("Owners", "Owners"),
				PivotalDetail.Labels.rawValue		: .Selection		("Labels", "Labels"),
				PivotalDetail.Followers.rawValue	: .Selection		("Followers", "Followers"),
			]
		}
	}
	
	
	
	var TrackerSections: Int {
		get {
			return TrackerDetails.count
		}
	}
	
	
	
	func getCountForActiveBugDetail() -> Int {
		switch ActivePivotalDetail {
		case .Project:		return Projects.count
		case .StoryType:	return StoryTypes.count
		case .Labels:		return NewStory.project.labels.count
//		case .Owners:		return ProjectMemberships.count
		case .Owners, .Followers:	return ProjectMemberships.count
		default: return 0
		}
	}
	
	
	
	func setProjectByIndex(projectIndex: Int) -> PivotalProject? {
		
		let project = Projects[projectIndex]
		
		if (NewStory.projectId != project.id) {
			NewStory.project = project
			
			return project
		}
		
		return nil
	}
	
	
	
	func getActiveCellType() -> BugCellTypes {
		
		switch ActivePivotalDetail {
		case .Project, .StoryType, .Labels, .Owners, .Followers:
			return .Selection
		case .Deadline:
			return .Date
		default:
			return .Display
		}
	}
	
	
	
	func getActiveTitleDetail() -> Dictionary<DataKeys, String> {
		
		var dict = [DataKeys : String]()
		
		dict[.Title] = ""
		dict[.Detail] = ""
		
		switch ActivePivotalDetail {
			
		case .Project, .StoryType: break
			
		case .Owners, .Followers:
			
			if NewStory.projectId == nil {
				dict[.Title] = "No People"
				dict[.Detail] = "Make sure you have a Project selected"
			}
			
		case .Labels:
			
			if NewStory.projectId == nil {
				dict[.Title] = "No Labels"
				dict[.Detail] = "Make sure you have a Project selected"
			} else if NewStory.project.labels.isEmpty {
				dict[.Title] = "No Labels"
				dict[.Detail] = "The selected Project doesn\'t have any Labels"
			}
			
		default: break
		}
		
		return dict
	}
	
	
	
	func getActiveCellDetails(selectedIndex: Int) -> CellData {
		
		//var detail = ""
		
		let owner = ActivePivotalDetail.isPersonDetail() && NewStory.ownerIds.contains(self.ProjectMemberships[selectedIndex].personId)
		let follower = ActivePivotalDetail.isPersonDetail() && NewStory.followerIds.contains(self.ProjectMemberships[selectedIndex].personId)
		
		let cellData = CellData()
		
		switch ActivePivotalDetail {
			
		case .Project:
			cellData.Set(.Title, value: Projects[selectedIndex].name)
			cellData.Selected = Projects[selectedIndex].id == NewStory.projectId
		case .StoryType:
			cellData.Set(.Title, value: StoryTypes[selectedIndex])
			cellData.Selected = StoryTypes[selectedIndex] == NewStory.storyType
		case .Owners:
			let membership = ProjectMemberships[selectedIndex]
			cellData.CellType = .Person
			cellData.Set(.Title, value: membership.person.name)
			cellData.Set(.Detail, value: follower ? "(follower)" : "")
			cellData.Set(.Auxiliary, value: membership.person.initials)
			cellData.Set(.ImageUrl, value: "")
			cellData.Selected = owner
		case .Followers:
			let membership = ProjectMemberships[selectedIndex]
			cellData.CellType = .Person
			cellData.Set(.Title, value: membership.person.name)
			cellData.Set(.Detail, value: owner ? "(owner)" : "")
			cellData.Set(.Auxiliary, value: membership.person.initials)
			cellData.Set(.ImageUrl, value: "")
			cellData.Selected = follower
		case .Labels:
			cellData.Set(.Title, value: NewStory.project.labels[selectedIndex].name)
			cellData.Set(.Detail, value: "(\(String(NewStory.project.labels[selectedIndex].id)))")
			cellData.Selected = NewStory.labels.contains(self.NewStory.project.labels[selectedIndex])
		default:
			break
		}
		
		return cellData
	}
}