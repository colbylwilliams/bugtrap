//
//  PathAnnotation.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/31/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

struct PathAnnotation : AnnotationData {

	let color: UIColor

	let	path: UIBezierPath

	let tool: Annotate.Tool
	
	// init (tool: Annotate.Tool, path: UIBezierPath, scale: CGFloat, color: UIColor) {
	init (tool: Annotate.Tool, path: UIBezierPath, color: UIColor) {
	
		self.tool = tool
		
		let bzPath = UIBezierPath(CGPath: path.CGPath)
			bzPath.lineWidth = path.lineWidth
			// bzPath.applyTransform(CGAffineTransformMakeScale(scale, scale))
		
		self.path = bzPath
	
		self.color = color
	}
}