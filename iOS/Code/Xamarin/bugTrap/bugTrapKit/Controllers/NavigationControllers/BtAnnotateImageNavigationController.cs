

using System;

using Foundation;
using UIKit;
using MobileCoreServices;
using System.Threading.Tasks;

namespace bugTrapKit
{
	public partial class BtAnnotateImageNavigationController : BtNavigationController
	{

		// UIView snap;
		// UIView snapshot;
		// UIView container;

		bool continueNewBugFlowOnDidAppear;
		bool manuallyInitiatedSettingsFlow;

		public BtImageNavigationController ImageNavigationController { get; set; }


		public BtAnnotateImageNavigationController (IntPtr handle) : base(handle)
		{
			Settings.RegisterDefaultSettings();
			var bootstrap = Analytics.Shared;
		}

		public override void LoadView ()
		{
			base.LoadView();

			var context = ExtensionContext;

			if (context != null) {

				TrapState.Shared.InActionExtension = true;

				foreach (var inputItem in context.InputItems) {

//					var item = inputItem //as NSExtensionItem;
//					if (item != null) {

					var providers = inputItem.Attachments;

					foreach (var provider in providers) {

						if (provider.HasItemConformingTo(UTType.Image.ToString())) {
							
							provider.LoadItem(UTType.Image.ToString(), null, (data, error) => {

								var nsData = NSData.FromUrl(data as NSUrl);
								if (nsData != null) {

									var image = new UIImage (nsData);
									if (image != null) {

										TrapState.Shared.AddSnapshotImage(image, TrapState.Shared.HasActiveSnapshotImageIdentifier);
									}
								}
							});
						}
					}
//				}
				}

			} else if (ImageNavigationController == null) {

				var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

				ImageNavigationController = kitStoryboard.Instantiate<BtImageNavigationController>();
				ImageNavigationController.ModalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
			}
		}

		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			if (!manuallyInitiatedSettingsFlow) {

				var presentedController = PresentedViewController as BtSettingsNavigationController;
				if (presentedController != null) {

					//continueNewBugFlowOnDidAppear = TrackerService.Shared.HasCurrentAuthenticatedTracker;

					if (!continueNewBugFlowOnDidAppear) {

						//TrackerService.Shared.SetCurrentTrackerType(.None)
					}
				}
			} else {
				manuallyInitiatedSettingsFlow = false;
				// TrackerService.Shared.SetCurrentTrackerType(.None)
			}

			if (ExtensionContext != null) {

				SetNavigationBarHidden(true, false);
				SetToolbarHidden(true, false);
			}
		}

		public override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			if (ExtensionContext != null) {

				SetNavigationBarHidden(false, true);
				SetToolbarHidden(false, true);
			}

			if (continueNewBugFlowOnDidAppear) {

				if (ExtensionContext != null) {

					var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

					var controller = kitStoryboard.Instantiate<BtNewBugDetailsNavigationController>();
					if (controller != null) {

						PresentViewController(controller, true, null);
					}
				} else if (ImageNavigationController != null) {

					ImageNavigationController.SelectingSnapshotImagesForExport = true;
					PresentViewController(ImageNavigationController, true, null);
				}

				continueNewBugFlowOnDidAppear = false;
			}
		}


		public void CompleteExtensionForSubmit ()
		{
			if (ExtensionContext != null) {
				extensionTrapState();
				ExtensionContext.CompleteRequest(ExtensionContext.InputItems, null);
			}	
		}


		public void CompleteExtensionForCancel ()
		{
			if (ExtensionContext != null) {
				extensionTrapState();
				ExtensionContext.CancelRequest(new NSError (new NSString ("bugTrap"), 0, null));
			}	
		}


		public void /*async Task*/ PresentSettingsNavController (bool animate)
		{
			manuallyInitiatedSettingsFlow = true;

			var kitStoryboard = UIStoryboard.FromName("bugTrapKit", null);

			var controller = kitStoryboard.Instantiate<BtSettingsNavigationController>();

			if (controller != null) PresentViewController(controller, animate, null);
		}

		void extensionTrapState ()
		{
			TrapState.Shared.ResetSnapshotImages();
			// TrackerService.Shared.resetAndRemoveCurrentTracker()
		}
	}
}