using System;

using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class BtTextViewTableViewCell : BtNewBugDetailsTableViewCell, IUITextViewDelegate
	{

		public UITextView TxtView {
			get { return TextView; }
		}

		public BtTextViewTableViewCell (IntPtr handle) : base(handle)
		{
			
		}


		public override void AwakeFromNib ()
		{
			base.AwakeFromNib();

			PlaceholderLabel.Hidden = TextView.HasText;
		}


		public override void SetData (CellData cellData)
		{
			var detail = cellData.Get(DataKeys.Detail);
			var auxiliary = cellData.Get(DataKeys.Auxiliary);

			TextView.Text = detail;
			PlaceholderLabel.Hidden = TextView.HasText;
			PlaceholderLabel.Text = string.IsNullOrEmpty(detail) ? auxiliary : null;
		}


		[Export("textViewDidChange:")]
		public void Changed (UITextView textView)
		{
			PlaceholderLabel.Hidden = textView.HasText;
		}


		public void TextViewShouldBecomeFirstResponder ()
		{
			TextView.BecomeFirstResponder();
		}
	}
}
