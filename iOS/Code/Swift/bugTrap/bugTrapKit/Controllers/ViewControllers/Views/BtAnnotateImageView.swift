//
//  BtAnnotateImageView.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit
import CoreText

class BtAnnotateImageView: UIView {
	
	var tool = Annotate.Tool.Marker
	

	let annotateUndoManager = NSUndoManager()
	
	var annotationDataCacheHasChangesSinceCHecked = false
	
	var annotationDataCache: [AnnotationData] = [AnnotationData]() {
		willSet {
			annotationDataCacheHasChangesSinceCHecked = true
		}
	}
	
	var annotationDataCacheArchive = [AnnotationData]()
	
	
	var strokeColor = Annotate.Color.Black.color()
	
	var bzPath = UIBezierPath()
	
	var arrowPoints = [CGPoint](count: 7, repeatedValue: CGPointZero)
	
	var markerPoints = [CGPoint](count: 5, repeatedValue: CGPointZero)
	
	var pathStart = CGPointZero
	
	var counter = 0, calloutCount = 0
	
	var incrementImage: UIImage?, bufferImage: UIImage?
	
	var bufferImageView: UIImageView?
	
	var touchesDidMove = false
	
	var displayTransform : CGAffineTransform?
	
	var displayRect = CGRectZero, contextRect = CGRectZero, bufferRect = CGRectZero
	
	var isRedrawingAfterOrientationChange = false
	
	var imageHasChanges: Bool {
		let changed = annotationDataCache.isEmpty ? false : annotationDataCacheHasChangesSinceCHecked
		annotationDataCacheHasChangesSinceCHecked = false
		return changed
	}
	
	func resetContextAndState() {
		
		annotateUndoManager.removeAllActionsWithTarget(self)
		annotationDataCache.removeAll(keepCapacity: false)
		annotationDataCacheArchive.removeAll(keepCapacity: false)
		bzPath.removeAllPoints()
		arrowPoints = [CGPoint](count: 7, repeatedValue: CGPointZero)
		markerPoints = [CGPoint](count: 5, repeatedValue: CGPointZero)
		pathStart = CGPointZero
		counter = 0
		incrementImage = nil
		touchesDidMove = false
		displayTransform = nil
		displayRect = CGRectZero
		contextRect = CGRectZero
		bufferRect  = CGRectZero
	}
	

	func updateContextAndStateForRotation() {
		displayRect = CGRectZero
		contextRect = CGRectZero
		bufferRect  = CGRectZero
		bufferImageView?.removeFromSuperview()
	}
	

	func refreshLayoutAndImageForRotation() {
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		isRedrawingAfterOrientationChange = true
		
		redrawBitmap()
	}
	
	required init(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
		
		multipleTouchEnabled = false
		backgroundColor = UIColor.whiteColor()
		
		configureStroke(Annotate.Color.Black.color(), width: 4.0)
	}
	
	
	
	func configureTool (annotateTool: Annotate.Tool) {
		tool = annotateTool
	}
	
	
	
	func configureStroke (color: UIColor, width: CGFloat = 0.0) {
		
		strokeColor = color
		
		if width > 0.0 {
			bzPath.lineWidth = width
		}
	}
	
	
	
	func refreshLayoutAndImage () {
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		if incrementImage == nil {
			redrawBitmap()
		}
	}
	
	
	
	override func drawRect(rect: CGRect) {
		
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		strokeColor.setStroke()
		
		if incrementImage == nil {
			redrawBitmap()
		}
		
		incrementImage?.drawInRect(displayRect)
		
		switch tool {
		case .Marker, .Arrow, .Circle, .Square:
			
			bzPath.stroke()
			
			if tool == Annotate.Tool.Arrow {
				strokeColor.setFill()
				bzPath.fill()
			}
			
		case .Callout, .Color: break
		}
	}
	

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		touchesDidMove = false
		
