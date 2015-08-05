using System;
using System.Collections.Generic;
using System.Linq;

using CoreGraphics;
using Foundation;
using Octokit;
using UIKit;

namespace bugTrapKit
{
	public partial class BtAnnotateImageViewController : BtViewController, IUIViewControllerTransitioningDelegate, IUIPopoverPresentationControllerDelegate
	{

		BtImageNavigationController imageNavigationController {
			get { return (NavigationController as BtAnnotateImageNavigationController)?.ImageNavigationController; }
		}


		BtAnnotateImageView AnnotateView { 
			get { return View as BtAnnotateImageView; }
		}

		Annotate.Tool currentTool;

		Annotate.Tool CurrentTool {
			get { return currentTool; }
			set {
				currentTool = value;
				updateCurrentToolDependencies();
				Settings.AnnotateTool = currentTool;
			}
		}

		Annotate.Color currentColor;

		Annotate.Color CurrentColor {
			get { return currentColor; }
			set {
				currentColor = value;
				updateCurrentColorDependencies();
				Settings.AnnotateTool = currentTool;
			}
		}


		public BtAnnotateImageViewController (IntPtr handle) : base(handle)
		{
			
		}


		public /*async*/ override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			#if DEBUG
			// addToolAccessibilityLabels();
			// addColorAccessibilityLabels();
			#endif

			#region GitHub API Testing

//			var client = new GitHubClient (new ProductHeaderValue ("bugTrap"));
//
//			client.Credentials = new Credentials ("colbylwilliams", AppKeys.GitHubDevPersonalToken);
//
//			//krukow
//			// var user = await client.User.Get("krukow");
//			var user = await client.User.Current();
//			Console.WriteLine("{0} has {1} public repositories - go check out their profile at {2}",
//				user.Name,
//				user.PublicRepos,
//				user.Url);
//
//			var issues = await client.Issue.GetAllForCurrent(new IssueRequest { State = ItemState.All });
//
//			foreach (var issue in issues) {
//				Console.WriteLine(issue.Title);
//			}

			#endregion

			ScreenName = GAIKeys.ScreenNames.AnnotateSnapshot;

			#if !UITEST
			TrapState.Shared.GetAlbumLocalIdentifier();
			#endif

			// var tracker = TrackerService.Shared.CurrentTracker;

			ConfigureNavBarButtonsForContext();

			CurrentTool = Settings.AnnotateTool;
			CurrentColor = Settings.AnnotateColor;

			noImageView.Frame = AnnotateView.Bounds;

			actionButton.Enabled = false;
		}


		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			NavigationController.HidesBarsOnTap = CurrentTool != Annotate.Tool.Callout;

			// initial view controller in the context of an extension
			if (TrapState.Shared.InActionExtension && NavigationController?.ExtensionContext != null) {
				TrapState.Shared.SetActiveSnapshotImage(0);
				AnnotateView.RefreshLayoutAndImage();
			}

			if (!TrapState.Shared.HasActiveSnapshotImageIdentifier) {
				SaveCurrentSnapshotAndResetState(null, null);
			}

