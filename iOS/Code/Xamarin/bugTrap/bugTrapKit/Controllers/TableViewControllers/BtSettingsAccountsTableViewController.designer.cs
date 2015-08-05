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
	[Register("BtSettingsAccountsTableViewController")]
	partial class BtSettingsAccountsTableViewController
	{
		[Outlet]
		UIKit.UILabel versionLabel { get; set; }

		[Action("DoneButtonClick:")]
		partial void DoneButtonClick (UIKit.UIBarButtonItem sender);

		[Action("letUsKnowClick:")]
		partial void letUsKnowClick (Foundation.NSObject sender);

		[Action("letUsKnowClicked:")]
		partial void letUsKnowClicked (UIKit.UIButton sender);

		void ReleaseDesignerOutlets ()
		{
			if (versionLabel != null) {
				versionLabel.Dispose();
				versionLabel = null;
			}
		}
	}
}