		switch tool {
		case .Marker:
			
			UIGraphicsBeginImageContextWithOptions(bufferRect.size, true, 0.0)
			
			incrementImage?.drawInRect(bufferRect)

			strokeColor.setStroke()
			
			counter = 0
			

            markerPoints[0] = touches.first?.locationInView(bufferImageView) ?? CGPointZero
			
		case .Arrow, .Circle, .Square, .Callout:
			
			pathStart = touches.first?.locationInView(bufferImageView) ?? CGPointZero
			
		case .Color: break
		}
	}
	
	
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		touchesDidMove = true
		
		let point = touches.first?.locationInView(bufferImageView) ?? CGPointZero
		
		let difX = point.x - pathStart.x
		let difY = point.y - pathStart.y
		
		var path : UIBezierPath?
		
		switch tool {
		case .Callout, .Color: return
			
		case .Marker:
			
			counter++
			
			markerPoints[counter] = point
			
			if counter == 4 {
				
				// move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
				markerPoints[3] = CGPoint(x: (markerPoints[2].x + markerPoints[4].x) / 2.0, y: (markerPoints[2].y + markerPoints[4].y) / 2.0)
				
				path = UIBezierPath()
				
				path?.moveToPoint(markerPoints[0])
				
				path?.addCurveToPoint(markerPoints[3], controlPoint1: markerPoints[1], controlPoint2: markerPoints[2])
				
				path?.lineWidth = bzPath.lineWidth
				
				// add to cached path to draw and add to undo stack later
				bzPath.appendPath(path!)
				
				// replace points and get ready to handle the next segment
				markerPoints[0] = markerPoints[3]
				markerPoints[1] = markerPoints[4]
				
				counter = 1
			}
			
			path?.stroke()
			bufferImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
			
		case .Arrow:
			
			let total = hypot(difX, difY)
			
			let tailL = total * 0.7
			
			let tailW = bzPath.lineWidth / 2.0
			
			let headW = (total * 0.2) / 2.0
			
			arrowPoints[0] = CGPoint(x: 0.0,	y: tailW)
			arrowPoints[1] = CGPoint(x: tailL,	y: tailW)
			arrowPoints[2] = CGPoint(x: tailL,	y: headW)
			arrowPoints[3] = CGPoint(x: total,	y: 0.0)
			arrowPoints[4] = CGPoint(x: tailL,	y: -headW)
			arrowPoints[5] = CGPoint(x: tailL,	y: -tailW)
			arrowPoints[6] = CGPoint(x: 0.0,	y: -tailW)
			
			let cosine = difX / total, sine = difY / total
			
			var transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: pathStart.x, ty: pathStart.y)
			
			let cgPath = CGPathCreateMutable()
			
			CGPathAddLines(cgPath, &transform, arrowPoints, 7)
			
			CGPathCloseSubpath(cgPath)
			
			path = UIBezierPath(CGPath: cgPath)

			path?.lineWidth = bzPath.lineWidth

			// cache path to draw and add to undo stack later
			bzPath = path!

			
			
			UIGraphicsBeginImageContextWithOptions(bufferRect.size, false, 0.0)
			
			strokeColor.setFill()
			path?.fill()
				
			strokeColor.setStroke()
			path?.stroke()
				
			bufferImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
				
			UIGraphicsEndImageContext()
			
		case .Circle, .Square:
			
			let origin = CGPoint(x: min(pathStart.x, point.x), y: min(pathStart.y, point.y))
			
			let size = CGSize(width: fabs(point.x - pathStart.x), height: fabs(point.y - pathStart.y))
			
			let rect = CGRect(origin: origin, size: size)
			
			path = tool == Annotate.Tool.Circle ? UIBezierPath(ovalInRect: rect) : UIBezierPath(rect: rect)
			
			path?.lineWidth = bzPath.lineWidth

			// cache path to draw and add to undo stack later
			bzPath = path!

			
			
			UIGraphicsBeginImageContextWithOptions(bufferRect.size, false, 0.0)
				
			strokeColor.setStroke()
			path?.stroke()
				
			bufferImageView?.image = UIGraphicsGetImageFromCurrentImageContext()

			UIGraphicsEndImageContext()
		}
	}
	
	
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		switch tool {
		case .Callout:
			
			let rect = CGRect(origin: CGPoint(x: pathStart.x - 16, y: pathStart.y - 14.0), size: CGSize(width: 32.0, height: 28.0))
			// let rect = CGRect(origin: CGPoint(x: pathStart.x - 3.0, y: pathStart.y - 32.0), size: CGSize(width: 28.0, height: 24.0))
			
			let callout = CalloutAnnotation(count: calloutCount, rect: rect, lineWidth: bzPath.lineWidth, color: strokeColor)
			
			annotationDataCache.append(callout)
			
			redrawBitmap()
			
		case .Marker, .Arrow, .Circle, .Square:
			
			if tool == .Marker {
				UIGraphicsEndImageContext()
			}
			
			if touchesDidMove {

				let annotation = PathAnnotation(tool: tool, path: bzPath, color: strokeColor)
				
				annotationDataCache.append(annotation)
				
				redrawBitmap()
			}
			
		case .Color: break
		}
		
		bzPath.removeAllPoints()
		
		pathStart = CGPointZero
		
		counter = 0
		
		touchesDidMove = false
	}
	
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touch = touches {
            touchesEnded(touch, withEvent: event)
        }
    }
	
	
	
	func redrawBitmap () {
		
		if !TrapState.Shared.hasActiveSnapshotImage {
			return
		}
		
		let setup = isRedrawingAfterOrientationChange || displayRect == CGRectZero
		
		if setup {
			
			if let imageSize = TrapState.Shared.activeSnapshotImage?.size {
				
				let scale = min(bounds.size.width / imageSize.width, bounds.size.height / imageSize.height)
				
				let scaledSize = CGSizeApplyAffineTransform(imageSize, CGAffineTransformMakeScale(scale, scale))
				
				contextRect = CGRect(origin: CGPointZero, size: imageSize)
				
				displayRect = CGRect(origin: CGPoint(x: bounds.midX - scaledSize.width / 2, y: bounds.midY - scaledSize.height / 2), size: scaledSize)
				
				bufferRect = CGRect(origin: CGPointZero, size: scaledSize)
				
				let displayScale = max(imageSize.width / bounds.size.width, imageSize.height / bounds.size.height)
				
				displayTransform = CGAffineTransformMakeScale(displayScale, displayScale)
			}
			
			bufferImageView = UIImageView(frame: displayRect)
			bufferImageView?.backgroundColor = Colors.Clear.uiColor
			addSubview(bufferImageView!)
		}
		
		
		UIGraphicsBeginImageContextWithOptions(contextRect.size, true, 1.0)
		
		strokeColor.setStroke()
		
		if !(incrementImage?.drawAtPoint(CGPointZero) != nil) {
			
			TrapState.Shared.activeSnapshotImage?.drawInRect(contextRect)
		}
		
		
		if annotateUndoManager.redoing {
			
			if let undo = annotationDataCacheArchive.last {
				annotationDataCacheArchive.removeLast()
				annotationDataCache.append(undo)
			}
		}
		
		
		if annotateUndoManager.undoing {
			
			TrapState.Shared.activeSnapshotImage?.drawInRect(contextRect)
			
			if let redo = annotationDataCache.last {
				annotationDataCache.removeLast()
				annotationDataCacheArchive.append(redo)
			}
		}
		
		if !isRedrawingAfterOrientationChange {
		
			let context = UIGraphicsGetCurrentContext()

			CGContextSaveGState(context)

			CGContextConcatCTM(context, displayTransform!)

			if annotateUndoManager.undoing {
				
				calloutCount = 0
				
				for data in annotationDataCache {
					
					switch data.tool {
					case .Callout:
						
						if let callout = data as? CalloutAnnotation {
							
							drawCallout(context, callout: callout)
						}
						
					case .Marker, .Arrow, .Circle, .Square:
						
						if let annotation = data as? PathAnnotation {
							annotation.color.setStroke()
							annotation.path.stroke()
							
							if data.tool == Annotate.Tool.Arrow {
								annotation.color.setFill()
								annotation.path.fill()
							}
						}
						
					case .Color: break
					}
				}
				
			} else if let data = annotationDataCache.last {  // This takes care of redo

				switch data.tool {
				case .Callout:
					
					if let callout = data as? CalloutAnnotation {
						
						drawCallout(context, callout: callout)
					}
					
				case .Marker, .Arrow, .Circle, .Square:
					
					if let annotation = data as? PathAnnotation {
						annotation.color.setStroke()
						annotation.path.stroke()
						
						if data.tool == Annotate.Tool.Arrow {
							annotation.color.setFill()
							annotation.path.fill()
						}
					}
					
				case .Color: break
				}
			}
			
			CGContextRestoreGState(context)
			
			annotateUndoManager.registerUndoWithTarget(self, selector: "redrawBitmap", object: nil)
			
		}
		
		isRedrawingAfterOrientationChange = false
		
		incrementImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		bufferImageView?.image = nil
		
		setNeedsDisplay()
	}
	
	
	func drawCallout(context: CGContextRef, callout: CalloutAnnotation) {
		
		callout.color.setStroke()
		
		CGContextSaveGState(context)
		
		callout.clip.addClip()
		callout.path.stroke()
		
		CGContextRestoreGState(context)
		
		callout.tail.stroke()
		
		drawLabel(context, rect: displayRect, yCoord: displayRect.height - callout.center.y, xCoord: callout.center.x, alignment: CTTextAlignment.Center, color: callout.color, label: callout.getCalloutString(), flipContext: true)
		
		calloutCount += 1
	}
	
	
	func drawLabel(ctx: CGContextRef, rect: CGRect, yCoord: CGFloat, xCoord: CGFloat, alignment: CTTextAlignment, color: UIColor, label: String, flipContext: Bool = true) {
		
		let attrString =  NSMutableAttributedString(string: label)
		
		let range = CFRangeMake(0, attrString.length)
		
		if let uiFont = UIFont(name: "HelveticaNeue-Medium", size: range.length > 1 ? 15 : 22) {
		
			let font = CTFontCreateWithName((uiFont.fontName as NSString) as CFString, uiFont.pointSize, nil)
		
			let path = CGPathCreateMutable()

			let alignStyle = NSMutableParagraphStyle()
				alignStyle.alignment = NSTextAlignmentFromCTTextAlignment(alignment)
		
			let attributes : [String : AnyObject] = [ NSFontAttributeName : font, NSForegroundColorAttributeName : color.CGColor, NSParagraphStyleAttributeName : alignStyle ]
				attrString.setAttributes(attributes, range: NSMakeRange(0, attrString.length))
			let target = CGSize(width: CGFloat.max, height: CGFloat.max)

			var fit = CFRange(location: 0, length: 0)
		
			let framesetter = CTFramesetterCreateWithAttributedString(attrString)
		
			let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, target, &fit)
		
			let textRect = CGRect(x: xCoord - (frameSize.width / 2), y: yCoord - (frameSize.height / 2), width: frameSize.width, height: frameSize.height)
		
			CGPathAddRect(path, nil, textRect)
		
			let frame = CTFramesetterCreateFrame(framesetter, range, path, nil)
		
			if flipContext {
			
				CGContextSaveGState(ctx)
			
				CGContextTranslateCTM(ctx, 0.0, rect.height)
			
				CGContextScaleCTM(ctx, 1, -1)
			
				CTFrameDraw(frame, ctx)
			
				CGContextRestoreGState(ctx)
			} else {
				CTFrameDraw(frame, ctx)
			}
		}
	}
}