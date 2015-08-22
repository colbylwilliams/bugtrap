using System.Collections.Generic;

namespace Insights
{
	public static class InsightsService
	{
		public static List<MobileApp> GetApps = new List<MobileApp> {
			new MobileApp { Name = "BloodPressureX" },
			new MobileApp { Name = "bugTrap" },
			new MobileApp { Name = "bugTrap Debug" },
			new MobileApp { Name = "VervetaCRM.Android" },
			new MobileApp { Name = "VervetaCRM.iOS" },
			new MobileApp { Name = "Glucose X" }
		};
	}
}