//
//  JiraState.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/29/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class JiraState : TrackerState {

	required init() {
	}

	let keychain : Keychain<TrackerType>!

	var Authenticated = false

	var Projects = [JiraProject]()

	var NewIssue = JiraIssue()

	// var PriorityLevels = [JiraPriority]()

	var ProjectPeople = [JiraUser]()

	var ActiveBugDetail = JiraDetail.Project.rawValue



	var ActiveJiraDetail : JiraDetail {
		return JiraDetail(rawValue: ActiveBugDetail)!
	}



	var IsActiveTopLevelDetail: Bool {
		return ActiveJiraDetail == JiraDetail.Project
	}



	func Reset() {

		NewIssue = newJiraIssue

//		if Projects.count == 1 {
//			setProjectByIndex(0)
//		}
	}


	var hasProject : Bool {
		return NewIssue.fields.project.id != nil
	}


	var bugTitle: String {
		get {
			return NewIssue.fields.summary
		}
		set {
			self.NewIssue.fields.summary = newValue
		}
	}


	var bugDescription: String {
		get {
			return NewIssue.fields.description
		}
		set {
			self.NewIssue.fields.description = newValue
		}
	}


	var bugDueDate: NSDate? {
		get {
			// return NewIssue.fields.dueDate
			return nil
		}
		set {
			// self.NewIssue.fields.dueDate = newValue
		}
	}


	var isValid: Bool {
		return NewIssue.valid
	}

	var newJiraIssue: JiraIssue {
		
		let issue = JiraIssue()
		
		if !Projects.isEmpty {
			
			let projectId = Settings.getInt(JiraDetail.Project.settingsKey)
			
			if let project = Projects.filter({ $0.id != nil && $0.id! == projectId }).first {
					
				issue.fields.project = project
				
				let issueTypeId = Settings.getInt(JiraDetail.IssueType.settingsKey)
					
				if let issueType = project.issueTypes.filter({ $0.id != nil && $0.id! == issueTypeId }).first {
						
					issue.fields.issueType = issueType
							
					let priorityId = Settings.getInt(JiraDetail.Priority.settingsKey)
					
					if let priority = issueType.fields.priority.allowedValues.filter({ $0.id != nil && $0.id! == priorityId }).first {
								
						issue.fields.priority = priority
					}
				}
			}
			
			if !ProjectPeople.isEmpty {
				
				let assigneeKey = Settings.getString(JiraDetail.Assignee.settingsKey)
				
				if let assignee = ProjectPeople.filter({ !$0.key.isEmpty && $0.key == assigneeKey }).first {
					
					issue.fields.assignee = assignee
				}
			}
		}
		
		return issue
	}
	
	

	func sortActiveBugDetailValues ()
	{
		switch ActiveJiraDetail {
		case .Project:
			Projects = Projects.sort({ $0.name < $1.name })
		case .IssueType:
			NewIssue.fields.project.issueTypes = NewIssue.fields.project.issueTypes.sort({ $0.name < $1.name })
		case .Priority:
			NewIssue.fields.issueType.fields.priority.allowedValues = NewIssue.fields.issueType.fields.priority.allowedValues.sort({ $0.id < $1.id })
		case .Assignee:
			ProjectPeople = ProjectPeople.sort({ $0.name < $1.name })
//		case .Labels:
//			NewIssue.fields.project.labels = sorted(NewIssue.fields.project.labels, { $0.name < $1.name })
		default: break
		}
	}



	func getValueForDetail(detailIndex: Int) -> String {

		let detail = JiraDetail(rawValue: detailIndex)!

		switch detail {
		case .Images:		return ""
		case .Project:		return NewIssue.fields.project.name
		case .IssueType:	return NewIssue.fields.issueType.name
		case .Summary:		return NewIssue.fields.summary
		case .Description:	return NewIssue.fields.description
		case .Priority:		return NewIssue.fields.priority.name
		case .Assignee:		return NewIssue.fields.assignee.displayName
		default:			return ""
//		case .DueDate:		return NewIssue.fields.dueDate != nil ? NewIssue.fields.dueDate!.string() : ""
//		case .Labels:		return NewIssue.fields.labels.isEmpty ? "none" : "\(NewIssue.fields.labels.count) " + (NewIssue.fields.labels.count > 1 ? "tags" : "tag")
		}
	}



	var ActiveBugDetailTitle: String {
		switch ActiveJiraDetail {
		case .Images:		return ""
		case .Project:		return "Project"
		case .IssueType:	return "Issue Type"
		case .Summary:		return ""
		case .Description:	return ""
		case .Priority:		return "Priority Level"
		case .Assignee:		return "Assignee"
//		case .DueDate:		return ""
//		case .Labels:		return "Labels"
		default:			return ""
		}
	}


	var TrackerDetails: Dictionary<Int, BugDetails.DetailType> {
		get {
			return [
				JiraDetail.Images.rawValue		: .Images,
				JiraDetail.Project.rawValue		: .Selection		("Project *", "Project"),
				JiraDetail.Summary.rawValue		: .TextField		("Summary of Issue *", "Summary"),
				JiraDetail.IssueType.rawValue	: .Selection		("Issue Type *", "Type"),
				JiraDetail.Description.rawValue	: .TextView			("Description of Issue *", "Description"),
				JiraDetail.Priority.rawValue	: .Selection		("Priority *", "Priority"),
				JiraDetail.Assignee.rawValue	: .Selection		("Assignee", "Assignee"),
//				JiraDetail.DueDate.rawValue		: .DateDisplay		("Due Date", "Due Date"),
//				JiraDetail.Labels.rawValue		: .Selection		("Labels", "Labels"),
			]
		}
	}



	var TrackerSections: Int {
		get {
			return TrackerDetails.count
		}
	}



	func getCountForActiveBugDetail() -> Int {
		switch ActiveJiraDetail {
		case .Project:	return Projects.count
		case .IssueType:return NewIssue.fields.project.issueTypes.count
		case .Priority: return NewIssue.fields.issueType.fields.priority.allowedValues.count
		case .Assignee:	return ProjectPeople.count
//		case .Labels:	return NewIssue
		default: return 0
		}
	}



	func setProjectByIndex(projectIndex: Int) -> JiraProject? {

		let project = Projects[projectIndex]

		if (NewIssue.fields.project.id != project.id) {
			NewIssue.fields.project = project

			if let projectId = project.id {
				Settings.setValue(projectId, forKey: JiraDetail.Project.settingsKey)
			}
			
			return project
		}

		return nil
	}



	func getActiveCellType() -> BugCellTypes {

		switch ActiveJiraDetail {
		case .Project, .IssueType, .Priority, .Assignee, .Labels:
			return .Selection
		case .DueDate:
			return .Date
		default:
			return .Display
		}
	}



	func getActiveTitleDetail() -> Dictionary<DataKeys, String> {

		var dict = [DataKeys : String]()

		dict[.Title] = ""
		dict[.Detail] = ""

		switch ActiveJiraDetail {

		case .IssueType:
			if NewIssue.fields.project.id == nil {
				dict[.Title] = "No Issue Types"
				dict[.Detail] = "Make sure you have a Project selected"
			} else if NewIssue.fields.project.issueTypes.count == 0 {
				dict[.Title] = "No Issue Types"
				dict[.Detail] = "The selected Project doesn\'t have any Issue Types"
			}
		case .Priority:
			if NewIssue.fields.project.id == nil {
				dict[.Title] = "No Priorities"
				dict[.Detail] = "Make sure you have a Project selected"
			} else if NewIssue.fields.issueType.id == nil {
				dict[.Title] = "No Priorities"
				dict[.Detail] = "Make sure you have a Issue Type selected"
			} else if NewIssue.fields.issueType.fields.priority.allowedValues.count == 0 {
				dict[.Title] = "No Priorities"
				dict[.Detail] = "This Issue Type has no Priorities"
			}
		case .Assignee:
			if NewIssue.fields.project.id == nil {
				dict[.Title] = "No People"
				dict[.Detail] = "Make sure you have a Project selected"
			} else if ProjectPeople.count == 0 {
				dict[.Title] = "No People"
				dict[.Detail] = "Make sure you have a Project selected"
			}
		case .Labels:
			if NewIssue.fields.project.id == nil {
				dict[.Title] = "No Labels"
				dict[.Detail] = "Make sure you have a Project selected"
			}
//			else if ProjectPeople.count == 0 {
//				dict[DataKeys.Title] = "No Labels"
//				dict[DataKeys.Detail] = "Make sure you have a Project selected"
//			}
		default: break
		}

		return dict
	}



	func getActiveCellDetails(selectedIndex: Int) -> CellData {

//		var detail = ""

		let assignee = ActiveJiraDetail.isPersonDetail() && NewIssue.fields.assignee.key == ProjectPeople[selectedIndex].key

		let cellData = CellData()

		switch ActiveJiraDetail {

		case .Project:

			let project = Projects[selectedIndex]

//			cellData.CellType = .IconSelect
			cellData.Set(.Title, value: project.name)
//			cellData.Set(.ImageUrl, value: project.avatarUrls.size32)
			cellData.Selected = Projects[selectedIndex].id == NewIssue.fields.project.id

		case .IssueType:

			let issueType = NewIssue.fields.project.issueTypes[selectedIndex]

//			cellData.CellType = .IconSelect
			cellData.Set(.Title, value: issueType.name)
//			cellData.Set(.ImageUrl, value: issueType.iconUrl)
			cellData.Selected = issueType.id == NewIssue.fields.issueType.id

		case .Priority:

			let priority = NewIssue.fields.issueType.fields.priority.allowedValues[selectedIndex]

//			cellData.CellType = .IconSelect
			cellData.Set(.Title, value: priority.name)
//			cellData.Set(.ImageUrl, value: priority.iconUrl)
			cellData.Selected = priority.id == NewIssue.fields.priority.id

		case .Assignee:

			let person = ProjectPeople[selectedIndex]

//			cellData.CellType = .IconSelect
			cellData.Set(.Title, value: person.displayName)
			cellData.Set(.Detail, value: assignee ? "(assignee)" : "")
//			cellData.Set(.Auxiliary, value: "")
//			cellData.Set(.ImageUrl, value: person.avatarUrls.size32)
			cellData.Selected = assignee

//		case .Labels:
//			cellData.Set(DataKeys.Title, value: NewIssue.project.tags[selectedIndex].value)
//			cellData.Set(DataKeys.Detail, value: "(\(String(NewIssue.project.tags[selectedIndex].numberOfIssues)))")
//			cellData.Selected = contains(NewIssue.tags, self.NewIssue.project.tags[selectedIndex])
		default:
			break
		}

		return cellData
	}
}