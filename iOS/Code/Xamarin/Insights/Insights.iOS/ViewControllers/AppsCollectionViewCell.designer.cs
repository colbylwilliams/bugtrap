// WARNING
//
// This file has been generated automatically by Xamarin Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using Foundation;
using System.CodeDom.Compiler;

namespace Insights.iOS
{
	[Register ("AppsCollectionViewCell")]
	partial class AppsCollectionViewCell
	{
		[Outlet]
		UIKit.UIImageView AppIconImageView { get; set; }

		[Outlet]
		UIKit.UILabel AppNameValueLabel { get; set; }

		[Outlet]
		UIKit.UIView BackgroundStyleView { get; set; }

		[Outlet]
		UIKit.UILabel OpenIssuesLabel { get; set; }

		[Outlet]
		UIKit.UILabel OpenIssuesValueLabel { get; set; }

		[Outlet]
		UIKit.UILabel SessionsInLastLabel { get; set; }

		[Outlet]
		UIKit.UILabel SessionsInLastValueLabel { get; set; }

		[Outlet]
		UIKit.UILabel UsersExperiencingIssuesLabel { get; set; }

		[Outlet]
		UIKit.UILabel UsersExperiencingIssuesValueLabel { get; set; }

		[Outlet]
		UIKit.UILabel UsersInLastLabel { get; set; }

		[Outlet]
		UIKit.UILabel UsersInLastValueLabel { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (AppIconImageView != null) {
				AppIconImageView.Dispose ();
				AppIconImageView = null;
			}

			if (AppNameValueLabel != null) {
				AppNameValueLabel.Dispose ();
				AppNameValueLabel = null;
			}

			if (BackgroundStyleView != null) {
				BackgroundStyleView.Dispose ();
				BackgroundStyleView = null;
			}

			if (SessionsInLastValueLabel != null) {
				SessionsInLastValueLabel.Dispose ();
				SessionsInLastValueLabel = null;
			}

			if (SessionsInLastLabel != null) {
				SessionsInLastLabel.Dispose ();
				SessionsInLastLabel = null;
			}

			if (OpenIssuesValueLabel != null) {
				OpenIssuesValueLabel.Dispose ();
				OpenIssuesValueLabel = null;
			}

			if (OpenIssuesLabel != null) {
				OpenIssuesLabel.Dispose ();
				OpenIssuesLabel = null;
			}

			if (UsersInLastValueLabel != null) {
				UsersInLastValueLabel.Dispose ();
				UsersInLastValueLabel = null;
			}

			if (UsersInLastLabel != null) {
				UsersInLastLabel.Dispose ();
				UsersInLastLabel = null;
			}

			if (UsersExperiencingIssuesValueLabel != null) {
				UsersExperiencingIssuesValueLabel.Dispose ();
				UsersExperiencingIssuesValueLabel = null;
			}

			if (UsersExperiencingIssuesLabel != null) {
				UsersExperiencingIssuesLabel.Dispose ();
				UsersExperiencingIssuesLabel = null;
			}
		}
	}
}
