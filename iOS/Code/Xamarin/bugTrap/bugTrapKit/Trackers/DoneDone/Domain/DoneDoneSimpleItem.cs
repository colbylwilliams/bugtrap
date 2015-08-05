namespace bugTrapKit.DoneDone
{

	public class DoneDoneSimpleItem
	{
		public int Id { get; set; }

		public string Name { protected get; set; }

		public string Title { protected get; set; }

		public string Value {
			get {
				return Title ?? Name;
			}
			set {
				Name = value;
				Title = value;
			}
		}

		public bool HasValue {
			get {
				return !string.IsNullOrEmpty (Value);
			}
		}
	}
}