using System;
using Foundation;
using UIKit;
using System.Collections.Generic;
using CoreGraphics;

namespace Insights.iOS
{
	public partial class AppsCollectionViewController : UICollectionViewController, IUICollectionViewDelegateFlowLayout
	{
		public List<MobileApp> Apps { get; set; }

		CGSize cellSize = new CGSize ((UIScreen.MainScreen.Bounds.Height > UIScreen.MainScreen.Bounds.Width) ? (UIScreen.MainScreen.Bounds.Width - 8) : (UIScreen.MainScreen.Bounds.Width - 12) / 2, 280);


		public AppsCollectionViewController (IntPtr handle) : base(handle)
		{
			Apps = InsightsService.GetApps;
		}


		public override nint NumberOfSections (UICollectionView collectionView)
		{
			return 1;
		}


		public override nint GetItemsCount (UICollectionView collectionView, nint section)
		{
			return Apps.Count;
		}


		public override UICollectionViewCell GetCell (UICollectionView collectionView, NSIndexPath indexPath)
		{
			var cell = collectionView.DequeueReusableCell(AppsCollectionViewCell.ReuseId, indexPath) as AppsCollectionViewCell;

			var app = Apps[Convert.ToInt32(indexPath.Item)];

			cell.SetContent(cellSize, app);

			return cell;
		}


		public override void ItemSelected (UICollectionView collectionView, NSIndexPath indexPath)
		{
			var tabController = Storyboard.Instantiate<AppTabBarController>();
			ShowViewController(tabController, this);
		}


		[Export("collectionView:layout:sizeForItemAtIndexPath:")]
		public CGSize GetSizeForItem (UICollectionView collectionView, UICollectionViewLayout layout, NSIndexPath indexPath)
		{
			return cellSize;
		}


		public override UIStatusBarStyle PreferredStatusBarStyle ()
		{
			return UIStatusBarStyle.LightContent;
		}
	}
}
