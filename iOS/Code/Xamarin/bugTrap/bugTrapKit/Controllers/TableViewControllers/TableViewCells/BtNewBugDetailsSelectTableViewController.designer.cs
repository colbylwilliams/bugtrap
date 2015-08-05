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
	[Register ("BtNewBugDetailsSelectTableViewController")]
	partial class BtNewBugDetailsSelectTableViewController
	{
		[Outlet]
		UIKit.UILabel noDataDetail { get; set; }

		[Outlet]
		UIKit.UILabel noDataTitle { get; set; }

		[Outlet]
		UIKit.UIView tableBackgroundView { get; set; }

		[Action ("refreshControlValueChanged:")]
		partial void refreshControlValueChanged (UIKit.UIRefreshControl sender);

		void ReleaseDesignerOutlets ()
		{
			if (noDataDetail != null) {
				noDataDetail.Dispose ();
				noDataDetail = null;
			}
			if (noDataTitle != null) {
				noDataTitle.Dispose ();
				noDataTitle = null;
			}
			if (tableBackgroundView != null) {
				tableBackgroundView.Dispose ();
				tableBackgroundView = null;
			}
		}
	}
}
