using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using Foundation;
using UIKit;
using ServiceStack;
using System.Linq;

namespace bugTrapKit.DoneDone
{
	public class DoneDoneProxy : TrackerProxy, ITrackerProxy
	{
		//const string urlBase = "https://{0}.mydonedone.com/issuetracker/api/v2/{1}";
		const string baseUri = "https://{0}.mydonedone.com/issuetracker/api/v2/";

		string subdomain;

		/*RestProxy restProxy = new RestProxy ();*/

		public DoneDoneProxy ()
		{
		}


		#region ITrackerProxy implementation

		public async Task<bool> Authenticate (Dictionary<DataKeys, string> trackerData)
		{
			string sub = string.Empty, username = string.Empty, password = string.Empty;

			if (trackerData.TryGetValue(DataKeys.Subdomain, out sub)) subdomain = sub; // Do we have a subdomain?
			else if (string.IsNullOrEmpty(subdomain)) return false; // Maybe we already have this saved

			// Do we have a username?
			if (!trackerData.TryGetValue(DataKeys.UserName, out username)) return false;

			// Do we have a subdomain?
			if (!trackerData.TryGetValue(DataKeys.Password, out password)) return false;


			if (!string.IsNullOrEmpty(username) && !string.IsNullOrEmpty(password)) {
				// restProxy.SetAuthentication(AuthenticationType.Basic, username, password, null);

				ConfigureClient(baseUri.Fmt(subdomain));

				Client.SetCredentials(username, password);

				if (await VerifyAuthentication()) {
//					Insights.Identify(Settings.UserReferenceKey, new Dictionary<string, string> {
//						{ InsightsKeys.DoneDone.Subdomain, subdomain },
//						{ InsightsKeys.DoneDone.Username, username }
//					});
					return true;
				}
			}

			return false;
		}



		// TODO: find something better to check than project count
		public async Task<bool> VerifyAuthentication () => (await GetSimpleProjects()).Count > 0;



		public Task<NSData> GetDataForUrl (string url)
		{
			throw new NotImplementedException ();
		}

		#endregion



		async Task<List<DoneDoneSimpleItem>> GetSimpleProjects () =>
			await GetAsync<List<DoneDoneSimpleItem>>("projects.json");



		public async Task<List<DoneDoneProject>> GetProjects ()
		{
			var simples = await GetSimpleProjects();

			var tasks = new List<Task<DoneDoneProject>> ();

			foreach (var simple in simples) tasks.Add(GetProjectDetails(simple));

			return (await Task.WhenAll(tasks))?.ToList() ?? new List<DoneDoneProject> ();
		}



		public async Task<DoneDoneProject> GetProjectDetails (DoneDoneSimpleItem project) =>
			await GetAsync<DoneDoneProject>($"projects/{project.Id}.json");



		public async Task<List<DoneDonePerson>> GetPeople (int projectId)
		{
			var simples = await GetAsync<List<DoneDoneSimpleItem>>($"projects/{projectId}/people.json");

			var tasks = new List<Task<DoneDonePerson>> ();

			foreach (var simple in simples) tasks.Add(GetPersonDetails(simple));

			return (await Task.WhenAll(tasks))?.ToList() ?? new List<DoneDonePerson> ();
		}



		public async Task<DoneDonePerson> GetPersonDetails (DoneDoneSimpleItem person) =>
			await GetAsync<DoneDonePerson>($"people/{person.Id}.json");



		public async Task<UIImage> GetPersonImage (DoneDonePerson person)
		{
			var imageData = await GetBytesAsync(person.AvatarUrl);
			using (var data = NSData.FromArray(imageData)) return UIImage.LoadFromData(data);
		}



		public async Task<List<DoneDoneSimpleItem>> GetPriorityLevels () =>
			await GetAsync<List<DoneDoneSimpleItem>>("priority_levels.json");



		public async Task<DoneDoneSimpleItem> CreateIssueForProject (DoneDoneIssue issue)
		{
			throw new NotImplementedException ();
		}
	}
}