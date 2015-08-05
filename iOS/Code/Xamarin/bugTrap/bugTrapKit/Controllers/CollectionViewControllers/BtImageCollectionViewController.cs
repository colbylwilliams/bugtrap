using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CoreGraphics;
using Foundation;
using Photos;
using UIKit;

namespace bugTrapKit
{
	public partial class BtImageCollectionViewController : BtCollectionViewController, IUICollectionViewDelegateFlowLayout, IPHPhotoLibraryChangeObserver
	{
		static nfloat size = (UIScreen.MainScreen.Bounds.Width - 6) / 4;
		static nfloat scale = UIScreen.MainScreen.Scale;

		const string storyboardId = "BtImageCollectionViewController", 
			imageCell = "BtImageCollectionViewCell", addImageCell = "BtAddImageCollectionViewCell";

		CGSize cellSize = CGSize.Empty, thumbSize = CGSize.Empty;
		bool selecting;
		List<NSIndexPath> editIndexes = new List<NSIndexPath> ();
		PHFetchOptions fetchOptions = new PHFetchOptions ();
		PHFetchResult assetsFetchResults;
		Dictionary<NSIndexPath, int> imageRequests = new Dictionary<NSIndexPath, int> ();


		bool selectingSnapshotImagesForExport {
			get {
				var navController = NavigationController as BtImageNavigationController;
				return navController?.SelectingSnapshotImagesForExport ?? false;
			}
			set {
				var navController = NavigationController as BtImageNavigationController;
				if (navController != null) navController.SelectingSnapshotImagesForExport = value;
			}
		}

		public BtImageCollectionViewController (IntPtr handle) : base(handle)
		{
			fetchOptions.SortDescriptors = new [] { new NSSortDescriptor ("modificationDate", false) };

			Task.Run(async() => {
				#if UITEST
				await Task.Delay(3000);
				#endif
				await TrapState.Shared.GetAlbumLocalIdentifier();
				assetsFetchResults = PHAsset.FetchAssets(PHAssetMediaType.Image, fetchOptions);
			});
		}


		public override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			ScreenName = GAIKeys.ScreenNames.SelectSnapshot;

			cellSize = new CGSize (size, size);
			thumbSize = new CGSize (cellSize.Width * scale, cellSize.Height * scale);

			noImageView.Frame = UIScreen.MainScreen.Bounds;

			CollectionView.AllowsMultipleSelection = true;
		}


		public override void ViewWillAppear (bool animated)
		{
			base.ViewWillAppear(animated);

			PHPhotoLibrary.SharedPhotoLibrary.RegisterChangeObserver(this);

			// var navController = NavigationController as BtImageNavigationController;
			// if (navController != null) selecting = navController.SelectingSnapshotImagesForExport;

			selecting = selectingSnapshotImagesForExport;

			updateViewConfiguration(false, updateScreenName: false, reloadData: true);

			var selectedIndexs = CollectionView.GetIndexPathsForSelectedItems();
			if (selectedIndexs != null) {
				foreach (var indexPath in selectedIndexs) {
					CollectionView.DeselectItem(indexPath, false);
				}
			}
		}


		public override void ViewDidDisappear (bool animated)
		{
			PHPhotoLibrary.SharedPhotoLibrary.UnregisterChangeObserver(this);

			base.ViewDidDisappear(animated);
		}


		#region PHPhotoLibraryChangeObserver

		List<NSIndexPath> indexPathsFromIndexSet (NSIndexSet indexSet)
		{
			List<NSIndexPath> indexPaths = new List<NSIndexPath> ();

			if (indexSet == null) return indexPaths;

			indexSet.EnumerateIndexes((nuint idx, ref bool stop) => indexPaths.Add(NSIndexPath.FromItemSection((nint)idx, 0)));

			return indexPaths;
		}


		public void PhotoLibraryDidChange (PHChange changeInstance)
		{
			BeginInvokeOnMainThread(() => {

				// check if there are changes to the assets (insertions, deletions, updates)
				var collectionChanges = changeInstance.GetFetchResultChangeDetails(assetsFetchResults);

				if (collectionChanges != null) {

					assetsFetchResults = collectionChanges.FetchResultAfterChanges;

					if (!collectionChanges.HasIncrementalChanges || collectionChanges.HasMoves) {

						CollectionView.ReloadData();

					} else {
					
						var removedIndexes = indexPathsFromIndexSet(collectionChanges.RemovedIndexes);

						var insertedIndexes = indexPathsFromIndexSet(collectionChanges.InsertedIndexes);

						var changedIndexes = indexPathsFromIndexSet(collectionChanges.ChangedIndexes);

						// if we have incremental diffs, tell the collection view to animate insertions and deletions
						CollectionView.PerformBatchUpdates(() => {

							if (!removedIndexes.IsEmpty()) CollectionView.DeleteItems(removedIndexes.ToArray());

							if (!insertedIndexes.IsEmpty()) CollectionView.InsertItems(insertedIndexes.ToArray());

							if (!changedIndexes.IsEmpty()) CollectionView.ReloadItems(changedIndexes.ToArray());

						}, null);
					}
				}
			});
		}

