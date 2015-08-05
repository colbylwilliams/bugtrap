using System;

using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class BtTextFieldTableViewCell : BtNewBugDetailsTableViewCell, IUITextFieldDelegate
	{

		public UITextField TxtField {
			get { return TextField; }
		}

		public BtTextFieldTableViewCell (IntPtr handle) : base(handle)
		{
			
		}


		public override void AwakeFromNib ()
		{
			base.AwakeFromNib();

			PlaceholderLabel.Hidden = TextField.HasText;
		}


		public override void SetData (CellData cellData)
		{
			var detail = cellData.Get(DataKeys.Detail);
			var auxiliary = cellData.Get(DataKeys.Auxiliary);

			TextField.Text = detail;
			PlaceholderLabel.Hidden = TextField.HasText;
			PlaceholderLabel.Text = string.IsNullOrEmpty(detail) ? auxiliary : null;
		}


		public bool TextFieldShouldBecomeFirstResponder ()
		{
			var respond = !TextField.HasText;

			if (respond) TextField.BecomeFirstResponder();

			return respond;
		}


		[Export("textField:shouldChangeCharactersInRange:replacementString:")]
		public bool ShouldChangeCharacters (UITextField textField, NSRange range, string replacementString)
		{
			PlaceholderLabel.Hidden = !string.IsNullOrEmpty(replacementString) || range.Location > 0;
			return true;
		}


		[Export("textFieldShouldReturn:")]
		public bool ShouldReturn (UITextField textField)
		{
			textField.ResignFirstResponder();
			return false;
		}
	}
}