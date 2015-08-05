using System;
using UIKit;
using CoreGraphics;
using System.Collections.Generic;

namespace bugTrapKit
{
	public class CalloutAnnotation : IAnnotationData
	{
		static int aCount = 26;
		const string plus = "+";

		static readonly List<string> alphebet = new List<string> {
			"A",
			"B",
			"C",
			"D",
			"E",
			"F",
			"G",
			"H",
			"I",
			"J",
			"K",
			"L",
			"M",
			"N",
			"O",
			"P",
			"Q",
			"R",
			"S",
			"T",
			"U",
			"V",
			"W",
			"X",
			"Y",
			"Z"
		};

		public int Count { get; private set; }

		public UIBezierPath Path { get; private set; }

		public UIBezierPath Clip { get; private set; }

		public UIBezierPath Tail { get; private set; }

		public CGRect Rect { get; private set; }

		public CGPoint Center { get; private set; }

		#region IAnnotationData implementation

		public UIColor Color { get; private set; }

		public Annotate.Tool Tool { 
			get { return Annotate.Tool.Callout; }
		}

		#endregion


		public CalloutAnnotation (int count, CGRect rect, nfloat lineWidth, UIColor color)
		{
			Path = UIBezierPath.FromOval(rect);
			Path.LineWidth = lineWidth;

			var center = new CGPoint (rect.GetMidX(), rect.GetMidY());

			Center = center;

			nfloat startAngle = (nfloat)(Math.PI * 0.75);
			nfloat endAngle = (nfloat)(Math.PI * 0.60);

			Clip = UIBezierPath.FromArc(center, center.X + lineWidth, startAngle, endAngle, true);
			Clip.AddLineTo(center);
			Clip.ClosePath();
			Clip.LineWidth = lineWidth;

			Tail = new UIBezierPath ();
			Tail.MoveTo(new CGPoint (center.X - 11, center.Y + 9));
			Tail.AddLineTo(new CGPoint (center.X - 11, center.Y + 18));
			Tail.AddLineTo(new CGPoint (center.X - 3, center.Y + 13));
			Tail.LineWidth = lineWidth;

			Rect = rect;
			Color = color;
			Count = count;
		}

		public string CalloutString {
			get { return (Count < aCount) ? alphebet[Count] : (Count < (aCount * 2)) ? alphebet[Count - aCount].doubleString() : plus; }
		}
	}
}