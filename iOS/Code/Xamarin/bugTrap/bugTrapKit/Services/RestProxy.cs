using System;
using Foundation;
using ServiceStack;
using System.Threading.Tasks;

namespace bugTrapKit
{
	public class RestProxy
	{
		public string authHeader { get; set; }

		public JsonServiceClient Client { get; set; }

		NSUrlSessionConfiguration sessionConfig = NSUrlSessionConfiguration.DefaultSessionConfiguration;


		public RestProxy ()
		{
			Client = new JsonServiceClient ();
		}


		public void ConfigureClient ()
		{
			
		}


		public void SetAuthentication (AuthenticationType authenticationType, string username, string password, string token)
		{
//			switch (authenticationType) {
//			case AuthenticationType.Basic:
//				
//			}
		}



		public async Task<T> GetAsync<T> (string request)
		{
			try {

				return await Client.GetAsync<T>(request);
			
			} catch (Exception ex) {

				Console.WriteLine(ex.Message);
				throw;
				//Log.Error()
			}
		}


		// public async Task
	}
}