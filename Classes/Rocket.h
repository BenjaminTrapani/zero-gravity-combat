//
//  Rocket.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#define kRocketExplosionRange 50 //modify these to make rocket more balanced.
#define kRocketExplosionForce 20
#define kRocketDamageFactor 4 //used to be 2
#define kRocketDamageToSoldier kRocketDamageFactor/3
#define kRocketLifeTime 7 //the maximum amount of time a rocket can be live before self destructing
@class CDXAudioNode;
#import "BaseLevelObject.h"
@interface Rocket : BaseLevelObject {
    int damage;
    int nextOpenSlot;
    CCParticleSystem * trail;
    float timeToLive;
}
+(id)rocketWithWorld:(b2World*)world position:(CGPoint)bulletPosition angle:(float)inputAngle groupIndex:(int)index;
-(void)setAngle:(float)angle;
-(void)explode;
-(id) initWithWorld:(b2World*)world position:(CGPoint)pos angle:(float)initAngle groupIndex:(int)index;
-(void)Update:(ccTime)delta;
@property (nonatomic, readwrite) int damage;
@end
