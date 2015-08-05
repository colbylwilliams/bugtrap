//
//  DoneDoneNewIssue.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/25/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class DoneDoneFields {
    
    enum NewIssueFields : String, Stringable {
        
        case Title = "title"
        
        case Description = "description"
        
        case DueDate = "due_date"
        
        case Tags = "tags"
        
        case PriorityLevelId = "priority_level_id"
        
        case FixerId = "fixer_id"
        
        case TesterId = "tester_id"
        
        case UserIdsToCc = "user_ids_to_cc"
        
        case Attachment = "Attachment"
        
		var string: String {
			return self.rawValue
		}
    }
    
    enum DoneDoneIssueFields {
        
    }
}