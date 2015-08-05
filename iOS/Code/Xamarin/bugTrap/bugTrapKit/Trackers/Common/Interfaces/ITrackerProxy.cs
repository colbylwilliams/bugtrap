using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Foundation;

namespace bugTrapKit
{
	public interface ITrackerProxy
	{
	
		Task<bool> Authenticate (Dictionary<DataKeys, string> trackerData);

		Task<bool> VerifyAuthentication ();

		Task<NSData> GetDataForUrl (string url);
	}
}