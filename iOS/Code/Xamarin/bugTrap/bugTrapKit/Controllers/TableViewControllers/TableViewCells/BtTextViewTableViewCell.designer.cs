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
	[Register ("BtTextViewTableViewCell")]
	partial class BtTextViewTableViewCell
	{
		[Outlet]
		UIKit.UILabel PlaceholderLabel { get; set; }

		[Outlet]
		UIKit.UITextView TextView { get; set; }

		void ReleaseDesignerOutlets ()
		{
			if (PlaceholderLabel != null) {
				PlaceholderLabel.Dispose ();
				PlaceholderLabel = null;
			}
			if (TextView != null) {
				TextView.Dispose ();
				TextView = null;
			}
		}
	}
}
