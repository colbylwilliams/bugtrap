namespace bugTrapKit
{
	public class TrackerInstance<TState, TProxy> : Tracker
		where TState : class, ITrackerState, new()
		where TProxy : class, ITrackerProxy, new()
	{

		public TState State { get; }
// = new TState ();

		public TProxy Proxy { get; }
// = new TProxy();

		public TrackerInstance (TrackerType trackerType) : base(trackerType)
		{
			var trackerData = Keychain.GetStoredKeyValues();

			State = new TState ();
			Proxy = new TProxy ();

			TrackerState = State;
			TrackerProxy = Proxy;

			// TrackerDetails = TrackerState.TrackerDetails;
		}
	}
}