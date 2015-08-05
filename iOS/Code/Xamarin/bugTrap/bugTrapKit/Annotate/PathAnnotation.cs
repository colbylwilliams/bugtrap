using System;
using UIKit;

namespace bugTrapKit
{
	public class PathAnnotation : IAnnotationData
	{
		public UIBezierPath Path { get; private set; }

		#region IAnnotationData implementation

		public UIColor Color { get; private set; }

		public Annotate.Tool Tool { get; private set; }

		#endregion

		public PathAnnotation (Annotate.Tool tool, UIBezierPath path, UIColor color)
		{
			Tool = tool;

			var bzPath = UIBezierPath.FromPath(path.CGPath);
			bzPath.LineWidth = path.LineWidth;

			Path = bzPath;

			Color = color;
		}
	}
}