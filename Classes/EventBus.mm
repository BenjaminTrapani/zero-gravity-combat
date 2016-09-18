//
//  EventBus.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventBus.h"
#import "Soldier.h"

@implementation EventBus
static EventBus *instanceOfEventBus;

+(id) alloc
{
	@synchronized(self)
	{
		NSAssert(instanceOfEventBus == nil, @"Attempted to allocate a second instance of the singleton: EventBus");
		instanceOfEventBus = [[super alloc] retain];
		return instanceOfEventBus;
	}
	return nil;
}

+(EventBus*) sharedEventBus
{
	@synchronized(self)
	{
		if (instanceOfEventBus == nil)
		{
			[[EventBus alloc] init];
		}
		
		return instanceOfEventBus;
	}
	
	// to avoid compiler warning
	return nil;
}
-(id) init
{
	if ((self =[super init])) {
		playerMovedSubscribers = [[CCArray alloc]initWithCapacity:5];
		weaponFiredSubscribers = [[CCArray alloc]initWithCapacity:15];
		bulletHitSubscribers = [[CCArray alloc]initWithCapacity:15];
		bulletFiredSubscribers = [[CCArray alloc]initWithCapacity:15];
		
	}
	return self;
}
-(void) dealloc
{
	
	[instanceOfEventBus release];
	instanceOfEventBus = nil;
	[playerMovedSubscribers release];
	[weaponFiredSubscribers release];
	[bulletHitSubscribers release];
	[bulletFiredSubscribers release];
	
	[super dealloc];
}
-(void)addSubscriber:(id)subscriber toEvent:(NSString*)event{
	if (event == @"playerMoved") {
		[playerMovedSubscribers addObject:subscriber];
	}
	if (event == @"weaponFired") {
		[weaponFiredSubscribers addObject:subscriber];
	}
	if (event == @"bulletHit") {
		[bulletHitSubscribers addObject:subscriber];
	}
	if (event == @"bulletFired") {
		CCLOG(@"object added to event bullet fired");
		[bulletFiredSubscribers addObject:subscriber];
	}
	if (event == @"soldierCreated") {
        //CCLOG(@"subscriber added to soldierCreated with description: %@",[subscriber description]);
        NSAssert(1==0, @"soldier created event doesn't exist anymore");
		
	}
	[subscriber release];
}
-(void)removeSubscriber:(id)subscriber fromEvent:(NSString*)event{
    [subscriber retain];
	if (event == @"playerMoved") {
		[playerMovedSubscribers removeObject:subscriber];
		//CCLOG(@"subscriber removed from playerMoved");
	}
	if (event == @"weaponFired") {
		[weaponFiredSubscribers removeObject:subscriber];
		//CCLOG(@"subscriber removed from weaponFired");
	}
	if (event == @"bulletHit") {
		[bulletHitSubscribers removeObject:subscriber];
		//CCLOG(@"subscriber removed from bulletHit");
	}
	if (event == @"bulletFired") {
		CCLOG(@"object added to event bullet fired");
		[bulletFiredSubscribers removeObject:subscriber];
		//CCLOG(@"subscriber removed from bulletFired");
	}
	if (event == @"soldierCreated") {
        NSAssert(1==0, @"soldier created event doesn't exist anymore");
		
		//CCLOG(@"subscriber removed from soldierCreated");
	}
	
}
-(void)doPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees{
    for (id object in playerMovedSubscribers) {
        [object onPlayerMoved:velocity jdegrees:degrees];
    }
}
-(void)doPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees direction:(NSString*)dir{
	for (id currentSubscriber in playerMovedSubscribers) {
        [currentSubscriber onPlayerMoved:velocity jdegrees:degrees direction:dir];
    }
}
-(void)doWeaponFired:(CGPoint)velocity bulletDegrees:(float)degrees{
    for (id currentSubscriber in weaponFiredSubscribers) {
        [currentSubscriber onWeaponFired:velocity bulletDegrees:degrees];
    }
}
-(void)doBulletHit:(id)bullet position:(CGPoint)pos{
    
	for (id currentSubscriber in bulletHitSubscribers) {
        [currentSubscriber onBulletHit:bullet position:pos];
    }
	
}
-(void)doBulletFired:(CGPoint)pos shotAngle:(float)degrees{
	for (id currentSubscriber in bulletFiredSubscribers) {
        [currentSubscriber onBulletFired:pos shotAngle:degrees];
    }
			
}

-(void)clearEvents{
	[playerMovedSubscribers removeAllObjects];
	[weaponFiredSubscribers removeAllObjects];
	[bulletHitSubscribers removeAllObjects];
	[bulletFiredSubscribers removeAllObjects];
    //int soldierSubscribers = [soldierCreatedSubscribers count];
    /*for (int i = 0; i<soldierSubscribers; i++) {
        id curSubscriber = [soldierCreatedSubscribers objectAtIndex:i];
        CCLOG([curSubscriber description]);
    }
     */
    //create soldier up front and get rid of soldierCreated event. scratch that, you can't. Better to initialize level first. Delete soldier created subscribers here as they are called because it is only called once
	//[soldierCreatedSubscribers removeAllObjects];
    
    /*int count = [soldierCreatedSubscribers count];
    for (int i = 0; i<count; i++) {
        CCNode * curObject = [soldierCreatedSubscribers objectAtIndex:i];
        if (curObject !=nil) {
            [soldierCreatedSubscribers removeObjectAtIndex:i];
        }
        
    }
     */
}
@end
