//
//  TrackerStatus.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum TrackerStatus : Int, Stringable {

    case CurrentTracker
    case Disabled
    case Enabled
    case ComingSoon
    
	var string: String {
        switch self {
        case CurrentTracker:    return "CurrentTracker"
        case Disabled:          return "Disabled"
        case Enabled:           return "Enabled"
        case ComingSoon:        return "ComingSoon"
        }
    }
}