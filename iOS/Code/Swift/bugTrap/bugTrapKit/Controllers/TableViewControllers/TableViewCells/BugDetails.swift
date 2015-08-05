//
//  BugDetailCells.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/23/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import CoreGraphics

struct BugDetails {
	
    enum DetailType {
		
		case Images
		case Selection		(String, String)
		case TextField		(String, String)
		case TextView		(String, String)
		case DateDisplay	(String, String)
		case DatePicker		(NSDate, String)
		
		
		func cellId() -> String {
			switch self {
			case .Images:		return "BtEmbeddedImageCollectionViewTableViewCell"
			case .Selection:	return "BtTitlePlaceholderTableViewCell"
			case .TextField:	return "BtTextFieldTableViewCell"
			case .TextView:		return "BtTextViewTableViewCell"
			case .DateDisplay:	return "BtDateDisplayTableViewCell"
			case .DatePicker:	return "BtDatePickerTableViewCell"
			}
		}
		
		
		func cellHeight() -> CGFloat {
			switch self {
			case .Images:		return 142.0
			case .Selection:	return 44.0
			case .TextField:	return 44.0
			case .TextView:		return 100.0
			case .DateDisplay:	return 44.0
			case .DatePicker:	return 163.0
			}
		}
		
		
		func isDate() -> Bool {
			switch self {
			case .Images, .Selection, .TextField, .TextView:
				return false
			case .DateDisplay, .DatePicker:
				return true
			}
		}
	}
}