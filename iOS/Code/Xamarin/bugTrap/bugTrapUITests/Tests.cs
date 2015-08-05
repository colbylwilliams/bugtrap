using System;
using System.IO;
using System.Linq;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.iOS;
using Xamarin.UITest.Queries;
using System.Threading.Tasks;
using System.Threading;

namespace bugTrapUITests
{
	[TestFixture]
	public class Tests
	{
		iOSApp app;

		[SetUp]
		public void BeforeEachTest ()
		{
			app = ConfigureApp.iOS
				#if SIMULATOR
				.AppBundle("../../../../bugTrap/bin/iPhoneSimulator/Debug/bugTrap.app")
				.Debug()
				#else
				.InstalledApp("io.bugtrap.bugTrap")
				.ApiKey("9143d067ec53bfb406aff56327f5e53b")
				#endif
				.EnableLocalScreenshots()
				.StartApp();
		}


		[Test]
		public void AppLaunches ()
		{


			app.Screenshot("Annotate View - App Launches");
		
			app.WaitThenTapIfExists(x => x.Marked("OK"), 10);

			app.Repl();

			return;

			app.WaitThenTap(x => x.Marked("BtnBarSettings"), "Settings View - Portrait");
			
			app.SetOrientationLandscape();
			
			app.Screenshot("Settings View - Landscape");
			
			app.SetOrientationPortrait();
			
			app.Screenshot("Settings View - Portrait retrun");

			
			app.WaitThenTap(x => x.Marked("BtnBarDone"), "Annotate View - Portrait");
			

			app.SetOrientationLandscape();
			
			app.Screenshot("Annotate View - Landscape");

			
			app.SetOrientationPortrait();
			
			app.Screenshot("Annotate View - Portrait return");


			app.WaitThenTap(x => x.Marked("BtnBarLogo"), "Photos Collection View - Portrait");
		
		
			app.SetOrientationLandscape();
		
			app.Screenshot("Photos Collection View - Landscape");

		
			app.SetOrientationPortrait();
		
			app.TapCoordinates(100, 100);
		
			app.Screenshot("Annotate View - Photo Selected");
		
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorRed"), "Selected Color - Red");
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolArrow"));
		
			app.Screenshot("Annotate View - Red Arrow Selected");
		
			app.DragCoordinates(300, 300, 20, 70);
			app.DragCoordinates(20, 300, 300, 70);
		
			app.Screenshot("Annotate View - Red Arrow Drawn");
		
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorGreen"));
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCircle"));
		
			app.Screenshot("Annotate View - Green Circle Selected");
		
			app.DragCoordinates(20, 240, 300, 460);
		
			app.Screenshot("Annotate View - Green Circle Drawn");
		
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlue"));
			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolSquare"));
		
			app.Screenshot("Annotate View - Blue Square Selected");
		
			app.DragCoordinates(100, 300, 220, 400);
		
			app.Screenshot("Annotate View - Blue Square Drawn");
		
			app.WaitThenTap(x => x.Marked("BtnBarUndo"));
			app.WaitThenTap(x => x.Marked("BtnBarUndo"));
		
			app.Screenshot("Annotate View - Undo Green Circle and Blue Square");
		
			app.WaitThenTap(x => x.Marked("BtnBarRedo"));
			app.WaitThenTap(x => x.Marked("BtnBarRedo"));
		
			app.Screenshot("Annotate View - Redo Green Circle and Blue Square");
		
			app.WaitThenTap(x => x.Marked("BtnBarAction"));
		
			app.Screenshot("Annotate View - Action Sheet Open");
		}

