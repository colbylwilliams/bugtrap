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
	[Register("BtAnnotateImageViewController")]
	partial class BtAnnotateImageViewController
	{
		[Outlet]
		UIKit.UIBarButtonItem actionButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem[] barColors { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem[] barTools { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem cancelButton { get; set; }

		[Outlet]
		UIKit.UILabel noImageDetail { get; set; }

		[Outlet]
		UIKit.UILabel noImageTitle { get; set; }

		[Outlet]
		UIKit.UIView noImageView { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem redoButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem saveButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem settingsButton { get; set; }

		[Outlet]
		UIKit.UIButton titleButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem undoButton { get; set; }

		[Action("actionClicked:")]
		partial void actionClicked (UIKit.UIBarButtonItem sender);

		[Action("barColorClicked:")]
		partial void barColorClicked (UIKit.UIBarButtonItem sender);

		[Action("barToolClicked:")]
		partial void barToolClicked (UIKit.UIBarButtonItem sender);

		[Action("cancelClicked:")]
		partial void cancelClicked (UIKit.UIBarButtonItem sender);

		[Action("redoClicked:")]
		partial void redoClicked (UIKit.UIBarButtonItem sender);

		[Action("saveClicked:")]
		partial void saveClicked (UIKit.UIBarButtonItem sender);

		[Action("settingsClicked:")]
		partial void settingsClicked (UIKit.UIBarButtonItem sender);

		[Action("test:")]
		partial void test (UIKit.UIBarButtonItem sender);

		[Action("titleClicked:")]
		partial void titleClicked (UIKit.UIButton sender);

		[Action("undoClicked:")]
		partial void undoClicked (UIKit.UIBarButtonItem sender);

		void ReleaseDesignerOutlets ()
		{
			if (actionButton != null) {
				actionButton.Dispose();
				actionButton = null;
			}

			if (cancelButton != null) {
				cancelButton.Dispose();
				cancelButton = null;
			}

			if (noImageDetail != null) {
				noImageDetail.Dispose();
				noImageDetail = null;
			}

			if (noImageTitle != null) {
				noImageTitle.Dispose();
				noImageTitle = null;
			}

			if (noImageView != null) {
				noImageView.Dispose();
				noImageView = null;
			}

			if (redoButton != null) {
				redoButton.Dispose();
				redoButton = null;
			}

			if (saveButton != null) {
				saveButton.Dispose();
				saveButton = null;
			}

			if (settingsButton != null) {
				settingsButton.Dispose();
				settingsButton = null;
			}

			if (titleButton != null) {
				titleButton.Dispose();
				titleButton = null;
			}

			if (undoButton != null) {
				undoButton.Dispose();
				undoButton = null;
			}
		}
	}
}
