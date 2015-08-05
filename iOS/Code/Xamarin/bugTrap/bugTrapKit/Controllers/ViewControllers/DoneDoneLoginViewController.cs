using System;
using System.Collections.Generic;
using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class DoneDoneLoginViewController : BtTrackerLoginViewController, IUITextFieldDelegate
	{

		public override TrackerType TrackerType {
			get { return TrackerType.DoneDone; }
		}

		public DoneDoneLoginViewController (IntPtr handle) : base(handle)
		{
		}


		public override void ViewDidAppear (bool animated)
		{
			base.ViewDidAppear(animated);

			SubdomainField.BecomeFirstResponder();
		}


		public override void PopulatePlaceholderLabels (bool showPlaceholders)
		{
			SubdomainField.Placeholder = showPlaceholders ? DataKeys.Subdomain.ToString() : string.Empty;
			UsernameField.Placeholder = showPlaceholders ? DataKeys.UserName.ToString() : string.Empty;
			PasswordField.Placeholder = showPlaceholders ? DataKeys.Password.ToString() : string.Empty;
		}


		public override void KeychainDataLoaded (Dictionary<DataKeys, string> storedData)
		{
			string subdomain = string.Empty, username = string.Empty, password = string.Empty;

			if (storedData.TryGetValue(DataKeys.Subdomain, out subdomain)) SubdomainField.Text = subdomain;
			if (storedData.TryGetValue(DataKeys.UserName, out username)) UsernameField.Text = username;
			if (storedData.TryGetValue(DataKeys.Password, out password)) PasswordField.Text = password;
		}


		[Export("textFieldShouldReturn:")]
		public bool ShouldReturn (UITextField textField)
		{
			if (textField == SubdomainField) UsernameField.BecomeFirstResponder();
			if (textField == UsernameField) PasswordField.BecomeFirstResponder();
			if (textField == PasswordField) {
				PasswordField.ResignFirstResponder();
				validateValuesAndLoginAsync();
			}
			return false;
		}


		async void validateValuesAndLoginAsync ()
		{
			if (!SubdomainField.HasText) {
				SubdomainField.BecomeFirstResponder();
				return;
			}

			if (!UsernameField.HasText) {
				UsernameField.BecomeFirstResponder();
				return;
			}

			if (!PasswordField.HasText) {
				PasswordField.BecomeFirstResponder();
				return;
			}

			ActivityIndicator.StartAnimating();
			ActivityIndicator.Hidden = false;

			var trackerData = new Dictionary<DataKeys, string> {
				{ DataKeys.Subdomain, SubdomainField.Text },
				{ DataKeys.UserName, UsernameField.Text },
				{ DataKeys.Password, PasswordField.Text }
			};

			// store the data in the keychain
			Keychain.StoreKeyValues(trackerData);

			var dataValid = TrackerService.Shared.SetCurrentTrackerType(TrackerType.DoneDone);

			if (!dataValid) {
				// Log.Error("Invalid Data", trackerData);
				Console.WriteLine("Invalid Data!");
				return;
			}

			var authenticated = await TrackerService.Shared.CurrentTracker.Authenticate(trackerData);

			if (authenticated) {
			
				await PresentingViewController.DismissViewControllerAsync(true);
			
			} else {

				var messageTop = "Unable to login to DoneDone with the information provided\n{0}";

				var message = string.Format(messageTop, "\nReview Username & Password\nthen try again");

				var errorDialog = UIAlertController.Create("Error", message, UIAlertControllerStyle.Alert);
				errorDialog.AddAction(UIAlertAction.Create("OK", UIAlertActionStyle.Cancel, null));

				await PresentViewControllerAsync(errorDialog, true);

				trackerData[DataKeys.Subdomain] = string.Empty;
				trackerData[DataKeys.UserName] = string.Empty;
				trackerData[DataKeys.Password] = string.Empty;

				// clear the data in the keychain
				Keychain.StoreKeyValues(trackerData);
			}

			ActivityIndicator.StopAnimating();
		}
	}
}