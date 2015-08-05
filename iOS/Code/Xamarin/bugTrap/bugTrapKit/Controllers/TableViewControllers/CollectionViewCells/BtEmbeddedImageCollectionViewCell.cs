using System;

using UIKit;

namespace bugTrapKit
{
	public partial class BtEmbeddedImageCollectionViewCell : UICollectionViewCell
	{
		public BtEmbeddedImageCollectionViewCell (IntPtr handle) : base(handle)
		{
		}

		public void SetData (UIImage image)
		{
			ImageView.Image = image;
		}
	}
}
