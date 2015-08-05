

using System;

using Foundation;
using UIKit;
using System.Collections.Generic;
using CoreGraphics;
using CoreText;
using CoreAnimation;
using System.Linq;
using ObjCRuntime;

namespace bugTrapKit
{
	public partial class BtAnnotateImageView : UIView
	{
		public Annotate.Tool Tool = Annotate.Tool.Marker;

		public NSUndoManager AnnotateUndoManager = new NSUndoManager ();

		bool annotationDataCacheHasChangesSinceChecked;

		List<IAnnotationData> annotationDataCache = new List<IAnnotationData> ();
		// observable collection?

		List<IAnnotationData> annotationDataCacheArchive = new List<IAnnotationData> ();

		UIColor strokeColor = Annotate.Color.Black.color();

		UIBezierPath bzPath = new UIBezierPath ();

		CGPoint[] arrowPoints = new CGPoint[7], markerPoints = new CGPoint[5];

		CGPoint pathStart = CGPoint.Empty;

		int counter, calloutCount;

		public UIImage IncrementImage { get; set; }

		// UIImage bufferImage;

		UIImageView bufferImageView;

		bool touchesDidMove;

		CGAffineTransform displayTransform;

		CGRect displayRect = CGRect.Empty, contextRect = CGRect.Empty, bufferRect = CGRect.Empty;

		bool isRedrawingAfterOrientationChange;

		public bool ImageHasChanges {
			get {
				var changed = !annotationDataCache.IsEmpty() && annotationDataCacheHasChangesSinceChecked;
				annotationDataCacheHasChangesSinceChecked = false;
				return changed;
			}
		}


		public BtAnnotateImageView (IntPtr handle) : base(handle)
		{
			MultipleTouchEnabled = false;
			BackgroundColor = UIColor.White;

			ConfigureStroke(Annotate.Color.Black.color());
		}


		public void ResetContextAndState ()
		{
			AnnotateUndoManager.RemoveAllActions(this);
			annotationDataCache = new List<IAnnotationData> ();
			annotationDataCacheArchive = new List<IAnnotationData> ();
			bzPath.RemoveAllPoints();
			arrowPoints = new CGPoint[7];
			markerPoints = new CGPoint[5];
			pathStart = CGPoint.Empty;
			counter = 0;
			IncrementImage = null;
			touchesDidMove = false;
			displayTransform = new CGAffineTransform ();
			displayRect = CGRect.Empty;
			contextRect = CGRect.Empty;
			bufferRect = CGRect.Empty;
		}

		public void UpdateContextAndStateForRotation ()
		{
			displayRect = CGRect.Empty;
			contextRect = CGRect.Empty;
			bufferRect = CGRect.Empty;
			bufferImageView.RemoveFromSuperview();
		}


		public void RefreshLayoutAndImageForRotation ()
		{
			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			isRedrawingAfterOrientationChange = true;

			redrawBitmap();
		}

		public void ConfigureTool (Annotate.Tool annotateTool)
		{
			Tool = annotateTool;
		}

		public void ConfigureStroke (UIColor color, nfloat width = default(nfloat))
		{
			strokeColor = color;

			if (width > 0) bzPath.LineWidth = width;
		}

		public void RefreshLayoutAndImage ()
		{
			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			if (IncrementImage == null) redrawBitmap();
		}

		public override void Draw (CGRect rect)
		{
			//base.Draw(rect);

			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			strokeColor.SetStroke();

			if (IncrementImage == null) redrawBitmap();

			IncrementImage.Draw(displayRect);

			switch (Tool) {
			case Annotate.Tool.Marker:
			case Annotate.Tool.Arrow:
			case Annotate.Tool.Circle:
			case Annotate.Tool.Square:

				bzPath.Stroke();

				if (Tool == Annotate.Tool.Arrow) {
					strokeColor.SetFill();
					bzPath.Fill();
				}

				break;
			case Annotate.Tool.Callout:
			case Annotate.Tool.Color:
				break;
			}
		}

