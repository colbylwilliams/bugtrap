using System;

namespace bugTrapKit
{
	public partial class BtEmbeddedImageCollectionViewTableViewCell : BtNewBugDetailsTableViewCell
	{
		public BtEmbeddedImageCollectionView CollectionView {
			get { return EmbeddedImageCollectionView; }
		}

		public BtEmbeddedImageCollectionViewTableViewCell (IntPtr handle) : base(handle)
		{

		}


		public void ReloadCollectionView ()
		{
			EmbeddedImageCollectionView.ReloadData();
		}
	}
}