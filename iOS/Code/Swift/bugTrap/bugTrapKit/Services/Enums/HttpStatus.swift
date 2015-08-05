//
//  HttpStatus.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum HttpStatus : Int {
    case Ok				 = 200
	case Created		 = 201
    case Unauthorized	 = 401
	case PaymentRequired = 402
	case Forbidden		 = 403
	case NotFound		 = 404
    
    static var type : String {
        get {
            return "HttpStatus"
        }
    }
}