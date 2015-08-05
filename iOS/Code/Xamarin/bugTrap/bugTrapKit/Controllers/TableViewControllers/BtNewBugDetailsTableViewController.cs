using System;

using Foundation;
using UIKit;
using Photos;
using System.Collections.Generic;
using CoreGraphics;
using System.Linq;

namespace bugTrapKit
{
	public partial class BtNewBugDetailsTableViewController : BtTableViewController, IUICollectionViewSource, IUICollectionViewDelegateFlowLayout
	{
		// nfloat scale => UIScreen.MainScreen.Scale;
		CGSize thumbSize;

		bool didAssignTitleFirstResponder;
		NSIndexPath datePickerIndexPath;

		bool datePickerCellOpen;

		PHFetchResult assetsFetchResult;
		Dictionary<int, int> imageRequests = new Dictionary<int, int> ();

		PHFetchOptions options = new PHFetchOptions ();

		public BtNewBugDetailsTableViewController (IntPtr handle) : base(handle)
		{
			
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			ScreenName = $"{GAIKeys.ScreenNames.BugDetails} ({TrackerService.Shared.CurrentTracker})";

			thumbSize = new CGSize (125.0 * UIScreen.MainScreen.Scale, 125.0 * UIScreen.MainScreen.Scale);

			options.SortDescriptors = new [] { new NSSortDescriptor ("modificationDate", false) };

			assetsFetchResult = PHAsset.FetchAssetsUsingLocalIdentifiers(TrapState.Shared.LocalIdentifiersForActiveSnapshots, options);
		}


		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			NavigationController.HidesBarsOnTap = false;

			if (!IsMovingToParentViewController) {
				var state = TrackerService.Shared.CurrentTracker.TrackerState;
				TableView.ReloadSections(NSIndexSet.FromIndex(state.ActiveBugDetail), UITableViewRowAnimation.Automatic);
			}

			assetsFetchResult = PHAsset.FetchAssetsUsingLocalIdentifiers(TrapState.Shared.LocalIdentifiersForActiveSnapshots, options);
			reloadEmbeddedImageCollectinView();
		}

		void reloadEmbeddedImageCollectinView ()
		{
			if (TrapState.Shared.HasSnapshotImages) {
				var imageCell = TableView.VisibleCells.FirstOrDefault(c => c is BtEmbeddedImageCollectionViewTableViewCell) as BtEmbeddedImageCollectionViewTableViewCell;
				if (imageCell != null) imageCell.ReloadCollectionView();
			}
		}

		public override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			validateBugDetails();

