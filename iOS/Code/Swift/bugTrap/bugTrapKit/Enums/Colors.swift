//
//  Colors.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/24/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

enum Colors {

	case	Theme,
			Black,
			White,
			Clear,
			Gray,
			LightGray,
			LighterGray,
			Tool
		
	var uiColor: UIColor {
		switch self {
		case .Theme:		return UIColor(red: 252 / 255, green:  17 / 255, blue:  63 / 255, alpha: 255 / 255)
		case .Black:		return UIColor(red:   0 / 255, green:   0 / 255, blue:   0 / 255, alpha: 255 / 255)
		case .White:		return UIColor(red:	255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 255 / 255)
		case .Clear:		return UIColor(red:   0 / 255, green:   0 / 255, blue:   0 / 255, alpha:   0 / 255)
		case .Gray:			return UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 255 / 255)
		case .LightGray:	return UIColor(red: 199 / 255, green: 199 / 255, blue: 204 / 255, alpha: 255 / 255)
		case .LighterGray:	return UIColor(red: 248 / 255, green: 248 / 255, blue: 252 / 255, alpha: 255 / 255)
		case .Tool:			return UIColor(red: 147 / 255, green: 146 / 255, blue: 145 / 255, alpha: 255 / 255)
		}
	}
		
	var cgColor: CGColor {
		return self.uiColor.CGColor
	}
}