		//		[Test]
		//		public void AppLaunches ()
		//		{
		//			app.Screenshot("Annotate View - App Launches");
		//
		//			app.WaitThenTapIfExists(x => x.Marked("OK"), 10);
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarSettings"), "Settings View - Portrait");
		//
		//			app.SetOrientationLandscape();
		//
		//			app.Screenshot("Settings View - Landscape");
		//
		//			app.SetOrientationPortrait();
		//
		//			app.Screenshot("Settings View - Portrait retrun");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarDone"), "Annotate View - Portrait");
		//
		//			app.SetOrientationLandscape();
		//
		//			app.Screenshot("Annotate View - Landscape");
		//
		//			app.SetOrientationPortrait();
		//
		//			app.Screenshot("Annotate View - Portrait return");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlue"), "Selected Color - Blue");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorRed"), "Selected Color - Red");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorGreen"), "Selected Color - Green");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorOrange"), "Selected Color - Orange");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorWhite"), "Selected Color - White");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlack"), "Selected Color - Black");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCallout"), "Selected Tool - Callout");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolMarker"), "Selected Tool - Marker");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolArrow"), "Selected Tool - Arrow");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCircle"), "Selected Tool - Circle");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolSquare"), "Selected Tool - Square");
		//		}


		//		[Test]
		//		public void AppLaunches ()
		//		{
		//			app.Screenshot("Annotate View - App Launches");
		//
		//			app.WaitThenTapIfExists(x => x.Marked("OK"), 10);
		//
		//			app.Tap(x => x.Marked("BtnBarLogo"));
		//
		//			app.Screenshot("Photos Collection View");
		//
		//			app.ScrollDown();
		//			app.ScrollDown();
		//			app.ScrollDown();
		//
		//			app.Screenshot("Photos Collection View - scrolled down");
		//
		//			app.ScrollUp();
		//			app.ScrollUp();
		//			app.ScrollUp();
		//
		//			app.Screenshot("Photos Collection View - scrolled up");
		//
		//			app.SetOrientationLandscape();
		//
		//			app.Screenshot("Photos Collection View - Landscape");
		//
		//			app.SetOrientationPortrait();
		//
		//			app.TapCoordinates(400, 400);
		//
		//			app.Screenshot("Annotate View - Photo Selected");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorRed"), "Selected Color - Red");
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolArrow"));
		//
		//			app.Screenshot("Annotate View - Red Arrow Selected");
		//
		//			app.DragCoordinates(400, 400, 200, 200);
		//			app.DragCoordinates(400, 200, 200, 400);
		//
		//			app.Screenshot("Annotate View - Red Arrow Drawn");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorGreen"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCircle"));
		//
		//			app.Screenshot("Annotate View - Green Circle Selected");
		//
		//			app.DragCoordinates(50, 300, 350, 600);
		//
		//			app.Screenshot("Annotate View - Green Circle Drawn");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlue"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolSquare"));
		//
		//			app.Screenshot("Annotate View - Blue Square Selected");
		//
		//			app.DragCoordinates(100, 300, 400, 550);
		//
		//			app.Screenshot("Annotate View - Blue Square Drawn");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarUndo"));
		//			app.WaitThenTap(x => x.Marked("BtnBarUndo"));
		//
		//			app.Screenshot("Annotate View - Undo Green Circle and Blue Square");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarRedo"));
		//			app.WaitThenTap(x => x.Marked("BtnBarRedo"));
		//
		//			app.Screenshot("Annotate View - Redo Green Circle and Blue Square");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAction"));
		//
		//			app.Screenshot("Annotate View - Action Sheet Open");
		//
		//			app.TapCoordinates(350, 700);
		//		}

		//		[Test]
		//		public void CheckButtons ()
		//		{
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlue"), "Selected Color - Blue");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorRed"), "Selected Color - Red");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorGreen"), "Selected Color - Green");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorOrange"), "Selected Color - Orange");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorWhite"), "Selected Color - White");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolColor"));
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateColorBlack"), "Selected Color - Black");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCallout"), "Selected Tool - Callout");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolMarker"), "Selected Tool - Marker");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolArrow"), "Selected Tool - Arrow");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolCircle"), "Selected Tool - Circle");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarAnnotateToolSquare"), "Selected Tool - Square");
		//
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarSettings"), "Settings Screen");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarDone"), "Annotate Screen");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarLogo"), "Photos Screen");
		//
		//			app.WaitThenTap(x => x.Marked("BtnBarLogo"), "Annotate Screen");
		//		}
	}
}