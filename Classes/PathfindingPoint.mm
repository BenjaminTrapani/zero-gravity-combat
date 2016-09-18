//
//  PathfindingPoint.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PathfindingPoint.h"
#import "ccMacros.h"

@implementation PathfindingPoint
@synthesize point,parent,f,g,h,shouldIgnore;

+(id)PP{
	return [[[self alloc]init]autorelease];
}
-(id)init{
	if ((self = [super init])) {
		f = 0;
		g = 0;
		h = 0;
		shouldIgnore = NO;
	}
	return self;
}
-(void)setG:(float)newg{
	
	g = newg;
	f = g + h;
}
-(void)setH:(float)newh{
	
	h = newh;
	f = g + h;
}
-(void)dealloc{
	parent = nil;
	[super dealloc];
}

@end
