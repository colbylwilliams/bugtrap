

using System;

using Foundation;
using UIKit;
using MessageUI;
using System.Collections.Generic;

namespace bugTrapKit
{
	public partial class BtSettingsAccountsTableViewController : BtTableViewController, IMFMailComposeViewControllerDelegate
	{

		Dictionary<TrackerStatus, List<TrackerType>> trackerTypes;
		Dictionary<TrackerType, string> trackerUsers;


		public BtSettingsAccountsTableViewController (IntPtr handle) : base(handle)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad();

			ScreenName = GAIKeys.ScreenNames.TrackerAccounts;

			versionLabel.Text = Settings.VersionBuildString;

			trackerTypes = TrackerService.Shared.GetTrackerTypesByStatus();

			trackerUsers = TrackerService.Shared.GetUsernamesForEnabledTrackerTypes(trackerTypes?[TrackerStatus.Enabled]);
		}


		partial void DoneButtonClick (UIBarButtonItem sender)
		{
			DismissViewController(true, null);

		}

		partial void letUsKnowClicked (UIButton sender)
		{
			if (MFMailComposeViewController.CanSendMail) {
				var mailComposeViewController = configuredMailComposeViewController();
				PresentViewController(mailComposeViewController, true, null);
			} else {
				var sendMailErrorController = new UIAlertController { 
					Title = "Could Not Send Email", 
					Message = "Your device could not send e-mail.  Please check e-mail configuration and try again."
				};

				PresentViewController(sendMailErrorController, true, null);
			}
		}


		#region MFMailComposeViewController

		MFMailComposeViewController configuredMailComposeViewController ()
		{
			var mailComposerVC = new MFMailComposeViewController ();
			mailComposerVC.MailComposeDelegate = this;

			mailComposerVC.SetToRecipients(new [] { AppKeys.ContactEmail });
			mailComposerVC.SetSubject(AppKeys.Contact.IntegrationSubject);
			mailComposerVC.SetMessageBody(AppKeys.Contact.IntegrationBody, false);

			return mailComposerVC;
		}

		[Export("mailComposeController:didFinishWithResult:error:")]
		public void Finished (MFMailComposeViewController controller, MFMailComposeResult result, NSError error)
		{
			controller.DismissViewController(true, null);
		}

		#endregion


		#region TableViewSource

		public override nint NumberOfSections (UITableView tableView) => 2;

		public override nint RowsInSection (UITableView tableview, nint section)
		{
			return section == 0 ? trackerTypes?[TrackerStatus.Enabled]?.Count ?? 0 : trackerTypes?[TrackerStatus.ComingSoon]?.Count ?? 0;
		}


		public override UITableViewCell GetCell (UITableView tableView, NSIndexPath indexPath)
		{
			var cell = tableView.DequeueReusableCell(BtSettingsAccountTableViewCell.CellReuseId) as BtSettingsAccountTableViewCell;

			var status = (TrackerStatus)(indexPath.Section + 2);

			var tracker = trackerTypes[status][indexPath.Row];

			var enabled = indexPath.Section == 0;

			cell.TextLabel.Text = tracker.ToString();
			cell.TextLabel.TextColor = enabled ? Colors.Black : Colors.Gray;

			cell.DetailTextLabel.Text = enabled && tracker.Enabled() ? trackerUsers[tracker] ?? string.Empty : "coming soon";
			cell.DetailTextLabel.TextColor = enabled ? Colors.Theme : Colors.LightGray;

			cell.Accessory = enabled ? UITableViewCellAccessory.DisclosureIndicator : UITableViewCellAccessory.None;

			cell.ImageView.Image = string.IsNullOrEmpty(tracker.SmallImageName()) ? null : UIImage.FromBundle(tracker.SmallImageName());

			return cell;
		}


		public override bool ShouldHighlightRow (UITableView tableView, NSIndexPath rowIndexPath) => rowIndexPath.Section == 0;


		public override void RowSelected (UITableView tableView, NSIndexPath indexPath)
		{
			tableView.CellAt(indexPath).Selected = false;

			if (indexPath.Section == 0) {

				var status = (TrackerStatus)(indexPath.Section + 2);

				var tracker = trackerTypes[status][indexPath.Row];

				if (!string.IsNullOrEmpty(tracker.LoginControllerName())) {
				
					var loginController = Storyboard.Instantiate(tracker.LoginControllerName());

					ShowViewController(loginController, this);
				}
			}
		}


		public override nfloat GetHeightForRow (UITableView tableView, NSIndexPath indexPath)
		{
			return indexPath.Section == 0 ? 44 : 40;
		}


		public override string TitleForHeader (UITableView tableView, nint section)
		{
			return section == 0 ? "Issue Trackers" : string.Empty;
		}

		#endregion


		public override bool PrefersStatusBarHidden () => true;

		public override UIStatusBarStyle PreferredStatusBarStyle () => UIStatusBarStyle.LightContent;
	}
}