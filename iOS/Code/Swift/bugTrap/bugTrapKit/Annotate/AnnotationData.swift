//
//  AnnotationData.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/31/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

protocol AnnotationData {

	var color: UIColor { get }

	var tool: Annotate.Tool { get }
}