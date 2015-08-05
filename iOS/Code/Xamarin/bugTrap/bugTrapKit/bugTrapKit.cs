using System;
using UIKit;

namespace bugTrapKit
{
	public class bugTrapKit
	{
		public static UIViewController GetInitialController ()
		{
			return UIStoryboard.FromName("bugTrapKit", null).InstantiateInitialViewController();
		}
	}
}