		#endregion

		public override UIBarButtonItem EditButtonItem {
			get { return editButton; }
		}


		public override nint NumberOfSections (UICollectionView collectionView)
		{
			return 1;
		}


		// nint itemCountForEconfigureation {
		// get { return TrapState.Shared.InActionExtension ? TrapState.Shared.ExtensionSnapshotImageCount : assetsFetchResults?.Count ?? 0; }
		// }

		public override nint GetItemsCount (UICollectionView collectionView, nint section)
		{
			return TrapState.Shared.InActionExtension ? TrapState.Shared.ExtensionSnapshotImageCount : assetsFetchResults?.Count ?? 0;
		}


		public override UICollectionViewCell GetCell (UICollectionView collectionView, NSIndexPath indexPath)
		{
			var cell = collectionView.DequeueReusableCell(imageCell, indexPath) as BtImageCollectionViewCell;

			if (TrapState.Shared.InActionExtension) {

				cell.SetData(TrapState.Shared.GetExtensionSnapshotImageAtIndex(indexPath.Item));

				cell.SetSelected(TrapState.Shared.IsActiveSnapshot(indexPath.Item));

			} else {

				var manager = PHImageManager.DefaultManager;

				if (imageRequests.ContainsKey(indexPath)) manager.CancelImageRequest(imageRequests[indexPath]);

				var asset = assetsFetchResults[indexPath.Item] as PHAsset;

				imageRequests[indexPath] = manager.RequestImageForAsset(asset, thumbSize, PHImageContentMode.AspectFill, null, 
					(result, info) => cell.SetData(result)
				);
			}

			return cell;
		}


		public override void ItemSelected (UICollectionView collectionView, NSIndexPath indexPath)
		{
			if (TrapState.Shared.InActionExtension) {
				SaveActiveSnapshotAndResetAnnotateImageView(indexPath.Item, null);
				return;
			}

			if (Editing && !editIndexes.Contains(indexPath)) {

				editIndexes.Add(indexPath);

			} else if (selecting) { // selecting images to add to an Issue

				var asset = assetsFetchResults?[indexPath.Item] as PHAsset;

				TrapState.Shared.AddSnapshotImage(asset.LocalIdentifier);

			} else {

				var asset = assetsFetchResults?[indexPath.Item] as PHAsset;

				var selectedItems = CollectionView.GetIndexPathsForSelectedItems().Where(ip => ip != indexPath);
				CollectionView.PerformBatchUpdates(() => {
					foreach (var item in selectedItems) {
						CollectionView.DeselectItem(item, true);
					}
				}, null);

				SaveActiveSnapshotAndResetAnnotateImageView(null, asset?.LocalIdentifier);
			}
		}

		public override bool ShouldSelectItem (UICollectionView collectionView, NSIndexPath indexPath)
		{
			return true;
		}

		public override bool ShouldDeselectItem (UICollectionView collectionView, NSIndexPath indexPath)
		{
			var deselect = Editing || selecting;

			if (deselect) SaveActiveSnapshotAndResetAnnotateImageView(null, TrapState.Shared.LocalIdentifiersForActiveSnapshot);

			return deselect;
		}


		public override void ItemDeselected (UICollectionView collectionView, NSIndexPath indexPath)
		{
			if (Editing) {

				editIndexes.Remove(indexPath);

			} else if (selecting) {

				var asset = assetsFetchResults?[indexPath.Item] as PHAsset;

				TrapState.Shared.RemoveSnapshotImage(asset?.LocalIdentifier);

				// may need to accout for this view presented over the new bug details tvc
				// TrackerService.Shared.setCurrentTrackerType(.None) // why?

			} else {

				var asset = assetsFetchResults?[indexPath.Item] as PHAsset;

				SaveActiveSnapshotAndResetAnnotateImageView(null, asset?.LocalIdentifier);
			}
		}


		[Export("collectionView:layout:sizeForItemAtIndexPath:")]
		public CGSize GetSizeForItem (UICollectionView collectionView, UICollectionViewLayout layout, NSIndexPath indexPath)
		{
			return cellSize;
		}


		void SaveActiveSnapshotAndResetAnnotateImageView (nint? indexForExtension, string localIdentifier)
		{
			// var navController = NavigationController as BtImageNavigationController;
			// if (navController != null) navController.SelectingSnapshotImagesForExport = false;

			selectingSnapshotImagesForExport = false;

			var annotateImageNavController = PresentingViewController?.ChildViewControllers?[0] as BtAnnotateImageNavigationController;

			var annotateImageController = annotateImageNavController?.TopViewController as BtAnnotateImageViewController ??
			                              PresentingViewController?.ChildViewControllers?[0] as BtAnnotateImageViewController;

			annotateImageController.SaveCurrentSnapshotAndResetState(indexForExtension, localIdentifier);

			DismissViewController(true, null);
		}



