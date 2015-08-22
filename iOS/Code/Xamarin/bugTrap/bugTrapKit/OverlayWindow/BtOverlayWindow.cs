using UIKit;
using CoreGraphics;

namespace bugTrapKit
{
	public sealed class BtOverlayWindow : UIWindow
	{
		public BtOverlayWindow () : base(UIScreen.MainScreen.Bounds)
		{
			RootViewController = new BtOverlayViewController ();
			this.AddSubview(RootViewController.View);
		}

		public void BuildUp ()
		{
			var root = RootViewController as BtOverlayViewController;
			if (root != null) {
				// root.EnsureBuildUp();
			}
		}

		public override UIView HitTest (CGPoint point, UIEvent uievent)
		{
			UIView result = base.HitTest(point, uievent);

			return (result is BtOverlayView) ? null : result;
		}
	}
}