			var state = TrackerService.Shared.CurrentTracker.TrackerState;
			if (state.IsActiveTopLevelDetail && state.HasProject) {
				var textFieldCell = TableView.VisibleCells.FirstOrDefault(c => c is BtTextFieldTableViewCell) as BtTextFieldTableViewCell;
				if (textFieldCell != null) didAssignTitleFirstResponder = textFieldCell.TextFieldShouldBecomeFirstResponder();
			}
		}

		public override bool CanBecomeFirstResponder {
			get {
				return true;
			}
		}

		public override bool BecomeFirstResponder ()
		{
			validateBugDetails();

			if (didAssignTitleFirstResponder) {
				didAssignTitleFirstResponder = false;

				var textViewCell = TableView.VisibleCells.FirstOrDefault(c => c is BtTextViewTableViewCell) as BtTextViewTableViewCell;

				if (textViewCell != null) {
					TableView.ScrollRectToVisible(TableView.RectForRowAtIndexPath(TableView.IndexPathForCell(textViewCell)), true);
					textViewCell.TextViewShouldBecomeFirstResponder();
				}
			}

			return true;
		}


		#region TableViewSource

		public override nint NumberOfSections (UITableView tableView)
		{
			return TrackerService.Shared.CurrentTracker.TrackerState.TrackerDetailCells.Count;
		}

		public override nint RowsInSection (UITableView tableview, nint section)
		{
			return TrackerService.Shared.CurrentTracker.TrackerState.GetTrackerDetailCell((int)section, false).BugDetailType.IsDate() && datePickerCellOpen ? 2 : 1;
		}


		public override UITableViewCell GetCell (UITableView tableView, NSIndexPath indexPath)
		{
			if (indexPath.Row > 0) return tableView.DequeueReusableCell(BugDetails.DetailType.DatePicker.CellId(), indexPath); //as BtNewBugDetailsTableViewCell;

			var cellData = TrackerService.Shared.CurrentTracker.TrackerState.GetTrackerDetailCell(indexPath.Section, true);

			var cell = tableView.DequeueReusableCell(cellData.BugDetailType.CellId(), indexPath) as BtNewBugDetailsTableViewCell;

			cell.SetData(cellData);

			return cell;
		}


		public override nfloat GetHeightForRow (UITableView tableView, NSIndexPath indexPath)
		{
			if (indexPath.Row > 0) return 163;

			// TrackerService.Shared.CurrentTracker.TrackerState.GetTrackerDetailCell(indexPath.Section).CellHeight

			return 44;
		}


		public override void RowSelected (UITableView tableView, NSIndexPath indexPath)
		{
			tableView.CellAt(indexPath).Selected = false;

			TrackerService.Shared.CurrentTracker.TrackerState.ActiveBugDetail = indexPath.Section;

			var cellType = TrackerService.Shared.CurrentTracker.TrackerState.GetActiveCellType();

			if (cellType == BugCellTypes.Selection) {
				var newBugDetailSelectTvController = Storyboard.Instantiate<BtNewBugDetailsSelectTableViewController>();
				ShowViewController(newBugDetailSelectTvController, this);
			} else if (cellType == BugCellTypes.Date) {
				datePickerIndexPath = NSIndexPath.FromRowSection(1, indexPath.Section);
				datePickerCellOpen = !datePickerCellOpen;
			}
		}


		#endregion

		partial void tapRecognized (UITapGestureRecognizer sender)
		{
			didAssignTitleFirstResponder = false;
			validateBugDetails();
			View.EndEditing(true);
		}


		partial void cancelClicked (UIBarButtonItem sender)
		{
			TrapState.Shared.ResetSnapshotImages();
			dismissControllerAndResetTrapState(false);
			TrackerService.Shared.SetCurrentTrackerType(TrackerType.None);
		}


		partial void saveClicked (UIBarButtonItem sender)
		{
			NavigationController.DismissViewController(true, null);
		}


		async partial void submitClicked (UIBarButtonItem sender)
		{
			if (validateBugDetails()) {

				if (TrapState.Shared.InActionExtension) activityIndicator.Color = Colors.Theme;

				NavigationItem.SetRightBarButtonItem(activityButton, true);

				await TrackerService.Shared.CurrentTracker.CreateIssue();

				dismissControllerAndResetTrapState(true);
			}
		}


		partial void datePickerValueChanged (UIDatePicker sender)
		{
			var dateDisplayCell = TableView.VisibleCells.FirstOrDefault(c => c is BtDateDisplayTableViewCell) as BtDateDisplayTableViewCell;

			if (dateDisplayCell != null) {
				TrackerService.Shared.CurrentTracker.TrackerState.BugDueDate = sender.Date.NSDateToDateTime();

				var index = TableView.IndexPathForCell(dateDisplayCell);
				if (index != null) TableView.ReloadRows(new [] { index }, UITableViewRowAnimation.None);
			}
		}


		void dismissControllerAndResetTrapState (bool successful)
		{
			NavigationItem.SetRightBarButtonItem(submitButton, true);

			if (TrapState.Shared.InActionExtension) {

				if (NavigationController.ExtensionContext != null) {

					var navController = NavigationController as BtAnnotateImageNavigationController;

					if (navController != null) {
						if (successful) navController.CompleteExtensionForSubmit();
						else navController.CompleteExtensionForCancel();
					}
				} else {
					
					var navController = PresentingViewController.ChildViewControllers.FirstOrDefault() as BtAnnotateImageNavigationController;

					if (navController != null && navController.ExtensionContext != null) {
						if (successful) navController.CompleteExtensionForSubmit();
						else navController.CompleteExtensionForCancel();
					}
				}
			} else {

				TrapState.Shared.ResetSnapshotImages();

				TrackerService.Shared.ResetAndRemoveCurrentTracker();

				NavigationController.DismissViewController(true, null);
			}
		}


		bool validateBugDetails ()
		{
			var state = TrackerService.Shared.CurrentTracker.TrackerState;
			if (state != null) {

				var textFieldCell = TableView.VisibleCells.FirstOrDefault(c => c is BtTextFieldTableViewCell) as BtTextFieldTableViewCell;
				if (textFieldCell != null && textFieldCell.TxtField.HasText) state.BugTitle = textFieldCell.TxtField.Text;


				var textViewCell = TableView.VisibleCells.FirstOrDefault(c => c is BtTextViewTableViewCell) as BtTextViewTableViewCell;
				if (textViewCell != null && textViewCell.TxtView.HasText) state.BugDescription = textViewCell.TxtView.Text;

				submitButton.Enabled = state.IsValid;

				return state.IsValid;
			}

			return false;
		}


		CGSize standardSize = new CGSize (70, 125);

		CGSize getScaledSizeForAsset (PHAsset asset, bool scaleSize)
		{
			var size = new CGSize (asset.PixelWidth, asset.PixelHeight);

			var scaled = standardSize.Height / size.Height;

			if (scaleSize) scaled *= UIScreen.MainScreen.Scale;

			return CGAffineTransform.MakeScale(scaled, scaled).TransformSize(size);
		}


		#region IUICollectionViewSource

		static string addSnapshotCell = "BtEmbeddedAddImageCollectionViewCell", snapshotCell = "BtEmbeddedImageCollectionViewCell";

		[Export("numberOfSectionsInCollectionView:")]
		public nint NumberOfSections (UICollectionView collectionView)
		{
			return 1;
		}

		nint IUICollectionViewDataSource.GetItemsCount (UICollectionView collectionView, nint section)
		{
			var assetFetchResultCount = assetsFetchResult?.Count ?? 0;

			return TrapState.Shared.InActionExtension ? TrapState.Shared.ExtensionSnapshotImageCount : assetFetchResultCount + 1;
		}

		UICollectionViewCell IUICollectionViewDataSource.GetCell (UICollectionView collectionView, NSIndexPath indexPath)
		{
			if (TrapState.Shared.InActionExtension) {
				var aCell = collectionView.DequeueReusableCell(snapshotCell, indexPath) as BtEmbeddedImageCollectionViewCell;
				aCell.SetData(TrapState.Shared.GetExtensionSnapshotImageAtIndex(indexPath.Item));
				return aCell;
			}

			if (indexPath.Item == 0) return collectionView.DequeueReusableCell(addSnapshotCell, indexPath) as UICollectionViewCell;


			var cell = collectionView.DequeueReusableCell(snapshotCell, indexPath) as BtEmbeddedImageCollectionViewCell;

			var manager = PHImageManager.DefaultManager;

			var key = Convert.ToInt32(indexPath.Item) - 1;

			int request = 0;

			if (imageRequests.TryGetValue(key, out request)) manager.CancelImageRequest(request);

			var asset = assetsFetchResult[key] as PHAsset;

			var val = manager.RequestImageForAsset(asset, getScaledSizeForAsset(asset, true), PHImageContentMode.AspectFill, null, (result, info) => cell.SetData(result));

			if (imageRequests.ContainsKey(key)) imageRequests[key] = val;
			else imageRequests.Add(key, val);

			return cell;
		}



		[Export("collectionView:didSelectItemAtIndexPath:")]
		public async void ItemSelected (UICollectionView collectionView, NSIndexPath indexPath)
		{
			if (TrapState.Shared.InActionExtension) {
			
				TrapState.Shared.SetActiveSnapshotImage(indexPath.Item);
				displayAnnotateImageNavigationController();
			
			} else if (indexPath.Item == 0) {

				var annotateImageNavController = PresentingViewController.ChildViewControllers?.FirstOrDefault() as BtAnnotateImageNavigationController ?? PresentingViewController as BtAnnotateImageNavigationController;
				if (annotateImageNavController != null) {

					await DismissViewControllerAsync(true);

					var imageNavController = annotateImageNavController?.ImageNavigationController;
					if (imageNavController != null) {
					
						imageNavController.SelectingSnapshotImagesForExport = true;
						annotateImageNavController.PresentViewController(imageNavController, true, null);
					}
				}

				return;
			
			} else {

				var asset = assetsFetchResult[indexPath.Item - 1] as PHAsset;

				await TrapState.Shared.SetActiveSnapshotImageAsync(asset.LocalIdentifier);

				displayAnnotateImageNavigationController();
			}
		}


		void displayAnnotateImageNavigationController ()
		{
			var annotateImageNavController = Storyboard.Instantiate<BtAnnotateImageNavigationController>();
			PresentViewController(annotateImageNavController, true, null);
		}


		[Export("collectionView:layout:sizeForItemAtIndexPath:")]
		public CGSize GetSizeForItem (UICollectionView collectionView, UICollectionViewLayout layout, NSIndexPath indexPath)
		{
			if (TrapState.Shared.InActionExtension) {

				var size = TrapState.Shared.GetExtensionSnapshotImageAtIndex(indexPath.Item)?.Size ?? CGSize.Empty;

				if (size == CGSize.Empty) return standardSize;

				var scaled = standardSize.Height / size.Height;

				return CGAffineTransform.MakeScale(scaled, scaled).TransformSize(size);
			}

			if (indexPath.Item == 0) return standardSize;

			var index = indexPath.Item - 1;

			var asset = assetsFetchResult[index] as PHAsset;

			return getScaledSizeForAsset(asset, false);
		}

		#endregion


		public override bool PrefersStatusBarHidden ()
		{
			return true;
		}

		public override UIStatusBarStyle PreferredStatusBarStyle ()
		{
			return UIStatusBarStyle.LightContent;
		}
	}
}
