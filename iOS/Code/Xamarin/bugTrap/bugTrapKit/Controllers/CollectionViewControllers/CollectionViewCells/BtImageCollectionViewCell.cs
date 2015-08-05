

using System;

using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class BtImageCollectionViewCell : UICollectionViewCell
	{
		public BtImageCollectionViewCell (IntPtr handle) : base(handle)
		{
		}

		public bool IsSelected { get; set; }

		public void SetData (UIImage image)
		{
			ImageView.Image = image;
		}

		public void SetSelected (bool isSelected)
		{
			IsSelected = isSelected;
			SelectedOverlay.Hidden = !isSelected;
		}
	}
}
