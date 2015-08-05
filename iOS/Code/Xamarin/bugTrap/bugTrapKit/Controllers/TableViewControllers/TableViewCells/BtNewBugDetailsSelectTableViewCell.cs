using System;

using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class BtNewBugDetailsSelectTableViewCell : BtNewBugDetailsTableViewCell
	{
		NSIndexPath loadingKey;

		UILabel initialsLabel;

		public BtNewBugDetailsSelectTableViewCell (IntPtr handle) : base(handle)
		{
			
		}

		public override void AwakeFromNib ()
		{
			base.AwakeFromNib();

			ImageView.Layer.CornerRadius = 22;
			ImageView.Layer.MasksToBounds = true;

			initialsLabel = new UILabel ();

			initialsLabel.TextColor = Colors.Theme;
			initialsLabel.TextAlignment = UITextAlignment.Center;
			initialsLabel.Font = Fonts.HelveticaNeue_Medium_22;
			initialsLabel.BackgroundColor = Colors.Clear;

			AddSubview(initialsLabel);

			ImageView.ContentMode = UIViewContentMode.ScaleAspectFit;
		}


		public override void LayoutSubviews ()
		{
			base.LayoutSubviews();

			initialsLabel.Frame = ImageView.Frame;
		}


		public override void SetData (CellData cellData)
		{
			var title = cellData.Get(DataKeys.Title);
			var detail = cellData.Get(DataKeys.Detail);
			var auxiliary = cellData.Get(DataKeys.Auxiliary);

			if (TextLabel != null) TextLabel.Text = title;
			if (DetailTextLabel != null) DetailTextLabel.Text = detail;
			if (initialsLabel != null) initialsLabel.Text = auxiliary;
		}


		public void SetData (NSIndexPath indexPath, CellData cellData, UIImage image = null)
		{
			loadingKey = indexPath;

			ImageView.Image = image;

			SetData(cellData);
		}


		public bool SetImage (UIImage image, NSIndexPath key)
		{
			var setImage = key == loadingKey;

			initialsLabel.Hidden = setImage;

			if (setImage) ImageView.Image = image;

			return setImage;
		}
	}
}