//
//  Soldier.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
#import "Weapon.h"
#import "Options.h"
const float kMaxTintForDamage = 0.40f;
@class JetPack;
@class CDXAudioNode;
@class Bullet;
@class HUD;
@interface Soldier : BodyNode {
	float maxSpeed;
    float accelerationSpeed;
	int soundCount;
	Weapon * primaryWeapon;
	Weapon * secondaryWeapon;
	NSString * currentWeapon;
	b2World * soldierWorld;
	JetPack * jetPack;
	BOOL isBeingForced;
	float health;
	float maxHealth;
	b2Body *lowerArmL;
	b2Body *lowerArmR;
	CDXAudioNode * pickupThump;
	float timeSinceLastHit;
	Options * o;
    BOOL cisIpad;
    
}
@property (nonatomic, readwrite)float maxSpeed; //useless until a certain part of the implementation is uncomented.
@property (nonatomic, readwrite)float accelerationSpeed;
@property (nonatomic, assign) Weapon * primaryWeapon;
@property (nonatomic, assign) Weapon * secondaryWeapon;
@property (nonatomic, assign) NSString * currentWeapon;
@property (nonatomic, assign) JetPack * jetPack;
@property (nonatomic, readwrite) float health;
+(id) soldierWithWorld:(b2World*)world;
-(void)onPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees;
-(void)onPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees direction:(NSString*)dir;
-(void)onWeaponFired:(CGPoint)velocity bulletDegrees:(CGFloat)degrees;
-(void)swapWeapon;
-(void)reloadWeapon;
-(Weapon*)getCurrentWeapon;
-(void)rotateGunToAngle:(float)angle;
-(void)rotateGunToAngle:(float)angle shaking:(BOOL)shaking;

-(void)takeDamage:(float)damage atPosition:(CGPoint)pos;
-(void)takeDamageFromBullet:(Bullet*)bullet;
-(Weapon*)updateCurrentWeaponWithWeapon:(Weapon*)newWeapon;
-(void)updateScreenTint;
@end
