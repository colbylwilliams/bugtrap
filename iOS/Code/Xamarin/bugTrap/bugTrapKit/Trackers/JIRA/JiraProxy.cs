﻿using System;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace bugTrapKit.Jira
{
	public class JiraProxy : ITrackerProxy
	{
		public JiraProxy ()
		{
		}

		#region ITrackerProxy implementation

		public Task<bool> Authenticate (Dictionary<DataKeys, string> trackerData)
		{
			throw new NotImplementedException ();
		}

		public Task<bool> VerifyAuthentication ()
		{
			throw new NotImplementedException ();
		}

		public Task<Foundation.NSData> GetDataForUrl (string url)
		{
			throw new NotImplementedException ();
		}

		#endregion
	}
}
