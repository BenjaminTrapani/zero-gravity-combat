//
//  JetPack.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JetPack.h"
#import "EventBus.h"
#import "HelloWorldLayer.h"
#import "Options.h"
#import "Soldier.h"
@implementation JetPack
@synthesize angle;
@synthesize fakeParentPos;
@synthesize posOffset;
@synthesize jp;
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		jp = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"propulsionFlames.plist"];
		jp.positionType = kCCPositionTypeFree;
		jp.position = CGPointZero;
		[jp stopSystem];
		[self addChild:jp];
		[self schedule:@selector(UpdateJet:)];
		isActive = NO;
		inactiveCount = 0;
		
		soundCount = 0;
        
		JetPackSound = [CDXAudioNode audioNodeWithFile:@"propulsionSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        
        JetPackSound.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        [self addChild:JetPackSound];

		CCLOG(@"jet pack inited");
	}
	return self;
}
-(id)initForLaterSoundAddition{
    if( (self=[super init])) {
		jp = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"propulsionFlames.plist"];
		jp.positionType = kCCPositionTypeFree;
		jp.position = CGPointZero;
		[jp stopSystem];
		[self addChild:jp];
		[self schedule:@selector(UpdateJet:)];
		isActive = NO;
		inactiveCount = 0;
		
		soundCount = 0;
        
        CCLOG(@"jet pack inited");
	}
	return self;

}
-(void)createSound{
    JetPackSound = [CDXAudioNode audioNodeWithFile:@"propulsionSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
    
    JetPackSound.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
    [self addChild:JetPackSound];
}
-(void)UpdateJet:(ccTime)delta{
    interval = 60*delta; 
	self.position = ccp(self.fakeParentPos.x, self.fakeParentPos.y);
	inactiveCount ++;
	if (inactiveCount>3) { //used to be 10
		[self stopEmitting];
	}
}
-(void)setAngle:(float)tangle{
	jp.angle = tangle;
	//self.angle = tangle;
}
-(void)emit{
	inactiveCount = 0;
	[self startEmitting];
	soundCount+=interval;
	if (soundCount>3) {
		soundCount = 0;
		[JetPackSound play];
	}
	
}
-(void)startEmitting{
	if (isActive == NO) {
		isActive = YES;
		[jp resetSystem];
	}
	
}
-(void)stopEmitting{
	if (isActive == YES) {
		isActive = NO;
		[jp stopSystem];
	}
	
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    //[self retain];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
	[super dealloc];
}

@end
