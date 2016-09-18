//
//  EventBus.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Note to self: in the future, make an even bus with a single NSDictionary. Have 3 functions in eventBus. addObject:(id)object forKey:(NSString*)key, the equavalent to remove,and performEventForKey:(NSString*)key
#import "cocos2d.h"
@class Soldier;
@interface EventBus : NSObject {
	CCArray * playerMovedSubscribers;
	CCArray * weaponFiredSubscribers;
	CCArray * bulletHitSubscribers;
	CCArray * bulletFiredSubscribers;
}
+(EventBus*)sharedEventBus;
-(void)addSubscriber:(id)subscriber toEvent:(NSString*)event;
-(void)removeSubscriber:(id)subscriber fromEvent:(NSString*)event;
-(void)doPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees;
-(void)doPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees direction:(NSString*)dir;
-(void)doWeaponFired:(CGPoint)velocity bulletDegrees:(float)degrees;
-(void)doBulletHit:(id)bullet position:(CGPoint)pos;
-(void)doBulletFired:(CGPoint)pos shotAngle:(float)degrees;

-(void)clearEvents;
@end