		public override void TouchesBegan (NSSet touches, UIEvent evt)
		{
			// base.TouchesBegan(touches, evt);

			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			touchesDidMove = false;

			var touch = touches.AnyObject as UITouch;

			switch (Tool) {
			case Annotate.Tool.Marker:

				UIGraphics.BeginImageContextWithOptions(bufferRect.Size, true, 0);

				IncrementImage.Draw(bufferRect);

				strokeColor.SetStroke();

				counter = 0;

				markerPoints[0] = touch.LocationInView(bufferImageView);

				break;
			case Annotate.Tool.Arrow:
			case Annotate.Tool.Circle:
			case Annotate.Tool.Square:
			case Annotate.Tool.Callout:

				pathStart = touch.LocationInView(bufferImageView);

				break;
			case Annotate.Tool.Color:
				break;
			}
		}



		public override void TouchesMoved (NSSet touches, UIEvent evt)
		{
			// base.TouchesMoved(touches, evt);

			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			touchesDidMove = true;

			var touch = touches.AnyObject as UITouch;

			var point = touch.LocationInView(bufferImageView);

			var difX = point.X - pathStart.X;
			var difY = point.Y - pathStart.Y;

			var path = new UIBezierPath ();

			switch (Tool) {
			case Annotate.Tool.Callout:
			case Annotate.Tool.Color:

				return;

			case Annotate.Tool.Marker:

				counter++;

				markerPoints[counter] = point;

				if (counter == 4) {

					// move the endpoint to the middle of the line joining the second control point 
					// of the first Bezier segment and the first control point of the second Bezier segment
					markerPoints[3] = new CGPoint ((markerPoints[2].X + markerPoints[4].X) / 2, (markerPoints[2].Y + markerPoints[4].Y) / 2);

					path = new UIBezierPath ();

					path.MoveTo(markerPoints[0]);

					path.AddCurveToPoint(markerPoints[3], markerPoints[1], markerPoints[2]);

					path.LineWidth = bzPath.LineWidth;

					// add to cached path to draw and add to undo stack
					bzPath.AppendPath(path);

					// replace points and get ready to handle the next segment
					markerPoints[0] = markerPoints[3];
					markerPoints[1] = markerPoints[4];

					counter = 1;
				}

				path.Stroke();
				bufferImageView.Image = UIGraphics.GetImageFromCurrentImageContext();

				break;
			case Annotate.Tool.Arrow:

				var total = Math.Sqrt(Math.Pow(difX, 2) + Math.Pow(difX, 2));

				var tailL = (nfloat)(total * 0.7);

				var tailW = bzPath.LineWidth / 2;

				var headW = (nfloat)((total * 0.2) / 2);

				arrowPoints[0] = new CGPoint (0, tailW);
				arrowPoints[1] = new CGPoint (tailL, tailW);
				arrowPoints[2] = new CGPoint (tailL, headW);
				arrowPoints[3] = new CGPoint ((nfloat)total, 0);
				arrowPoints[4] = new CGPoint (tailL, -headW);
				arrowPoints[5] = new CGPoint (tailL, -tailW);
				arrowPoints[6] = new CGPoint (0, -tailW);

				nfloat cosine = (nfloat)(difX / total), sine = (nfloat)(difY / total);

				var transform = new CGAffineTransform (cosine, sine, -sine, cosine, pathStart.X, pathStart.Y);

				var cgPath = new CGPath ();

				cgPath.AddLines(transform, arrowPoints, 7);

				cgPath.CloseSubpath();


				path = UIBezierPath.FromPath(cgPath);

				path.LineWidth = bzPath.LineWidth;

				// cache path to draw and add to undo stack later
				bzPath = path;


				UIGraphics.BeginImageContextWithOptions(bufferRect.Size, false, 0);

				strokeColor.SetFill();
				path.Fill();

				strokeColor.SetStroke();
				path.Stroke();

				bufferImageView.Image = UIGraphics.GetImageFromCurrentImageContext();

				UIGraphics.EndImageContext();

				break;
			case Annotate.Tool.Circle:
			case Annotate.Tool.Square:

				var origin = new CGPoint ((nfloat)Math.Min(pathStart.X, point.X), (nfloat)Math.Min(pathStart.Y, point.Y));

				var size = new CGSize ((nfloat)Math.Abs(difX), (nfloat)Math.Abs(difY));

				var rect = new CGRect (origin, size);

				path = Tool == Annotate.Tool.Circle ? UIBezierPath.FromOval(rect) : UIBezierPath.FromRect(rect);

				path.LineWidth = bzPath.LineWidth;

				// cache path to draw and add to undo stack later
				bzPath = path;


				UIGraphics.BeginImageContextWithOptions(bufferRect.Size, false, 0);

				strokeColor.SetStroke();

				path.Stroke();

				bufferImageView.Image = UIGraphics.GetImageFromCurrentImageContext();

				UIGraphics.EndImageContext();

				break;
			}
		}



