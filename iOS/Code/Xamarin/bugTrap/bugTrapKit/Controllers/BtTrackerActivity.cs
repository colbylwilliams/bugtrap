using System;
using UIKit;
using Foundation;

namespace bugTrapKit
{
	public class BtTrackerActivity : UIActivity
	{
		TrackerType trackerType;
		readonly string title;
		readonly UIImage icon;

		public BtTrackerActivity (TrackerType trackerType)
		{
			this.trackerType = trackerType;
			title = trackerType.ToString();
			icon = UIImage.FromBundle(trackerType.ActivityImageName());
		}

		public BtTrackerActivity (IntPtr handle) : base(handle)
		{
			
		}

		[Export("activityCategory")] 
		public new static UIActivityCategory Category {
			get {
				return UIActivityCategory.Share;
			}
		}

		public override UIImage Image {
			get { return icon; }
		}

		public override string Title {
			get { return title; }
		}

		public override NSString Type {
			get { return new NSString (trackerType.ActivityType()); }
		}

		public override bool CanPerform (NSObject[] activityItems)
		{
			return true;
		}

		public override void Prepare (NSObject[] activityItems)
		{

		}

		public override UIViewController ViewController {
			get {
				var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

				// if (TrackerService.Shared.SetCurrentTrackerType(trackerType) && TrackerService.Shared.CurrentTracker != null && TrackerService.Shared.CurrentTracker.Authenticated) {
				if (true) {
					
					if (TrapState.Shared.InActionExtension) {

						return kitStoryboard.Instantiate<BtNewBugDetailsNavigationController>();
					} else {
						var imageNavigationController = kitStoryboard.Instantiate<BtImageNavigationController>();

						if (imageNavigationController != null) {
							imageNavigationController.SelectingSnapshotImagesForExport = true;
							return imageNavigationController;
						}
							
						Analytics.Shared.Activity(trackerType.ActivityType(), false);
						return null;
					}
				}
				return kitStoryboard.Instantiate<BtSettingsNavigationController>();
			}
		}

		public override void Perform ()
		{
			Finished(true);
		}
	}
}

