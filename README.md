# [bugTrap](http://bugtrap.io)
###What's here
---

There are two seperate projects, one in Swift and one in Xamarin.  The Xamarin version is not complete, but there's plenty there to run the app + library.

Each of the projects has a stand-alone app, and a framework that can be embedded into other apps.  The Swift version can also function as an Action Extension.

**Note: The Swift version will have to be built/run using Xcode 7 beta 5 (latest), as I just updated to Swift 2.0**


###App
---

To check out the stand-alone apps, just build and run the `bugTrap` project in either solution.


###Library / Embed
---

To test drive the library/embed in the **Swift** project, build and run the `SampleHostApp` target in Xcode.

To see the **Xamarin** version of the library/embed, build the `Insights` project in the `Xamarin` directory.  _Note: the Insights project references a .dll from the `bugTrapKit` project, so make sure you build `bugTrapKit` first to create the .dll in your bin folder._

----

Also some love from [DoneDone](https://www.getdonedone.com/track-ios-app-issues-bugtrap-donedone/) and [Pivotal Tracker](http://www.pivotaltracker.com/community/tracker-blog/app-tag/ios).


Let me know if you have any questions.

Colby

+1.918.671.5167
