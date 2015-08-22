using System;
using UIKit;

namespace Insights.iOS
{
	public static class StoryboardExtensions
	{
		public static T Instantiate<T> (this UIStoryboard storyboard) where T : UIViewController
		{
			return storyboard.InstantiateViewController(typeof(T).Name) as T;
		}

		public static T Instantiate<T> (this UIStoryboard storyboard, string name) where T :  UIViewController
		{
			return storyboard.InstantiateViewController(name) as T;
		}

		public static UIViewController Instantiate (this UIStoryboard storyboard, string name)
		{
			return storyboard.InstantiateViewController(name) as UIViewController;
		}
	}
}