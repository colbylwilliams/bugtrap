//
//  AnnotateTool.swift
//  bugTrap
//
//  Created by Colby L Williams on 8/24/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation
import UIKit

class Annotate {
		
	enum Tool: Int {
		
		case Callout = 0, Marker, Arrow, Circle, Square, Color
		
		func image(color: Annotate.Color) -> UIImage {
			switch self {
			case .Callout:	return UIImage(named: "i_tool_annotation")!
			case .Marker:	return UIImage(named: "i_tool_marker")!
			case .Arrow:	return UIImage(named: "i_tool_arrow")!
			case .Circle:	return UIImage(named: "i_tool_circle")!
			case .Square:	return UIImage(named: "i_tool_square")!
			case .Color:	return colorImage(color)
			}
		}
		
		func imageOn(color: Annotate.Color) -> UIImage {
			switch self {
			case .Callout:	return UIImage(named: "i_tool_annotation_on")!
			case .Marker:	return UIImage(named: "i_tool_marker_on")!
			case .Arrow:	return UIImage(named: "i_tool_arrow_on")!
			case .Circle:	return UIImage(named: "i_tool_circle_on")!
			case .Square:	return UIImage(named: "i_tool_square_on")!
			case .Color:	return colorImage(color)
			}
		}
		
		private func colorImage(color: Annotate.Color) -> UIImage {
			switch color {
			case .Red:		return UIImage(named: "i_tool_color_red")!.imageWithRenderingMode(.AlwaysOriginal)
			case .Orange:	return UIImage(named: "i_tool_color_orange")!.imageWithRenderingMode(.AlwaysOriginal)
			case .Green:	return UIImage(named: "i_tool_color_green")!.imageWithRenderingMode(.AlwaysOriginal)
			case .Blue:		return UIImage(named: "i_tool_color_blue")!.imageWithRenderingMode(.AlwaysOriginal)
			case .White:	return UIImage(named: "i_tool_color_white")!.imageWithRenderingMode(.AlwaysOriginal)
			case .Black:	return UIImage(named: "i_tool_color_black")!.imageWithRenderingMode(.AlwaysOriginal)
			}
		}
		
		func toString() -> String {
			switch self {
			case .Callout:	return "Callout"
			case .Marker:	return "Marker"
			case .Arrow:	return "Arrow"
			case .Circle:	return "Circle"
			case .Square:	return "Square"
			case .Color:	return "Color"
			}
		}
	}
	
	enum Color: Int {
		case Red = 0, Orange, Green, Blue, White, Black
		
		func color() -> UIColor {
			switch self {
			case .Red:		return UIColor.redColor()
			case .Orange:	return UIColor.orangeColor()
			case .Green:	return UIColor.greenColor()
			case .Blue:		return UIColor.blueColor()
			case .White:	return UIColor.whiteColor()
			case .Black:	return UIColor.blackColor()
			}
		}
	}
}