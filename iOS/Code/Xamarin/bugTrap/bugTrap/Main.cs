using System;
using System.Collections.Generic;
using System.Linq;

using Foundation;
using UIKit;
using Xamarin;
using bugTrapKit;

namespace bugTrap
{
	public class Application
	{
		// This is the main entry point of the application.
		static void Main (string[] args)
		{
			#if DEBUG
			Insights.Initialize(InsightsKeys.ApiKeyDebug);
			#else
			Insights.Initialize(InsightsKeys.ApiKey);
			#endif

			UIApplication.Main(args, null, "AppDelegate");
		}
	}
}