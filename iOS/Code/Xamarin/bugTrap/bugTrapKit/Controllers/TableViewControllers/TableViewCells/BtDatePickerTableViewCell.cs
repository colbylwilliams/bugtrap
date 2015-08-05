using System;

using Foundation;


namespace bugTrapKit
{
	public partial class BtDatePickerTableViewCell : BtNewBugDetailsTableViewCell
	{
		public BtDatePickerTableViewCell (IntPtr handle) : base(handle)
		{
			
		}

		public override void AwakeFromNib ()
		{
			base.AwakeFromNib();

			DatePicker.MinimumDate = new NSDate ();

			DatePicker.SetDate(NSDate.FromTimeIntervalSinceNow(866400), false);
		}


		public void SetData (NSDate date, bool animate)
		{
			DatePicker.SetDate(date, animate);
		}
	}
}
