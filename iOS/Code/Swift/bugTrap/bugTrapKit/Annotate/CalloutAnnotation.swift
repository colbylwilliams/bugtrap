//
//  CalloutAnnotation.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/31/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

struct CalloutAnnotation : AnnotationData {
	
	let alphabet = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
	
	func getCalloutString() -> String {
		if count < alphabet.count {
			return alphabet[count]
		} else if count < (alphabet.count * 2) {
			let c = count - alphabet.count
			return "\(alphabet[c])\(alphabet[c])"
		} else {
			return "+"
		}
	}
	
	let count: Int
	
	let color: UIColor
	
	let	path: UIBezierPath
	
	let clip: UIBezierPath
	
	let tail: UIBezierPath
	
	let tool: Annotate.Tool
	
	let rect: CGRect
	
	let center: CGPoint
	
	init (count: Int, rect: CGRect, lineWidth: CGFloat, color: UIColor) {
		
		self.tool = Annotate.Tool.Callout
		
		self.path = UIBezierPath(ovalInRect: rect)
		self.path.lineWidth = lineWidth
		
		let center = CGPoint(x: rect.midX, y: rect.midY)
		
		self.center = center
		
		let startAngle	= CGFloat(M_PI * 0.75)
		let endAngle	= CGFloat(M_PI * 0.60)
		
		self.clip = UIBezierPath(arcCenter: center, radius: center.x + lineWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		self.clip.addLineToPoint(center)
		self.clip.closePath()
		self.clip.lineWidth = lineWidth
		
		self.tail = UIBezierPath()
		self.tail.moveToPoint(	 CGPoint(x: center.x - 11.0, y: center.y +  9))
		self.tail.addLineToPoint(CGPoint(x: center.x - 11.0, y: center.y + 18))
		self.tail.addLineToPoint(CGPoint(x: center.x -  3.0, y: center.y + 13))
		self.tail.lineWidth = lineWidth
		
		self.rect = rect
		
		self.color = color
		
		self.count = count
	}
}