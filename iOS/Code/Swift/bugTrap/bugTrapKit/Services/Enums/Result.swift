//
//  Result.swift
//  bugTrap
//
//  Created by Nate Rickard on 9/11/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum Result<T> {
    case Error(NSError)
    case Value(Wrapped<T>)
}

final class Wrapped<T> {
	
	var value: T?
    
    init(_ value: T?) {
        self.value = value
    }
}