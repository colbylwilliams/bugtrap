using System;
using UIKit;
using CoreGraphics;

namespace bugTrapKit
{
	public class BtOverlayViewController : BtViewController
	{
		public bool InSdk { get; set; }

		public UITapGestureRecognizer TapGesture { get; set; }

		public UIPanGestureRecognizer PanGesture { get; set; }

		public UIImageView Trigger { get; set; }

		CGPoint triggerCenter;

		CGRect triggerCenterBoundsCache;

		public CGRect TriggerCenterBounds {
			get {
				if (triggerCenterBoundsCache == CGRect.Empty) {
					triggerCenterBoundsCache = new CGRect (UIScreen.MainScreen.Bounds.GetMidX() - 20f, UIScreen.MainScreen.Bounds.GetMidY() - (InSdk ? 20f : 100f), 40f, 40f);
				}
				return triggerCenterBoundsCache;
			}
		}

		static CGRect triggerBounds = UIScreen.MainScreen.Bounds.Inset(20f, 20f);

		public BtOverlayViewController ()
		{
			View = new BtOverlayView { Frame = UIScreen.MainScreen.Bounds };

			InitTrigger();

			InitGestureRecognizers();
		}

		//		public void EnsureBuildUp ()
		//		{
		//			base.BuildUp ();
		//		}

		void InitTrigger ()
		{
			Trigger = new UIImageView {
				Frame = TriggerCenterBounds,
				ContentMode = UIViewContentMode.ScaleAspectFit,
				Image = UIImage.FromBundle("i_trigger"),
				Alpha = 0.0f
			};

			// Trigger.Layer.CornerRadius = 20f;
			// Trigger.Layer.MasksToBounds = true;

			Trigger.UserInteractionEnabled = true;

			View.AddSubview(Trigger);
		}

		void InitGestureRecognizers ()
		{
			TapGesture = new UITapGestureRecognizer (HandleTapGestureAsync);
			PanGesture = new UIPanGestureRecognizer (HandlePanGesture);
		}

		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			Trigger.AddGestureRecognizer(TapGesture);
			Trigger.AddGestureRecognizer(PanGesture);
		}

		public async override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			var frame = new CGRect (4f, View.Bounds.Bottom - 94f, 40f, 40f);

			await UIView.AnimateAsync(1.0f, () => {
				Trigger.Alpha = 1.0f;
			});

			await UIView.AnimateAsync(0.8f, () => {
				Trigger.Frame = frame;
			});
		}

		public override void ViewWillDisappear (bool animated)
		{
			Trigger.RemoveGestureRecognizer(TapGesture);
			Trigger.RemoveGestureRecognizer(PanGesture);

			base.ViewWillDisappear(animated);
		}

		void HandlePanGesture (UIPanGestureRecognizer pan)
		{
			switch (pan.State) {
			case UIGestureRecognizerState.Changed:
				CGPoint translation = pan.TranslationInView(View);
				var center = new CGPoint (triggerCenter.X + translation.X, triggerCenter.Y + translation.Y);
				if (triggerBounds.Contains(center)) {
					Trigger.Center = center;
				}

				return;
			case UIGestureRecognizerState.Began:
				triggerCenter = Trigger.Center;
				return;
			case UIGestureRecognizerState.Ended:
				triggerCenter = CGPoint.Empty;
				return;
			}
		}

		async void HandleTapGestureAsync (UIGestureRecognizer tap)
		{
			if (tap.State == UIGestureRecognizerState.Recognized) {

				UIImage image;

				UIGraphics.BeginImageContextWithOptions(UIScreen.MainScreen.Bounds.Size, true, 0);

				UIApplication.SharedApplication.Windows[0].DrawViewHierarchy(UIScreen.MainScreen.Bounds, false);

				image = UIGraphics.GetImageFromCurrentImageContext();

				UIGraphics.EndImageContext();

//				image.SaveToPhotosAlbum((i, e) => {
//					
//				});

				await TrapState.Shared.AddSnapshotImageForSdk(image);

				// BugTrapState.SnapshotImage = image;

				var storyboard = UIStoryboard.FromName("bugTrapKit", NibBundle);

				var navController = storyboard.Instantiate<BtAnnotateImageNavigationController>();

				PresentViewController(navController, false, null);
			}
		}

		public void ToggleTriggerVisibility ()
		{
			Trigger.Hidden = !Trigger.Hidden;
		}
	}
}