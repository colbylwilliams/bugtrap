# [bugTrap](http://bugtrap.io)

bugTrap is an iOS app that allows users to take a screenshot, annotate it and submit the issue and image to your existing tracking system; all from the same app. bugTrap simply makes it easier to create and submit issues directly to your tracker from the mobile device.  Download bugTrap for free from the App Store [here](https://itunes.apple.com/us/app/bugtrap/id917492878?mt=8).


What's here
----

There are two seperate projects, one in Swift and one in Xamarin.  The Xamarin version is not complete, but there's plenty there to run the app + library.

Each of the projects has a stand-alone app, and a framework that can be embedded into other apps.  The Swift version can also function as an Action Extension.

**Note: The Swift version will have to be built/run using Xcode 7, as I just updated to Swift 2.0**


App
----

To check out the stand-alone apps, just build and run the `bugTrap` project in either solution.


Library / Embed
----

To test drive the library/embed in the **Swift** project, build and run the `SampleHostApp` target in Xcode.

To see the **Xamarin** version of the library/embed, build the `Insights` project in the `Xamarin` directory.  _Note: the Insights project references a .dll from the `bugTrapKit` project, so make sure you build `bugTrapKit` first to create the .dll in your bin folder._


Love
----

Also some love from [DoneDone](https://www.getdonedone.com/track-ios-app-issues-bugtrap-donedone/) and [Pivotal Tracker](http://www.pivotaltracker.com/community/tracker-blog/app-tag/ios).


License
----
The MIT License (MIT)

Copyright (c) 2015 Colby Williams

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.