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
	[Register ("BtImageCollectionViewController")]
	partial class BtImageCollectionViewController
	{
		[Outlet]
		UIKit.UIBarButtonItem activityButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem addButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem cancelButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem doneButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem editButton { get; set; }

		[Outlet]
		UIKit.UILabel noImageDetail { get; set; }

		[Outlet]
		UIKit.UILabel noImageTitle { get; set; }

		[Outlet]
		UIKit.UIView noImageView { get; set; }

		[Outlet]
		UIKit.UIButton titleButton { get; set; }

		[Outlet]
		UIKit.UIBarButtonItem trashButton { get; set; }

		[Action ("addClicked:")]
		partial void addClicked (UIKit.UIBarButtonItem sender);

		[Action ("cancelClicked:")]
		partial void cancelClicked (UIKit.UIBarButtonItem sender);

		[Action ("doneClicked:")]
		partial void doneClicked (UIKit.UIBarButtonItem sender);

		[Action ("editClicked:")]
		partial void editClicked (UIKit.UIBarButtonItem sender);

		[Action ("titleClicked:")]
		partial void titleClicked (UIKit.UIButton sender);

		[Action ("trashClicked:")]
		partial void trashClicked (UIKit.UIBarButtonItem sender);
		
		void ReleaseDesignerOutlets ()
		{
			if (activityButton != null) {
				activityButton.Dispose ();
				activityButton = null;
			}

			if (addButton != null) {
				addButton.Dispose ();
				addButton = null;
			}

			if (cancelButton != null) {
				cancelButton.Dispose ();
				cancelButton = null;
			}

			if (doneButton != null) {
				doneButton.Dispose ();
				doneButton = null;
			}

			if (editButton != null) {
				editButton.Dispose ();
				editButton = null;
			}

			if (noImageDetail != null) {
				noImageDetail.Dispose ();
				noImageDetail = null;
			}

			if (noImageTitle != null) {
				noImageTitle.Dispose ();
				noImageTitle = null;
			}

			if (noImageView != null) {
				noImageView.Dispose ();
				noImageView = null;
			}

			if (titleButton != null) {
				titleButton.Dispose ();
				titleButton = null;
			}

			if (trashButton != null) {
				trashButton.Dispose ();
				trashButton = null;
			}
		}
	}
}
