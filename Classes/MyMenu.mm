//
//  MyMenu.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMenu.h"
#import "HelloWorldLayer.h"
#import "GameController.h"
@implementation MyMenu
@synthesize isContinuous;

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	touchLocation = [[HelloWorldLayer sharedHelloWorldLayer]makePointRelative:touchLocation];
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
            CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
			//CCLOG(@"localX = %f localy = %f",local.x,local.y);
			if( CGRectContainsPoint( r, local ) )
				return item;

			/*
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];  
            //GameController * gc = [[HelloWorldLayer sharedHelloWorldLayer]getGameController];
			r.origin = [item convertToWorldSpace:item.position];
            r.origin.x += item.contentSize.width * item.anchorPoint.x;
            r.origin.y += item.contentSize.height * item.anchorPoint.y;
            
			CCLOG(@"touchLocation.x = %f .y = %f",touchLocation.x,touchLocation.y);
            CCLOG(@"originx = %f originy = %f",r.origin.x,r.origin.y);
			if( CGRectContainsPoint( r, touchLocation ) )
				return item;
             */
		}
	}
	return nil;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( state_ != kCCMenuStateWaiting || !visible_ )
		return NO;
	
	selectedItem_ = [self itemForTouch:touch];
	[selectedItem_ selected];
    if (isContinuous) {
        [selectedItem_ activate];//added this
    }
	
	
	if( selectedItem_ ) {
        if (isContinuous) {
            [self schedule:@selector(activateItemEveryFrame:)];
        }
		
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	return NO;
}



-(void)activateItemEveryFrame:(ccTime*)delta{
	[selectedItem_ activate];
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
	[selectedItem_ unselected];
	[self unschedule:@selector(activateItemEveryFrame:)];
    
	if (!isContinuous) {
        [selectedItem_ activate]; //commented this out
    }
	
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
	
	[selectedItem_ unselected];
	[self unschedule:@selector(activateItemEveryFrame:)];
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [super itemForTouch:touch];
	
	if (currentItem != selectedItem_) {
		[selectedItem_ unselected];
		selectedItem_ = currentItem;
		[selectedItem_ selected];
	}
}

@end
