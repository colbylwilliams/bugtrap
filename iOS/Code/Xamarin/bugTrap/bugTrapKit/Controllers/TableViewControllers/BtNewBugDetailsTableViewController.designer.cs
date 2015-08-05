// WARNING
//
// This file has been generated automatically by Xamarin Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using Foundation;
using System.CodeDom.Compiler;

namespace bugTrapKit
{
	[Register("BtNewBugDetailsTableViewController")]
	partial class BtNewBugDetailsTableViewController
	{
		[Outlet]
		UIKit.UIBarButtonItem activityButton { get; set; }

		[Outlet]
		UIKit.UIActivityIndicatorView activityIndicator { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem cancelButton { get; set; }

		[Outlet]
		UIKit.UIDatePicker DatePicker { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem saveButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem submitButton { get; set; }

		[Action("cancelClicked:")]
		partial void cancelClicked (UIKit.UIBarButtonItem sender);

		[Action("datePickerValueChanged:")]
		partial void datePickerValueChanged (UIKit.UIDatePicker sender);

		[Action("saveClicked:")]
		partial void saveClicked (UIKit.UIBarButtonItem sender);

		[Action("submitClicked:")]
		partial void submitClicked (UIKit.UIBarButtonItem sender);

		[Action("tapRecognized:")]
		partial void tapRecognized (UIKit.UITapGestureRecognizer sender);

		void ReleaseDesignerOutlets ()
		{
			if (activityButton != null) {
				activityButton.Dispose();
				activityButton = null;
			}

			if (activityIndicator != null) {
				activityIndicator.Dispose();
				activityIndicator = null;
			}

			if (cancelButton != null) {
				cancelButton.Dispose();
				cancelButton = null;
			}

			if (DatePicker != null) {
				DatePicker.Dispose();
				DatePicker = null;
			}

			if (saveButton != null) {
				saveButton.Dispose();
				saveButton = null;
			}

			if (submitButton != null) {
				submitButton.Dispose();
				submitButton = null;
			}
		}
	}
}
