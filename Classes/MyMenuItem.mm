//
//  MyMenuItem.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMenuItem.h"


@implementation MyMenuItem
@synthesize customData;
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		
	}
	return self;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	[customData release];
	//CCLOG(@"my menu item deallocated"); this works
	//customData = nil;
	[super dealloc];
}

@end
