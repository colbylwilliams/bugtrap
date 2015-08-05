using System;
using UIKit;

namespace bugTrapKit
{
	public class BtCollectionViewController : UICollectionViewController
	{
		public BtCollectionViewController ()
		{
		}

		public BtCollectionViewController (IntPtr handle) : base(handle)
		{

		}

		public string ScreenName { get; set; }

		public override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			UpdateScreenName();
		}

		public void UpdateScreenName ()
		{
			if (!string.IsNullOrWhiteSpace(ScreenName)) {
				// Analytics.Shared.ScreenView(screenName);
			}
		}

		public void UpdateScreenName (string name)
		{
			if (name != ScreenName) {
				ScreenName = name;
				UpdateScreenName();
			}
		}

		public override bool PrefersStatusBarHidden () => true;

		public override UIStatusBarStyle PreferredStatusBarStyle () => UIStatusBarStyle.LightContent;
	}
}