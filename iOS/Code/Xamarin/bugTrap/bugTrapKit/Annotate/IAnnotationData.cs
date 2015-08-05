using System;
using UIKit;

namespace bugTrapKit
{
	public interface IAnnotationData
	{
		UIColor Color { get; }

		Annotate.Tool Tool { get; }
	}
}