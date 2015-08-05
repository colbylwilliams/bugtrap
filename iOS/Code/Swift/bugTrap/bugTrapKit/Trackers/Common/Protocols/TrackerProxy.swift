//
//  TrackerProxy.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/29/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

protocol TrackerProxy {
	
	init()
	
	// init(data trackerData : Dictionary<DataKeys, String>!)
	
	func authenticate(data trackerData: [DataKeys : String], callback: (Result<Bool>) -> ())
	
    func verifyAuthentication(callback: (Result<Bool>) -> ())
    
    func getDataForUrl(url: String, callback: (Result<NSData>) -> ())
}