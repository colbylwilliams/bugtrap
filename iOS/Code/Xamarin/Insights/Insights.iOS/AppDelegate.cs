using Foundation;
using UIKit;

namespace Insights.iOS
{
	[Register("AppDelegate")]
	public class AppDelegate : UIApplicationDelegate
	{
		public override UIWindow Window { get; set; }

		public override bool FinishedLaunching (UIApplication application, NSDictionary launchOptions)
		{
			
			bugTrapKit.bugTrapKit.Shared.Init();

			return true;
		}
	}
}