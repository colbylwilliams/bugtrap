using System;
using System.Linq;
using System.Collections.Generic;
using bugTrapKit.DoneDone;
using bugTrapKit.Pivotal;
using bugTrapKit.Jira;
using System.Threading.Tasks;

namespace bugTrapKit
{
	public class TrackerService
	{
		// static readonly TrackerService shared = new TrackerService ();

		public static TrackerService Shared { get; } = new TrackerService ();

		public TrackerService ()
		{

		}

		// trackerType drives the state of the app
		// (i.e. if there is a trackerType set, we know we're in a 'new Issue' flow)
		// So it's very important to set it back to .None
		TrackerType trackerType = TrackerType.None;

		Dictionary<TrackerType, Tracker> trackers = new Dictionary<TrackerType, Tracker> ();

		public async void Authenticate ()
		{
			var tasks = new List<Task<bool>> ();

			foreach (var type in TrackerTypes.Values.Where(t => t.Enabled())) {

				tasks.Add(GetTrackerInstance(type).Authenticate(TrackerHasAuthCredentials(type)));
			}

			await Task.WhenAll(tasks);
		}


		public Tracker CurrentTracker {
			get { return trackerType.Enabled() ? trackers[trackerType] ?? GetTrackerInstance(trackerType) : null; }
		}


		public bool HasCurrentAuthenticatedTracker {
			get { return trackerType != TrackerType.None && CurrentTracker != null && CurrentTracker.Authenticated; }
		}


		public void ResetAndRemoveCurrentTracker ()
		{
			CurrentTracker.TrackerState.Reset();
			trackerType = TrackerType.None;
		}


		public List<TrackerType> GetTrackerTypesByStatus (TrackerStatus status)
		{ 
			return TrackerTypes.Values.Where(t => t.Status() == status).ToList();
		}


		public Dictionary<TrackerStatus, List<TrackerType>> GetTrackerTypesByStatus ()
		{
			return TrackerTypes.Values.GroupBy(t => t.Status(), t => t).ToDictionary(g => g.Key, v => v.ToList());
		}



		public Dictionary<TrackerType, string> GetUsernamesForEnabledTrackerTypes (List<TrackerType> enabledTrackerTypes)
		{
			var dictionary = new Dictionary<TrackerType, string> ();

			foreach (var t in enabledTrackerTypes) {

				var username = string.Empty;

				(new Keychain<TrackerType> (t))?.GetStoredKeyValues()?.TryGetValue(DataKeys.UserName, out username);

				dictionary.Add(t, username);

				// if (!string.IsNullOrEmpty(username)) dictionary.Add(t, username);
			}

			return dictionary;
			// return enabledTrackerTypes.ToDictionary(t => t, v => (new Keychain<TrackerType> (v))?.GetStoredKeyValues()?[DataKeys.UserName] ?? string.Empty);
		}


		/// <summary>
		/// Sets the type of the current tracker.
		/// </summary>
		/// <returns><c>true</c>, if the keys needed are in the keychain, <c>false</c> otherwise.</returns>
		/// <param name="trackerType">Tracker type.</param>
		public bool SetCurrentTrackerType (TrackerType trackerType)
		{
			this.trackerType = trackerType;

			return trackerType == TrackerType.None || TrackerHasAuthCredentials(trackerType) != null;
		}


		/// <summary>
		/// Trackers the has auth credentials.
		/// </summary>
		/// <returns>the dictionary if the keys needed are in the keychain, <c>null</c> otherwise.</returns>
		/// <param name="trackerType">Tracker type.</param>
		public Dictionary<DataKeys, string> TrackerHasAuthCredentials (TrackerType trackerType)
		{
			var storedValues = new Keychain<TrackerType> (trackerType).GetStoredKeyValues();

			return trackerType.Valid(storedValues) ? storedValues : null;
		}


		public Tracker GetTrackerInstance (TrackerType trackerType)
		{
			if (trackers.ContainsKey(trackerType)) return trackers[trackerType];

			switch (trackerType) {
			case TrackerType.DoneDone:
				trackers[trackerType] = new DoneDoneTracker (trackerType);
				break;
			case TrackerType.PivotalTracker:
				trackers[trackerType] = new PivotalTracker (trackerType);
				break;
			case TrackerType.JIRA:
				trackers[trackerType] = new JiraTracker (trackerType);
				break;
			default:
				return null;
			}

			return trackers[trackerType];
		}
	}
}