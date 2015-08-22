using UIKit;
using ServiceStack;

namespace bugTrapKit
{
	public sealed class bugTrapKit
	{
		static readonly bugTrapKit shared = new bugTrapKit { BtWindow = new BtOverlayWindow () };

		public static bugTrapKit Shared {
			get {
				return shared;
			}
		}

		internal BtOverlayWindow BtWindow;

		bugTrapKit ()
		{

		}

		public void Init ()
		{
//			TrapState.Shared.InActionExtension = true;

			shared.BtWindow.Frame = UIScreen.MainScreen.Bounds;
			shared.BtWindow.WindowLevel = UIWindowLevel.StatusBar;
			shared.BtWindow.MakeKeyAndVisible();

			EnsureAppearance();
		}

		void EnsureAppearance ()
		{

		}

		public void ToggleTriggerVisibility ()
		{
			var root = shared.BtWindow.RootViewController as BtOverlayViewController;

			if (root != null) root.ToggleTriggerVisibility();
		}


		public static UIViewController GetInitialController ()
		{
			// Configure ServiceStack Exprot Client
			IosPclExportClient.Configure();

			TrackerService.Shared.Authenticate();

			return UIStoryboard.FromName("bugTrapKit", null).InstantiateInitialViewController();
		}
	}
}