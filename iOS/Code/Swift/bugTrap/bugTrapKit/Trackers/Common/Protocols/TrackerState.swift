//
//  TrackerState.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/29/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

protocol TrackerState {
    
    init()
	
	// var Authenticated: Bool { get set }
	
	func Reset()
	
	func sortActiveBugDetailValues ()
	
	var ActiveBugDetailTitle: String { get }
    
    var ActiveBugDetail: Int { get set }
    
    var IsActiveTopLevelDetail: Bool { get }
    
    var TrackerDetails: Dictionary<Int, BugDetails.DetailType> { get }
    
    var TrackerSections: Int { get }
	
	var hasProject: Bool { get }
	
	var bugTitle: String { get set }
	
	var bugDescription: String { get set }
	
	var bugDueDate: NSDate? { get set }
	
	var isValid: Bool { get }
	
//    var PriorityLevels: [SimpleItem] { get }
	
//    var NewIssue: Issue { get }
	
//    var ProjectPeople: [Person] { get }
	
    func getValueForDetail(detailIndex: Int) -> String
    
    func getActiveCellType() -> BugCellTypes
    
    func getCountForActiveBugDetail() -> Int

    func getActiveTitleDetail() -> Dictionary<DataKeys, String>

    func getActiveCellDetails(selectedIndex: Int) -> CellData
    
    //func setProjectByIndex(projectIndex: Int) -> Project?
}