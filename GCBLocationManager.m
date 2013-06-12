//
//  GCBLocationManager.m
//
//  Copyright (c) 2013 Georg C. Brückmann (http://gcbrueckmann.de/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "GCBLocationManager.h"

@interface GCBLocationManager () <CLLocationManagerDelegate> {
	NSMutableArray *_completionHandlers;
}

@property (readonly, strong) CLLocationManager *locationManager;

@end


@implementation GCBLocationManager

- (id)init {
	self = [super init];
	if (self) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_completionHandlers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_locationManager stopUpdatingLocation];
#if !__has_feature(objc_arc)
	[_locationManager release];
	[_completionHandlers release];
	[super dealloc];
#endif
}

- (void)updateLocationWithCompletionHandler:(void(^)(CLLocation *location, NSError *error))completionHandler {
#if !__has_feature(objc_arc)
	completionHandler = [[completionHandler copy] autorelease];
#endif
	[_completionHandlers addObject:completionHandler];
	[self.locationManager startUpdatingLocation];
}

- (void)cancelUpdatingLocation {
	[self invokeCompletionHandlersWithLocation:nil error:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (void)invokeCompletionHandlersWithLocation:(CLLocation *)location error:(NSError *)error {
	while (_completionHandlers.count != 0) {
		void (^ completionHandler)(CLLocation *location, NSError *error) = _completionHandlers[0];
		completionHandler(location, error);
		[_completionHandlers removeObjectAtIndex:0];
	}
}

#pragma mark - CLLocationManagerDelegate
// iOS 5
- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self invokeCompletionHandlersWithLocation:newLocation error:nil];
	[locationManager stopUpdatingLocation];
}

// iOS 6+
- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations {
	[self invokeCompletionHandlersWithLocation:[locations lastObject] error:nil];
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)locationManager didFailWithError:(NSError *)error {
	[self invokeCompletionHandlersWithLocation:nil error:error];
	[locationManager stopUpdatingLocation];
}

@end
