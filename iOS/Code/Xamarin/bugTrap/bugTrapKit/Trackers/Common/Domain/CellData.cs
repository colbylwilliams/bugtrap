using System.Collections.Generic;

namespace bugTrapKit
{
	public class CellData
	{
		public BugCellTypes CellType = BugCellTypes.Dispaly;

		public BugDetails.DetailType BugDetailType { get; set; }

		public bool Selected { get; set; }

		public Dictionary<DataKeys, string> Data { get; } = new Dictionary<DataKeys, string>();

		public void Set (DataKeys key, string value)
		{
			if (Data.ContainsKey(key)) Data[key] = value;
			else Data.Add(key, value);
		}

		public string Get (DataKeys key)
		{
			string val = null;

			Data.TryGetValue(key, out val);

			return val;
		}
	}
}