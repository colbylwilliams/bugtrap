using System;
using UIKit;
using CoreGraphics;

namespace Insights.iOS
{
	public partial class AppsCollectionViewCell : UICollectionViewCell
	{
		public static readonly string ReuseId = "AppsCollectionViewCell";

		bool configuredShadow;

		public AppsCollectionViewCell (IntPtr handle) : base(handle)
		{
			
		}


		public void SetContent (CGSize cellSize, MobileApp app)
		{
			AppNameValueLabel.Text = app.Name;

			if (!configuredShadow) {
				configuredShadow = true;

				BackgroundStyleView.Layer.ShadowOffset = CGSize.Empty;
				BackgroundStyleView.Layer.ShadowColor = UIColor.Black.CGColor;
				BackgroundStyleView.Layer.CornerRadius = 3f;
				BackgroundStyleView.Layer.ShadowRadius = 4f;
				BackgroundStyleView.Layer.ShadowOpacity = 0.1f;
				BackgroundStyleView.Layer.ShadowPath = UIBezierPath.FromRect(new CGRect (0, 4, cellSize.Width - 12, cellSize.Height - 14)).CGPath;
			}
		}
	}
}