		partial void titleClicked (UIButton sender)
		{
			editIndexes = new List<NSIndexPath> ();

			Editing = false;

			updateViewConfiguration(false, selecting);

			TrapState.Shared.ResetSnapshotImages(false);

			selectingSnapshotImagesForExport = false;

			DismissViewController(true, null);
		}


		partial void cancelClicked (UIBarButtonItem sender)
		{
			// cancel should only appear if selecting screenshots for a new bug, or in edit state (delete)

			if (Editing) {

				Editing = false;

				updateViewConfiguration();

				CollectionView.ReloadItems(editIndexes.ToArray());

				editIndexes = new List<NSIndexPath> ();
			
			} else if (selecting) {

				TrapState.Shared.ResetSnapshotImages();

				selectingSnapshotImagesForExport = false;

				DismissViewController(true, null);
			}
		}


		async partial void trashClicked (UIBarButtonItem sender)
		{
			Editing = false;

			updateViewConfiguration(showActivity: true);

			var editAssets = editIndexes.Select(ip => assetsFetchResults[ip.Item] as PHAsset);

			await TrapState.Shared.DeleteAssets(editAssets.ToList());

			editIndexes = new List<NSIndexPath> ();

			BeginInvokeOnMainThread(() => updateViewConfiguration());
		}


		partial void editClicked (UIBarButtonItem sender)
		{
			Editing = true;

			updateViewConfiguration();
		}


		async partial void doneClicked (UIBarButtonItem sender)
		{
			if (selecting) {

				selectingSnapshotImagesForExport = false;

				var annotateImageNavController = PresentingViewController.ChildViewControllers?.FirstOrDefault() as BtAnnotateImageNavigationController ?? PresentingViewController as BtAnnotateImageNavigationController;

				await DismissViewControllerAsync(true);

				annotateImageNavController?.PresentNewBugDetailsNavController(true);
			
			} else {
				
				DismissViewController(true, null);
			}
		}


		partial void addClicked (UIBarButtonItem sender)
		{
			
		}


		void updateViewConfiguration (bool animate = true, bool reloadData = false, bool updateScreenName = true, bool showActivity = false)
		{
			if (GetItemsCount(CollectionView, 0) == 0 && !noImageView.IsDescendantOfView(View)) {
				View.AddSubview(noImageView);
			} else if (noImageView.IsDescendantOfView(View)) {
				noImageView.RemoveFromSuperview();
			}

			if (updateScreenName) UpdateScreenName(Editing ? GAIKeys.ScreenNames.EditSnapshots : GAIKeys.ScreenNames.SelectSnapshot);

			CollectionView.AllowsMultipleSelection = true;

			var leftItem = selecting || Editing ? cancelButton : editButton;
			var rightItem = showActivity ? activityButton : Editing ? trashButton : selecting ? doneButton : null;

			if (NavigationItem.LeftBarButtonItem != leftItem) NavigationItem.SetLeftBarButtonItem(leftItem, animate);
			if (NavigationItem.RightBarButtonItem != rightItem) NavigationItem.SetRightBarButtonItem(rightItem, animate);

			if (reloadData) {

				if (TrapState.Shared.InActionExtension) {

					CollectionView.ReloadData();

				} else {
					
					Task.Run(async () => {
						
						var oldCount = assetsFetchResults?.Count ?? 0;

						await TrapState.Shared.GetAlbumLocalIdentifier();

						PHPhotoLibrary.SharedPhotoLibrary.UnregisterChangeObserver(this);

						assetsFetchResults = PHAsset.FetchAssets(PHAssetMediaType.Image, fetchOptions);

						if ((assetsFetchResults?.Count ?? 0) > oldCount) InvokeOnMainThread(() => CollectionView.ReloadData());

						PHPhotoLibrary.SharedPhotoLibrary.RegisterChangeObserver(this);
					});
				}
			}
		}
		//		} else if let oldCount = assetsFetchResults?.count {
		//
		//			TrapState.Shared.getAlbumLocalIdentifier() { _ in
		//
		//				PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
		//
		//				self.assetsFetchResults = PHAsset.fetchAssetsWithMediaType(.Image, options: self.fetchOptions)
		//
		//				if self.assetsFetchResults?.count > oldCount {
		//
		//					dispatch_async(dispatch_get_main_queue()) {
		//
		//						self.collectionView!.reloadData()
		//					}
		//				}
		//
		//				PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
		//			}
		//		}
		// }



		public override bool PrefersStatusBarHidden () => true;

		public override UIStatusBarStyle PreferredStatusBarStyle () => UIStatusBarStyle.LightContent;
	}
}
