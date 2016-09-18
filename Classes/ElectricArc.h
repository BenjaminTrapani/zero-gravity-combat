//
//  ElectricArc.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"
#define SJ_PI_X_2 6.28318530718f
#define kElectricArcDamage 20
@class CDXAudioNode;
@class ElectricEnd;
@class Soldier;
@interface ElectricArc : BodyNode <NSCoding>{
	CDXAudioNode * buzz;
	BaseLevelObject * top;
	BaseLevelObject * bottom;
	float globalRadius;
	b2World * _world;
	Soldier*localSoldier;
    CGPoint _pos1;
    CGPoint _pos2;
    float _radius;
	//BodyNode * creator;
}
+(id)electricArcWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius;
-(void)onObjectDestroyed:(BodyNode*)obj;
@end
