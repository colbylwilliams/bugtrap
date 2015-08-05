//
//  TrackerDetailType.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

protocol TrackerDetailType {
    func isPersonDetail () -> Bool
	var settingsKey: String { get }
}