			#if UITEST
			var image = UIImage.FromBundle("test_screenshot");
			image.SaveToPhotosAlbum((i, e) => {
			});
			#endif
		}


		public override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			undoButton.Enabled = TrapState.Shared.HasActiveSnapshotImageIdentifier;
			redoButton.Enabled = TrapState.Shared.HasActiveSnapshotImageIdentifier;

			var hasImage = AnnotateView.IncrementImage != null;

			actionButton.Enabled = hasImage;

			if (!hasImage) {
				UIView.AnimateNotifyAsync(0.7, 1.8, 
					UIViewAnimationOptions.Repeat |
					UIViewAnimationOptions.Autoreverse |
					UIViewAnimationOptions.CurveEaseInOut |
					UIViewAnimationOptions.AllowUserInteraction, 
					() => titleButton.Alpha = titleButton.Alpha < 1 ? 1 : (nfloat)0.4
				);
			}
		}


		public override void ViewDidDisappear (bool animated)
		{
			base.ViewDidDisappear(animated);

			titleButton.Layer.RemoveAllAnimations();
			titleButton.Alpha = 1;
		}


		async partial void titleClicked (UIButton sender)
		{
			titleButton.Layer.RemoveAllAnimations();
			titleButton.Alpha = 1;

			if (imageNavigationController != null) { // this will be null in Action Extension

				if (AnnotateView.ImageHasChanges) { // has the image been altered?

					var annotatedImage = AnnotateView.IncrementImage;
					if (annotatedImage != null) {

						await TrapState.Shared.UpdateActiveSnapshotImage(annotatedImage);

						PresentViewController(imageNavigationController, true, null);
					}
				} else {
					PresentViewController(imageNavigationController, true, null);
				}
			} else {

				if (AnnotateView.ImageHasChanges) { // has the image been altered?

					var annotatedImage = AnnotateView.IncrementImage;
					if (annotatedImage != null) {

						await TrapState.Shared.UpdateActiveSnapshotImage(annotatedImage);

						PerformSegue("BtPopupImageCollectionViewController", this);
					}
				} else {
					PerformSegue("BtPopupImageCollectionViewController", this);
				}
			}
		}


		partial void settingsClicked (UIBarButtonItem sender)
		{
			(NavigationController as BtAnnotateImageNavigationController)?.PresentSettingsNavController(true);
		}


		// this is only called in the context of selecting an image in the BtNewBugDetailsTableViewController
		async partial void saveClicked (UIBarButtonItem sender)
		{
			var annotatedImage = AnnotateView.IncrementImage;

			if (annotatedImage != null) await TrapState.Shared.UpdateActiveSnapshotImage(annotatedImage);

			DismissViewController(true, null);
		}


		async partial void cancelClicked (UIBarButtonItem sender)
		{
			if (TrapState.Shared.InActionExtension && NavigationController?.ExtensionContext != null) {

				(NavigationController as BtAnnotateImageNavigationController)?.CompleteExtensionForCancel();
			} else {

				await DismissViewControllerAsync(true);

				TrapState.Shared.DeactivateActiveSnapshotImage();
			}
		}


		async partial void actionClicked (UIBarButtonItem sender)
		{
			var annotatedImage = AnnotateView.IncrementImage;

			if (annotatedImage != null) {

				var firstActivityItem = annotatedImage.AsJPEG(1);

				var applicationActivities = new List<UIActivity> ();

				// var donedoneActivity = BtTrackerActivity(TrackerType.DoneDone);

				applicationActivities.Add(new BtTrackerActivity (TrackerType.DoneDone));
				applicationActivities.Add(new BtTrackerActivity (TrackerType.PivotalTracker));
				applicationActivities.Add(new BtTrackerActivity (TrackerType.JIRA));

				var activityViewController = new UIActivityViewController (new [] { firstActivityItem }, applicationActivities.ToArray());

				activityViewController.ExcludedActivityTypes = new [] {
					UIActivityType.PostToWeibo,
					UIActivityType.AddToReadingList,
					UIActivityType.PostToVimeo,
					UIActivityType.PostToTencentWeibo
				};

				// This doesn't get called for the custom activities (BtTrackerActivity)
				activityViewController.SetCompletionHandler((activityType, completed, returnedItems, error) => {
					if (completed) {
						// if (activityType != null) Analytics.Shared.Activity(activityType.ToString(), true);
						Console.WriteLine("{0} -- Completed", activityType);
					} else if (error != null) {
						Console.WriteLine(error.LocalizedDescription);
						//Log.Error("UIActivityViewController", error.LocalizedDescription);
					} else if (activityType != null) {
						Console.WriteLine("{0} -- Cancelled", activityType);
						// Analytics.Shared.Activity(activityType.ToString(), false);
					}
				});

				// set the action but as the popover's anchor for ipad
				if (activityViewController.PopoverPresentationController != null) {
					activityViewController.PopoverPresentationController.BarButtonItem = actionButton;
				}

				// has the image been altered?
				if (AnnotateView.ImageHasChanges) await TrapState.Shared.UpdateActiveSnapshotImage(annotatedImage);

				NavigationController.PresentViewController(activityViewController, true, null);
			}
		}


		partial void undoClicked (UIBarButtonItem sender)
		{
			if (AnnotateView.AnnotateUndoManager.CanUndo) AnnotateView.AnnotateUndoManager.Undo();
			updateUndoRedoButtons();
		}


		partial void redoClicked (UIBarButtonItem sender)
		{
			if (AnnotateView.AnnotateUndoManager.CanRedo) AnnotateView.AnnotateUndoManager.Redo();
			updateUndoRedoButtons();
		}


		partial void barToolClicked (UIBarButtonItem sender)
		{
			if (Convert.ToInt32(sender.Tag) != (int)Annotate.Tool.Color) {
				CurrentTool = (Annotate.Tool)Convert.ToInt32(sender.Tag);
			} else {
				SetToolbarItems(barColors.OrderBy(b => b.Tag).ToArray(), true);
			}
		}


		partial void barColorClicked (UIBarButtonItem sender)
		{
			CurrentColor = (Annotate.Color)Convert.ToInt32(sender.Tag / 2);
			SetToolbarItems(barTools, true);
		}


		public async void SaveCurrentSnapshotAndResetState (nint? indexOfActiveSnapshot, string localIdentifierOfActiveSnapshot)
		{
			var inExtension = TrapState.Shared.InActionExtension;

			// one of the two had a value
			if (inExtension ? indexOfActiveSnapshot.HasValue : !string.IsNullOrEmpty(localIdentifierOfActiveSnapshot)) {

				if (!TrapState.Shared.HasActiveSnapshotImage) {

					AnnotateView.ResetContextAndState();

					if (inExtension) {

						TrapState.Shared.SetActiveSnapshotImage(indexOfActiveSnapshot.Value);
						// refresh to view with the new config / settings
						AnnotateView.RefreshLayoutAndImage();
					} else {
						await TrapState.Shared.SetActiveSnapshotImageAsync(localIdentifierOfActiveSnapshot);
						// refresh to view with the new config / settings
						AnnotateView.RefreshLayoutAndImage();
					}

					// the view was displaying the image at index TrapState.Shared.indexOfActiveSnapshot, so
					// save the state of that image and annotations, then switch to the index passed to this func
					// if TrapState.Shared.activeSnapshotImageLocalIdentifier != nil && TrapState.Shared.activeSnapshotImageLocalIdentifier != newLocalIdentifier {
				} else if (inExtension ? !TrapState.Shared.IsActiveSnapshot(indexOfActiveSnapshot.Value) : !TrapState.Shared.IsActiveSnapshot(localIdentifierOfActiveSnapshot)) {

					var annotatedImage = AnnotateView.IncrementImage;
					if (annotatedImage != null) {

						AnnotateView.ResetContextAndState();

						if (inExtension) {
							TrapState.Shared.SetActiveSnapshotImage(indexOfActiveSnapshot.Value);
							AnnotateView.RefreshLayoutAndImage();
						} else {
							await TrapState.Shared.SetActiveSnapshotImageAsync(localIdentifierOfActiveSnapshot);
							AnnotateView.RefreshLayoutAndImage();
						}
					} else {
						AnnotateView.ResetContextAndState();
					}

					// the view was displaying the image at index indexOfActiveSnapshotCache, so
					// save the image and annotations, then switch to the index passed to this func (newIndex)
				}

				// lose the "No Image" view, we have something to show
				if (noImageView.IsDescendantOfView(AnnotateView)) noImageView.RemoveFromSuperview();
			} else if (TrapState.Shared.HasActiveSnapshotImage) {

				if (noImageView.IsDescendantOfView(AnnotateView)) noImageView.RemoveFromSuperview();
			} else {
				AnnotateView.ResetContextAndState();
				// no image index to display, so let the user know
				AnnotateView.AddSubview(noImageView);
				actionButton.Enabled = false;
			}
		}


		void updateUndoRedoButtons ()
		{
			// undoButton.Enabled = AnnotateView.AnnotateUndoManager.CanUndo;
			redoButton.Enabled = AnnotateView.AnnotateUndoManager.CanRedo;
		}


		void updateCurrentToolDependencies ()
		{
			AnnotateView.ConfigureTool(CurrentTool);

			NavigationController.HidesBarsOnTap = CurrentTool != Annotate.Tool.Callout;

			foreach (var tool in barTools) {
				if (tool.Tag >= 0 && Convert.ToInt32(tool.Tag) != (int)Annotate.Tool.Color) {
					var bt = (Annotate.Tool)Convert.ToInt32(tool.Tag);
					tool.Image = bt == CurrentTool ? bt.imageOn(CurrentColor) : bt.image(CurrentColor);
				}
			}
		}


		void updateCurrentColorDependencies ()
		{
			var colorTool = barTools.FirstOrDefault(t => Convert.ToInt32(t.Tag) == (int)Annotate.Tool.Color);

			if (colorTool != null) colorTool.Image = Annotate.Tool.Color.image(CurrentColor);

			AnnotateView.ConfigureStroke(CurrentColor.color());
		}


		public override void PrepareForSegue (UIStoryboardSegue segue, NSObject sender)
		{
			if (segue.Identifier == "BtPopupImageCollectionViewController") {
				var popoverController = segue.DestinationViewController as BtPopupImageCollectionViewController;
				if (popoverController != null) {
					popoverController.PopoverPresentationController.Delegate = this;
					popoverController.PopoverPresentationController.SourceView = titleButton;
					popoverController.PreferredContentSize = new CGSize (300, 142);
				}
			}
		}


		UIModalPresentationStyle AdaptivePresentationStyleForPresentationController (UIPresentationController controller)
		{
			return UIModalPresentationStyle.None;
		}



		void ConfigureNavBarButtonsForContext ()
		{
			// extension uses the 'flipped' theme with white bars and red icons
			if (TrapState.Shared.InActionExtension) {
				titleButton.SetImage(UIImage.FromBundle("i_logo_web_red"), UIControlState.Normal);
			}

			// selected an existing screenshot from the new bug form - cancel, save
			var newBugDetailsNavController = NavigationController.PresentingViewController as BtNewBugDetailsNavigationController;
			if (newBugDetailsNavController != null) {
				NavigationItem.SetLeftBarButtonItems(new []{ cancelButton, undoButton }, false);
				NavigationItem.SetRightBarButtonItems(new []{ saveButton, redoButton }, false);
			} else if (TrapState.Shared.InActionExtension) {
				NavigationItem.SetLeftBarButtonItems(new []{ cancelButton, undoButton }, false);
				NavigationItem.SetRightBarButtonItems(new []{ actionButton, redoButton }, false);
			} else {
				NavigationItem.SetLeftBarButtonItems(new []{ settingsButton, undoButton }, false);
				NavigationItem.SetRightBarButtonItems(new []{ actionButton, redoButton }, false);
			}

			NavigationItem.TitleView = titleButton;
		}

		public override void TraitCollectionDidChange (UITraitCollection previousTraitCollection)
		{
			AnnotateView.RefreshLayoutAndImageForRotation();

			if (noImageView.IsDescendantOfView(AnnotateView)) {
				noImageView.Frame = AnnotateView.Bounds;
			}
		}


		public override bool PrefersStatusBarHidden () => true;

		public override UIStatusBarStyle PreferredStatusBarStyle () => UIStatusBarStyle.LightContent;
	}
}