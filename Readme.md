# GCBLocationManager

Version 1.0 – 2013-06-12

by Georg C. Brückmann  
<http://gcbrueckmann.de>


## Introduction

A simple wrapper around `CLLocationManager` that uses a completion handlers
instead of a delegate to handle updates.

## Example
	
	- (void)viewDidAppear:(BOOL)animated {
		[self.locationManager updateLocationWithCompletionHandler:^(CLLocation *location, NSError *error) {
			if (error) {
				if ([error.domain isEqualToString:NSCocoaErrorDomain] && error.code == NSUserCancelledError) {
					return;
				} else if ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied) {
					[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Current location not available", @"Title for the error alert displayed when the current location could not be determined.") message:NSLocalizedString(@"You have previously denied Shopping Graz to determine your current location. Please allow Shopping Graz to access your current location in the Settings app.", @"Error message displayed when the user tries to find a route to a shop but has previously denied the app to access their current location.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Generic OK button title.") otherButtonTitles:nil] show];
					return;
				}
				// TODO: Show error.
				return;
			}
			// TODO: Handle location update.
		}];
	}
	
	- (void)viewWillDisappear:(BOOL)animated {
		[self.locationManager cancelUpdatingLocation];
	}

## License

Copyright (c) 2013 Georg C. Brückmann (http://gcbrueckmann.de/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.