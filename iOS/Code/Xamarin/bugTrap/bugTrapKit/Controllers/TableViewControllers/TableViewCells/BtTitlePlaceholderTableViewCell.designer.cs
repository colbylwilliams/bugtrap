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
	[Register ("BtTitlePlaceholderTableViewCell")]
	partial class BtTitlePlaceholderTableViewCell
	{
		[Outlet]
		UIKit.UILabel DetailLabel { get; set; }

		[Outlet]
		UIKit.UILabel PlaceholderLabel { get; set; }

		[Outlet]
		UIKit.UILabel TitleLabel { get; set; }

		void ReleaseDesignerOutlets ()
		{
			if (DetailLabel != null) {
				DetailLabel.Dispose ();
				DetailLabel = null;
			}
			if (PlaceholderLabel != null) {
				PlaceholderLabel.Dispose ();
				PlaceholderLabel = null;
			}
			if (TitleLabel != null) {
				TitleLabel.Dispose ();
				TitleLabel = null;
			}
		}
	}
}