		public override void TouchesEnded (NSSet touches, UIEvent evt)
		{
			// base.TouchesEnded(touches, evt);

			if (!TrapState.Shared.HasActiveSnapshotImage) return;


			switch (Tool) {
			case Annotate.Tool.Callout:

				var rect = new CGRect (new CGPoint (pathStart.X - 16, pathStart.Y - 14), new CGSize (32, 28));
				// let rect = CGRect(origin: CGPoint(x: pathStart.x - 3, y: pathStart.y - 32), size: CGSize(width: 28, height: 24))

				var callout = new CalloutAnnotation (calloutCount, rect, bzPath.LineWidth, strokeColor);

				annotationDataCache.Add(callout);

				redrawBitmap();

				break;
			case Annotate.Tool.Marker:
			case Annotate.Tool.Arrow:
			case Annotate.Tool.Circle:
			case Annotate.Tool.Square:

				if (Tool == Annotate.Tool.Marker) UIGraphics.EndImageContext();
				
				if (touchesDidMove) {

					var annotation = new PathAnnotation (Tool, bzPath, strokeColor);

					annotationDataCache.Add(annotation);

					redrawBitmap();
				}

				break;
			case Annotate.Tool.Color:
				break;
			}

			bzPath.RemoveAllPoints();

			pathStart = CGPoint.Empty;

			counter = 0;

			touchesDidMove = false;
		}



		public override void TouchesCancelled (NSSet touches, UIEvent evt)
		{
			TouchesEnded(touches, evt);
			// base.TouchesCancelled(touches, evt);
		}


		[Export("redrawBitmap")]
		void redrawBitmap ()
		{
			if (!TrapState.Shared.HasActiveSnapshotImage) return;

			annotationDataCacheHasChangesSinceChecked = true;

			var setup = isRedrawingAfterOrientationChange || displayRect == CGRect.Empty;

			if (setup) {

				var imageSize = TrapState.Shared.ActiveSnapshotImage.Size;

				var scale = (nfloat)Math.Min(Bounds.Size.Width / imageSize.Width, Bounds.Size.Height / imageSize.Height);

				var scaledSize = CGAffineTransform.MakeScale(scale, scale).TransformSize(imageSize);

				contextRect = new CGRect (CGPoint.Empty, imageSize);

				displayRect = new CGRect (new CGPoint (Bounds.GetMidX() - scaledSize.Width / 2, Bounds.GetMidY() - scaledSize.Height / 2), scaledSize);

				bufferRect = new CGRect (CGPoint.Empty, scaledSize);

				var displayScale = (nfloat)Math.Max(imageSize.Width / Bounds.Size.Width, imageSize.Height / Bounds.Size.Height);

				displayTransform = CGAffineTransform.MakeScale(displayScale, displayScale);


				bufferImageView = new UIImageView (displayRect);
				bufferImageView.BackgroundColor = Colors.Clear;
				AddSubview(bufferImageView);
			}

			UIGraphics.BeginImageContextWithOptions(contextRect.Size, true, 1);

			strokeColor.SetStroke();

			if (IncrementImage != null) {

				IncrementImage.Draw(CGPoint.Empty);
			} else {

				TrapState.Shared.ActiveSnapshotImage.Draw(contextRect);
			}


			if (AnnotateUndoManager.IsRedoing) {

				var undo = annotationDataCacheArchive.LastOrDefault();
				if (undo != null) {
					annotationDataCacheArchive.Remove(undo);
					annotationDataCache.Add(undo);
				}
			}


			if (AnnotateUndoManager.IsUndoing) {

				TrapState.Shared.ActiveSnapshotImage.Draw(contextRect);

				var redo = annotationDataCache.LastOrDefault();
				if (redo != null) {
					annotationDataCache.Remove(redo);
					annotationDataCacheArchive.Add(redo);
				}
			}


			if (!isRedrawingAfterOrientationChange) {

				var context = UIGraphics.GetCurrentContext();

				context.SaveState();

				context.ConcatCTM(displayTransform);

				if (AnnotateUndoManager.IsUndoing) {

					calloutCount = 0;

					foreach (var data in annotationDataCache) {

						switch (data.Tool) {
						case Annotate.Tool.Callout:

							var callout = data as CalloutAnnotation;

							if (callout != null) {
								drawCallout(context, callout);
							}

							break;
						case Annotate.Tool.Marker:
						case Annotate.Tool.Arrow:
						case Annotate.Tool.Circle:
						case Annotate.Tool.Square:

							var annotation = data as PathAnnotation;

							if (annotation != null) {
								annotation.Color.SetStroke();
								annotation.Path.Stroke();

								if (data.Tool == Annotate.Tool.Arrow) {
									annotation.Color.SetFill();
									annotation.Path.Fill();
								}
							}

							break;
						case Annotate.Tool.Color:
							break;
						}
					}

				} else {

					var data = annotationDataCache.LastOrDefault(); // This takes care of redo

					if (data != null) {
					
						switch (data.Tool) {
						case Annotate.Tool.Callout:

							var callout = data as CalloutAnnotation;

							if (callout != null) {
								drawCallout(context, callout);
							}

							break;
						case Annotate.Tool.Marker:
						case Annotate.Tool.Arrow:
						case Annotate.Tool.Circle:
						case Annotate.Tool.Square:

							var annotation = data as PathAnnotation;

							if (annotation != null) {
								annotation.Color.SetStroke();
								annotation.Path.Stroke();

								if (data.Tool == Annotate.Tool.Arrow) {
									annotation.Color.SetFill();
									annotation.Path.Fill();
								}
							}

							break;
						case Annotate.Tool.Color:
							break;
						}
					}
				}

				context.RestoreState();
				
				AnnotateUndoManager.RegisterUndoWithTarget(this, new Selector ("redrawBitmap"), NSString.Empty);
			}

			isRedrawingAfterOrientationChange = false;

			IncrementImage = UIGraphics.GetImageFromCurrentImageContext();

			UIGraphics.EndImageContext();

			bufferImageView.Image = null;

			SetNeedsDisplay();
		}


