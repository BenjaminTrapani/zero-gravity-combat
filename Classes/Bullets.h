//
//  Bullets.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
@class Weapon;
@class Bullet;
@interface Bullets : CCNode {
	int idToAssign;
	int shotCount;
	int timeBetweenShots;
	int bulletIndex;
	BOOL usingRockets;
    int bulletBodyIndex;
    Bullet * bullet[10];
	int maxBullets;
}
@property(nonatomic,readwrite) BOOL usingRockets;
@property(nonatomic,readwrite) int bulletBodyIndex;
-(id)initWithGroupIndex:(int)index;
-(id)initForRocketsWithGroupIndex:(int)index;
-(void)fireBulletWithVelocity:(CGPoint)velocity bulletDegrees:(CGFloat)degrees world:(b2World*)world position:(CGPoint)shotPos gunman:(BodyNode*)currentGunMan weapon:(Weapon*)currentWeapon interval:(float)interval;
@end
