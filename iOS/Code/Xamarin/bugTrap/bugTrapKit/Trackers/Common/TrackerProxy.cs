using System;
using ServiceStack;
using System.Threading.Tasks;

namespace bugTrapKit
{
	public class TrackerProxy
	{

		public JsonServiceClient Client { get; set; }



		public TrackerProxy ()
		{
		}


		public virtual void ConfigureClient (string baseUri)
		{
			Client = new JsonServiceClient (baseUri);
		}

		public async Task<T> GetAsync<T> (string request)
			where T : class, new()
		{
			try {

				return Client == null ? new T() : await Client.GetAsync<T>(request);

			} catch (WebServiceException webEx) {

				Console.WriteLine(webEx.Message);
				throw;

			} catch (Exception ex) {

				Console.WriteLine(ex.Message);
				throw;
				//Log.Error()
			}
		}


		public async Task<T> PostAsync<T> (string request, object item)
			where T : class, new()
		{
			try {

				return Client == null ? new T() : await Client.PostAsync<T>(request, item);

			} catch (Exception ex) {

				Console.WriteLine(ex.Message);
				throw;
				//Log.Error()
			}
		}

		public async Task<byte[]> GetBytesAsync (string request)
		{
			try {

				return Client == null ? null : await Client.GetAsync<byte[]>(request);

			} catch (Exception ex) {

				Console.WriteLine(ex.Message);
				throw;
				//Log.Error()
			}
		}
	}
}