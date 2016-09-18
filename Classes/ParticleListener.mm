//
//  ParticleListener.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParticleListener.h"
#import "EventBus.h"
#import "HelloWorldLayer.h"
@implementation ParticleListener
@synthesize propulsionFlames;
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		//[[EventBus sharedEventBus]addSubscriber:self toEvent:@"bulletHit"];
		//[[EventBus sharedEventBus]addSubscriber:self toEvent:@"bulletFired"];
		propulsionFlames = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"propulsionFlames.plist"];
		//propulsionFlames.visible = NO;
		[propulsionFlames stopSystem];
		//[[HelloWorldLayer sharedHelloWorldLayer]addChild:propulsionFlames];
		[self addChild:propulsionFlames];
			}
	return self;
}

-(void)onBulletHit:(id)bullet position:(CGPoint)pos{
	//CCLOG(@"bulletHit called in listener");
	CCParticleSystem * bulletHit = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
	bulletHit.autoRemoveOnFinish = YES;
	bulletHit.position = pos;
	//[[HelloWorldLayer sharedHelloWorldLayer]addChild:bulletHit];
	[self addChild:bulletHit];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
