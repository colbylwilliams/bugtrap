/*
 Raygun.h
 Raygun4iOS

 Copyright (C) 2013 Mindscape

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions
 of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 Author: Martin Holman, martin@raygun.io

*/

#import <Foundation/Foundation.h>

@interface Raygun : NSObject

@property (nonatomic, readonly, copy) NSString *apiKey;

/**
 Creates and returns a singleton raygun reporter with the given API key. If a singleton has already been created, this method has no effect

 @param theApiKey The Raygun API key

 @return A new singleton crash reporter with the given API key, or an existing reporter. The existing reporter will have the originally
         specified API key
*/
+ (id)sharedReporterWithApiKey:(NSString *)theApiKey;

/**
 Returns the shared singleton crash reporter instance
 
 @warning This method does not create an instance of the crash reporter
 
 @return The existing shared singleton crash reporter instance or nil if it has not been created yet.
*/
+ (id)sharedReporter;

/**
 Creates and returns a raygun reporter with the given API key. Use this to manage the crash reporter singleton yourself.
 
 @warning you should only have one instance of the reporter for your application, do not create multiple instances of the reporter
 or use the shared reporter along side this method.

 @param theApiKey the Raygun API key
 
 @return a new raygun crash reporter
*/
- (id)initWithApiKey:(NSString *)theApiKey;

/**
 Generates a crash report at the current execution point. Useful for testing the crash reporter setup.
 
 @warning this will not crash your application, only send a crash report to Raygun.
*/
- (void)crash;

/**
  Manually send an exception to Raygun with the current state of execution.
 
  @warning backtrace will only be populated if you have caught the exception
*/
- (void)send:(NSException *)exception;

/**
 Identify a user to Raygun. This can be a database id or an email address. Anonymous users
 will have a device id generated for them, you do not need to call this method to identify
 anonymous users.
*/
- (void)identify:(NSString *)userId;

@end
