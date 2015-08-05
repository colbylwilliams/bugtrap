using System;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace bugTrapKit
{
	public class Tracker
	{
		public TrackerType TrackerType { get; private set; }

		public BugDetails Details { get; } = new BugDetails ();

		public Keychain<TrackerType> Keychain { get; }

		public bool Authenticated { get; set; }

		public ITrackerState TrackerState { get; set; }

		public ITrackerProxy TrackerProxy { get; set; }

		// public Dictionary<int, BugDetails.DetailType> TrackerDetails { get; set; }

		public bool HasAuthCredentials {
			get { return TrackerType.Valid(Keychain.GetStoredKeyValues()); }
		}

		public Tracker (TrackerType trackerType)
		{
			TrackerType = trackerType;
			// Details = new BugDetails ();
			Keychain = new Keychain<TrackerType> (trackerType);
			// TrackerDetails = new Dictionary<int, BugDetails.DetailType> ();
		}

		public async Task<bool> Authenticate (Dictionary<DataKeys, string> trackerData)
		{
			if (HasAuthCredentials) {

				try {
					
					var authResult = await TrackerProxy.Authenticate(trackerData);
				
					Authenticated = authResult;
				
					await PostAuthDataFetch();

				} catch (Exception ex) {

					Authenticated = false;

					Console.WriteLine(ex.Message);
				} 
			}

			return Authenticated;
		}

		public virtual Task PostAuthDataFetch ()
		{
			throw new NotImplementedException ();
		}

		public virtual Task<bool> LoadDataForActiveDetail ()
		{
			return Task.FromResult(true);
		}

		public virtual bool UpdateIssueFromSelection (int selectedIndex)
		{
			return false;
		}

		public virtual Task<bool> CreateIssue ()
		{
			return Task.FromResult(true);
		}
	}
}

