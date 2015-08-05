//
//  ContentType.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

enum ContentType : String, Stringable {
    case Json =				"application/json"
    case MultiPartForm =	"multipart/form-data"
	case ImageJpeg =		"image/jpeg"
	case TextPlain =		"text/plain"
    
	var string: String {
		return self.rawValue
	}
}