using System;
using UIKit;
using System.Threading.Tasks;

namespace bugTrapKit
{
	public class BtNavigationController : UINavigationController
	{
		public BtNavigationController ()
		{
			
		}

		public BtNavigationController (IntPtr handle) : base(handle)
		{

		}


		public override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			if (TrapState.Shared.InActionExtension) {
				NavigationBar.BarTintColor = null;
				NavigationBar.TintColor = Colors.Theme;
				NavigationBar.TitleTextAttributes.ForegroundColor = Colors.Black;
			}
		}

		public Task PresentNewBugDetailsNavController (bool animate)
		{
			var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

			var newBugDetailsNavController = kitStoryboard.Instantiate<BtNewBugDetailsNavigationController>();
			if (newBugDetailsNavController != null) {
				return PresentViewControllerAsync(newBugDetailsNavController, animate);
			}
			return null;
		}


		public Task PresentAnnotateImageNavController (bool animate)
		{
			var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

			var annotateImageNavController = kitStoryboard.Instantiate<BtAnnotateImageNavigationController>();
			if (annotateImageNavController != null) {
				return PresentViewControllerAsync(annotateImageNavController, animate);
			}
			return null;
		}


		public override bool PrefersStatusBarHidden () => true;

		public override UIStatusBarStyle PreferredStatusBarStyle () => UIStatusBarStyle.LightContent;
	}
}