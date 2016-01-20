# FP20Crash
FlashPlayer 20.0.0.267 crashes randomly without any clear error, just hangs up and doesn't respond for indefinite time.

We actively use movieClip's timeline for creating and handling user interfaces.
We analized cases, when it occurs and have done test project, which always reproduces the crash.
All we do is repeatedly call gotoAndStop to different frames for selected movieclip with different hierarchical structure of children with their own timelines. And at the same time we repeatedly load images, create and clear loaders to make GarbageCollector work hardly.

GitHub repository with source code and binary result: https://github.com/himanych/FP20Crash

Important things about test:
The structure of animated movieClip is important. We detected one, which gives 100% effect. Any significant changes can change the case and avoid crashing.
1. Target clip which timeline is switched, contains children with their own timeline. Some of the children should contain dynamic textFields.
2. One or many child clips contain empty frames in timeline.

To get the crash open FP20Crash.swf in FlashPlayer 20.0.0.267 (stand alone or any browser) and wait. It happens quickly, in our tests it crashes after 5-20 secs.