		void drawCallout (CGContext context, CalloutAnnotation callout)
		{

			callout.Color.SetStroke();

			context.SaveState();

			callout.Clip.AddClip();
			callout.Path.Stroke();

			context.RestoreState();

			callout.Tail.Stroke();

			drawLabel(context, displayRect, displayRect.Height - callout.Center.Y, callout.Center.X, CTTextAlignment.Center, callout.Color, callout.CalloutString, true);

			calloutCount += 1;
		}


		void drawLabel (CGContext ctx, CGRect rect, nfloat yCoord, nfloat xCoord, CTTextAlignment alignment, UIColor color, string label, bool flipContext = true)
		{

			Console.WriteLine("Finish Draw code");

			var attrString = new NSMutableAttributedString (label);

			var range = new NSRange (0, attrString.Length);

			var uiFont = UIFont.FromName("HelveticaNeue-Medium", range.Length > 1 ? 15 : 22);

			var font = new CTFont (uiFont.Name, uiFont.PointSize);  //((uiFont.Name as NSString) as CFString, uiFont.pointSize, nil);

			var path = new CGPath ();

			var alignStyle = new CTParagraphStyle (new CTParagraphStyleSettings { Alignment = alignment });

			var attributes = new CTStringAttributes {
				Font = font,
				ForegroundColor = color.CGColor,
				ParagraphStyle = alignStyle
			};

			attrString.SetAttributes(attributes, new NSRange (0, attrString.Length));

			var target = new CGSize (nfloat.MaxValue, nfloat.MaxValue);

			var fit = new NSRange (0, 0);

			var framesetter = new CTFramesetter (attrString);

			var frameSize = framesetter.SuggestFrameSize(range, null, target, out fit);

			var textRect = new CGRect (xCoord - (frameSize.Width / 2), yCoord - (frameSize.Height / 2), frameSize.Width, frameSize.Height);

			path.AddRect(textRect);

			var frame = framesetter.GetFrame(range, path, null);

			if (flipContext) {

				ctx.SaveState();

				ctx.TranslateCTM(0, rect.Height);

				ctx.ScaleCTM(1, -1);

				frame.Draw(ctx);

				ctx.RestoreState();

			} else {
				frame.Draw(ctx);
			}
		}
	}
}
