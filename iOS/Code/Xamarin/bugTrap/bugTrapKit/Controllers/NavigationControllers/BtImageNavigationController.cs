

using System;

using Foundation;
using UIKit;

namespace bugTrapKit
{
	public partial class BtImageNavigationController : BtNavigationController
	{
		public bool SelectingSnapshotImagesForExport { get; set; }

		public BtImageNavigationController (IntPtr handle) : base(handle)
		{
		}
	}
}
