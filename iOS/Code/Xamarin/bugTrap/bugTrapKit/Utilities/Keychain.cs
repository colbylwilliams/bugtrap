using System;
using System.Collections.Generic;
using Security;
using Foundation;
using System.Linq;
using MobileCoreServices;
using System.Runtime.InteropServices;
using ObjCRuntime;
using CoreFoundation;

namespace bugTrapKit
{
	public class Keychain<TService>
		//where TService : class
	{
		readonly TService service;

		public Keychain (TService service)
		{
			this.service = service;
		}

		public Dictionary<DataKeys, string> GetStoredKeyValues ()
		{
			// Log.info(service.ToString(), "Keychain -- GetStoredKeyValues")

			DataKeys key;

			SecStatusCode status;


			var dataDictionary = new Dictionary<DataKeys, string> ();

			// this query setup will return all matches for the given service (DoneDone, JIRA, etc.)
			var records = SecKeyChain.QueryAsRecord(serviceGenericSecRecord(), 1000, out status);

			if (status == SecStatusCode.Success && records != null) {

				foreach (var query in records) {

					var record = SecKeyChain.QueryAsRecord(serviceGenericSecRecord(query.Account), out status);

					if ((status == SecStatusCode.Success && record != null) &&
					    Enum.TryParse<DataKeys>(record.Account, out key)) {

						if (record.ValueData != null) {
							dataDictionary.Add(key, NSString.FromData(record.ValueData, NSStringEncoding.UTF8).ToString());
						}
					}
				}
			}

			return dataDictionary;
		}


		public bool StoreKeyValues (Dictionary<DataKeys, string> values)
		{
			bool success = false;

			foreach (var keyValue in values) {

				var queryRecord = serviceGenericSecRecord(keyValue.Key.ToString());

				queryRecord.ValueData = NSData.FromString(keyValue.Value, NSStringEncoding.UTF8);
					
				// Delete any existing items
				SecKeyChain.Remove(queryRecord);

				// Add the new keychain item
				var status = SecKeyChain.Add(queryRecord);

				success = status == SecStatusCode.Success;

				if (!success) printErrorForSecStatus(status);
			}

			return success;
		}


		SecRecord serviceGenericSecRecord (string account = null)
		{
			var record = new SecRecord (SecKind.GenericPassword) { 
				Service = service.ToString(),
				AccessGroup = AppKeys.AccessGroup
			};

			if (!string.IsNullOrEmpty(account)) record.Account = account;

			return record;
		}


		void printErrorForSecStatus (SecStatusCode status)
		{
			
		}
	}
}

