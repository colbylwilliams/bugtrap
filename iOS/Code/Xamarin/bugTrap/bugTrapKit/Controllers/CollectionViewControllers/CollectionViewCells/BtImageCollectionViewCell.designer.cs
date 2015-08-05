// WARNING
//
// This file has been generated automatically by Xamarin Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;
using UIKit;

namespace bugTrapKit
{
	[Register ("BtImageCollectionViewCell")]
	partial class BtImageCollectionViewCell
	{
		[Outlet]
		UIKit.UIImageView ImageView { get; set; }

		[Outlet]
		UIKit.UIButton SelectButton { get; set; }

		[Outlet]
		UIKit.UIView SelectedOverlay { get; set; }

		void ReleaseDesignerOutlets ()
		{
			if (ImageView != null) {
				ImageView.Dispose ();
				ImageView = null;
			}
			if (SelectButton != null) {
				SelectButton.Dispose ();
				SelectButton = null;
			}
			if (SelectedOverlay != null) {
				SelectedOverlay.Dispose ();
				SelectedOverlay = null;
			}
		}
	}
}
