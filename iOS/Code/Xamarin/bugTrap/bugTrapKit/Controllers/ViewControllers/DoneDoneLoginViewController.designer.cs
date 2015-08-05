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
	[Register ("DoneDoneLoginViewController")]
	partial class DoneDoneLoginViewController
	{
		[Outlet]
		UIKit.UIActivityIndicatorView ActivityIndicator { get; set; }

		[Outlet]
		UIKit.UITextField PasswordField { get; set; }

		[Outlet]
		UIKit.UITextField SubdomainField { get; set; }

		[Outlet]
		UIKit.UITextField UsernameField { get; set; }

		void ReleaseDesignerOutlets ()
		{
			if (ActivityIndicator != null) {
				ActivityIndicator.Dispose ();
				ActivityIndicator = null;
			}
			if (PasswordField != null) {
				PasswordField.Dispose ();
				PasswordField = null;
			}
			if (SubdomainField != null) {
				SubdomainField.Dispose ();
				SubdomainField = null;
			}
			if (UsernameField != null) {
				UsernameField.Dispose ();
				UsernameField = null;
			}
		}
	}
}
