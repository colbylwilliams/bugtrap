using Foundation;
using UIKit;
using System;
using System.Threading.Tasks;

// using Xamarin.Inspector.iOS;
using ServiceStack;
using bugTrapKit;

namespace bugTrap
{
	[Register("AppDelegate")]
	public partial class AppDelegate : UIApplicationDelegate
	{
		UIWindow window;

		public override bool FinishedLaunching (UIApplication application, NSDictionary launchOptions)
		{
			#if DEBUG
			// TaskScheduler.UnobservedTaskException += HandleTaskSchedulerUnobservedTaskException;
			// Xamarin.InspectorSupport.Start();
			#endif

			#if UITEST
			Xamarin.Calabash.Start();
			#endif
			
			window = new UIWindow (UIScreen.MainScreen.Bounds);
			
			window.RootViewController = bugTrapKit.bugTrapKit.GetInitialController();
			window.MakeKeyAndVisible();

			UIApplication.SharedApplication.SetStatusBarStyle(UIStatusBarStyle.LightContent, false);
			UIApplication.SharedApplication.SetStatusBarHidden(true, UIStatusBarAnimation.None);

			return true;
		}

		static void HandleTaskSchedulerUnobservedTaskException (object sender, UnobservedTaskExceptionEventArgs e)
		{
			if (e.Exception != null && e.Exception.InnerExceptions != null && e.Exception.InnerExceptions.Count > 0) {
				foreach (var exception in e.Exception.InnerExceptions) {
					Console.WriteLine("TaskScheduler Unobserved Exception");
					Console.WriteLine(exception.Message);
					Console.WriteLine(exception.StackTrace);
					// Log.Error (exception, "TaskScheduler Unobserved Exception", true);
				}
			}
		}
	}
}