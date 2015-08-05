//
//  DoneDoneState.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneState : TrackerState {
    
    required init() {
    }
        
    let keychain : Keychain<TrackerType>!
	
	var Authenticated = false
	
    var Projects = [DoneDoneProject]()
	
	var NewIssue = DoneDoneIssue()
	
	var PriorityLevels = [DoneDoneSimpleItem]()
	
	var ProjectPeople = [DoneDonePerson]()
	
	var ActiveBugDetail = DoneDoneDetail.Project.rawValue
	
	
	
    var ActiveDoneDoneDetail : DoneDoneDetail {
		return DoneDoneDetail(rawValue: ActiveBugDetail)!
    }
	
	
	
    var IsActiveTopLevelDetail: Bool {
		return ActiveDoneDoneDetail == DoneDoneDetail.Project
    }
	
	
	
	func Reset() {
		
		NewIssue = DoneDoneIssue()
		
		if Projects.count == 1 {
			setProjectByIndex(0)
		}
	}
	
	
	var hasProject : Bool {
		return NewIssue.project.id != nil
	}
	
	
	var bugTitle: String {
		get {
			return NewIssue.title
		}
		set {
			self.NewIssue.title = newValue
		}
	}
	
	
	var bugDescription: String {
		get {
			return NewIssue.description
		}
		set {
			self.NewIssue.description = newValue
		}
	}

	
	var bugDueDate: NSDate? {
		get {
			return NewIssue.dueDate
		}
		set {
			self.NewIssue.dueDate = newValue
		}
	}

	
	var isValid: Bool {
		return NewIssue.valid
	}

	
	func sortActiveBugDetailValues ()
	{
		switch ActiveDoneDoneDetail {
		case .Images, .Title, .Description, .DueDate:
			break
		case .Project:
			Projects = Projects.sort({ $0.value < $1.value })
		case .Priority:
			PriorityLevels = PriorityLevels.sort({ $0.id < $1.id })
		case .Fixer, .Tester, .Notify:
			ProjectPeople = ProjectPeople.sort({ $0.value < $1.value })
		case .Tags:
			NewIssue.project.tags = NewIssue.project.tags.sort({ $0.value < $1.value })
		}
	}
	
	
	
	func getValueForDetail(detailIndex: Int) -> String {
        
        let detail = DoneDoneDetail(rawValue: detailIndex)!
        
		switch detail {
		case .Images:		return ""
		case .Project:		return NewIssue.project.value
		case .Title:		return NewIssue.value
		case .Description:	return NewIssue.description
		case .Priority:		return NewIssue.priority.value
		case .Fixer:		return NewIssue.fixer.value
		case .Tester:		return NewIssue.tester.value
		case .DueDate:		return NewIssue.dueDate != nil ? NewIssue.dueDate!.string() : ""
		case .Tags:			return NewIssue.tags.isEmpty ? "none" : "\(NewIssue.tags.count) " + (NewIssue.tags.count > 1 ? "tags" : "tag")
		case .Notify:		return NewIssue.ccdUsers.isEmpty ? "none" : NewIssue.ccdUsers.count > 1 ? "\(NewIssue.ccdUsers.count) people" : NewIssue.ccdUsers[0].value
		}
	}
	
	
	
	var ActiveBugDetailTitle: String {
		switch ActiveDoneDoneDetail {
		case .Images:		return ""
		case .Project:		return "Project"
		case .Title:		return ""
		case .Description:	return ""
		case .Priority:		return "Priority Level"
		case .Fixer:		return "Fixer"
		case .Tester:		return "Tester"
		case .DueDate:		return ""
		case .Tags:			return "Tags"
		case .Notify:		return "Watchers"
		}
	}
	
	
	
    var TrackerDetails: Dictionary<Int, BugDetails.DetailType> {
        get {
            return [
				DoneDoneDetail.Images.rawValue		: .Images,
				DoneDoneDetail.Project.rawValue		: .Selection		("Project *", "Project"),
				DoneDoneDetail.Title.rawValue		: .TextField		("Title of Issue *", "Title"),
				DoneDoneDetail.Description.rawValue	: .TextView			("Description of Issue *", "Description"),
				DoneDoneDetail.Priority.rawValue	: .Selection		("Priority *", "Priority"),
				DoneDoneDetail.Fixer.rawValue		: .Selection		("Who Will Fix the Issue?", "Fixer"),
				DoneDoneDetail.Tester.rawValue		: .Selection		("Who Will Verify the Fix?", "Tester"),
				DoneDoneDetail.DueDate.rawValue		: .DateDisplay		("Due Date", "Due Date"),
				DoneDoneDetail.Tags.rawValue		: .Selection		("Tags", "Tags"),
				DoneDoneDetail.Notify.rawValue		: .Selection		("Notify People of Updates", "Notify")
            ]
        }
    }
	
	
	
    var TrackerSections: Int {
        get {
            return TrackerDetails.count
        }
    }
	
	
	
    func getCountForActiveBugDetail() -> Int {
        switch ActiveDoneDoneDetail {
        case .Project:	return Projects.count
        case .Priority: return PriorityLevels.count
        case .Tags:		return NewIssue.project.tags.count
        case .Fixer, .Tester, .Notify:	return ProjectPeople.count
        default: return 0
        }
    }
	
	
    
    func setProjectByIndex(projectIndex: Int) -> DoneDoneProject? {
        
        let project = Projects[projectIndex]
        
        if (NewIssue.project.id != project.id) {
            NewIssue.project = project
            
            return project
        }
        
        return nil
    }

	
	
    func getActiveCellType() -> BugCellTypes {
		
        switch ActiveDoneDoneDetail {
        case .Project, .Priority, .Fixer, .Tester, .Tags, .Notify:
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

        switch ActiveDoneDoneDetail {
			
		case .Project, .Priority: break
			
		case .Fixer, .Tester, .Notify:
			if NewIssue.project.id == nil {
				dict[.Title] = "No People"
				dict[.Detail] = "Make sure you have a Project selected"
			}
		case .Tags:
			if NewIssue.project.id == nil {
				dict[.Title] = "No Tags"
				dict[.Detail] = "Make sure you have a Project selected"
			} else if NewIssue.project.tags.isEmpty {
				dict[.Title] = "No Tags"
				dict[.Detail] = "The selected Project doesn\'t have any Tags"
			}
			default: break
		}

        return dict
    }

	
	
    func getActiveCellDetails(selectedIndex: Int) -> CellData {

//        var detail = ""
		
		let fixer = ActiveDoneDoneDetail.isPersonDetail() && NewIssue.fixer.id == ProjectPeople[selectedIndex].id
		let tester = ActiveDoneDoneDetail.isPersonDetail() && NewIssue.tester.id == ProjectPeople[selectedIndex].id
		let ccdUser = ActiveDoneDoneDetail.isPersonDetail() && NewIssue.ccdUsers.contains(self.ProjectPeople[selectedIndex])
        
        let cellData = CellData()
		
		switch ActiveDoneDoneDetail {
			
		case .Project:
            cellData.Set(.Title, value: Projects[selectedIndex].value)
            cellData.Selected = Projects[selectedIndex].id == NewIssue.project.id
		case .Priority:
            cellData.Set(.Title, value: PriorityLevels[selectedIndex].value)
            cellData.Selected = PriorityLevels[selectedIndex].id == NewIssue.priority.id
		case .Fixer:
            let person = ProjectPeople[selectedIndex]
            cellData.CellType = .Person
            cellData.Set(.Title, value: person.fullName)
            cellData.Set(.Detail, value: !fixer ? tester ? "(tester)" : ccdUser ? "(CCd)" : "" : "")
            cellData.Set(.Auxiliary, value: person.initials)
            cellData.Set(.ImageUrl, value: person.avatarUrl)
            cellData.Selected = fixer
		case .Tester:
            let person = ProjectPeople[selectedIndex]
            cellData.CellType = .Person
            cellData.Set(.Title, value: person.fullName)
            cellData.Set(.Detail, value: !tester ? fixer ? "(fixer)" : ccdUser ? "(CCd)" : "" : "")
            cellData.Set(.Auxiliary, value: person.initials)
            cellData.Set(.ImageUrl, value: person.avatarUrl)
            cellData.Selected = tester
		case .Notify:
            let person = ProjectPeople[selectedIndex]
            cellData.CellType = .Person
            cellData.Set(.Title, value: person.fullName)
            cellData.Set(.Detail, value: fixer ? "(fixer)" : tester ? "(tester)" : "")
            cellData.Set(.Auxiliary, value: person.initials)
            cellData.Set(.ImageUrl, value: person.avatarUrl)
            cellData.Selected = ccdUser
		case .Tags:
            cellData.Set(.Title, value: NewIssue.project.tags[selectedIndex].value)
            cellData.Set(.Detail, value: "(\(String(NewIssue.project.tags[selectedIndex].numberOfIssues)))")
            cellData.Selected = NewIssue.tags.contains(self.NewIssue.project.tags[selectedIndex])
		default:
            break
		}
        
        return cellData
    }
}