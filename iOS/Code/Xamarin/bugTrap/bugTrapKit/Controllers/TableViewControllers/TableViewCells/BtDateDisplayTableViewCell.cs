using System;

namespace bugTrapKit
{
	public partial class BtDateDisplayTableViewCell : BtNewBugDetailsTableViewCell
	{
		public BtDateDisplayTableViewCell (IntPtr handle) : base(handle)
		{
		}

		public override void SetData (CellData cellData)
		{
			var title = cellData.Get(DataKeys.Title);
			var detail = cellData.Get(DataKeys.Detail);
			var auxiliary = cellData.Get(DataKeys.Auxiliary);

			TitleLabel.Text = string.IsNullOrEmpty(detail) ? detail : title;
			DetailTextLabel.Text = detail;
			PlaceholderLabel.Text = string.IsNullOrEmpty(detail) ? auxiliary : null;
		}
	}
}