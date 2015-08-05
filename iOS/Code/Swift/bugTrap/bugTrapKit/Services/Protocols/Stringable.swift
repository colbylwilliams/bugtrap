//
//  Stringable.swift
//  bugTrap
//
//  Created by Nate Rickard on 9/10/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

protocol Stringable {
	
	var string: String { get }
	
	// func toString() -> String
}

extension String : Stringable {
	var string: String {
		return self
	}
}