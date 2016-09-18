//
//  Weapon.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Bullets.h"
#import "SimpleAudioEngine.h"
#import "BodyNode.h"
#import "CDXAudioNode.h"
@class LazerSight;
@class BodyPart;
@interface Weapon :BodyNode {
	float accuracy;
	float damage;
	float recoil;
	float rateOfFire;
	float timeBetweenShots;
	float magCapacity;
	float numMags;
	float reloadTime;
	int shotCount;
	BOOL isFiring;
	float timeSinceLastShot;
	int shotsLeftInMag;
	int magsLeft;
	BOOL canShoot;
	int timeToReload;
	float reloadDelay;
	float rawMagCapacity;
	//ALuint reloadSound;
	NSString * gunName;
	NSString * fireType;
	BOOL hasFiringStickBeenDead;
	BOOL isOutOfAmmo;
	BOOL isReloading;
	CCSprite * gun;
	int semiAutoDelay;
	float saDelayCount;
	CDXAudioNode * gunShot;
	CDXAudioNode * reloadSound;
	CDXAudioNode * boltActionSound;
	CDXAudioNode * sharpClick;
	CDXAudioNode * addBullets;
	Bullets*bullets;
	int reloadProgress;
	LazerSight * lazerSight;
	//float particleDegrees;
	float interval;
    BOOL hasCarrier;
    BOOL isCarrierSoldier;
    BOOL isRocketLauncher;
    BodyNode * gunMan;
    CCSprite * muzzleFrame[10];
    int animationIndex;
    int requiredUnlockLevel;
}
// all these are values between 1 and 10. 10 is the best, 1 is the worst.
@property (nonatomic, readwrite) float accuracy;
@property (nonatomic, readwrite) float damage;
@property (nonatomic, readwrite) float recoil;
@property (nonatomic, readwrite) float rateOfFire;
@property (nonatomic, readwrite) float reloadTime;
@property (nonatomic, readwrite) float magCapacity;
@property (nonatomic, readwrite) float numMags;
@property (nonatomic, readwrite) int shotsLeftInMag;
@property (nonatomic, readwrite) int magsLeft;
@property (nonatomic, readwrite) BOOL isFiring;
@property (nonatomic, retain) NSString * gunName;
@property (nonatomic, retain) NSString * fireType; //fa = full auto, sa = semi auto ss = single shot
@property (nonatomic, readwrite) int timeToReload;
@property (nonatomic, readwrite) BOOL isReloading;
@property (nonatomic, assign) CCSprite * gun;
@property (nonatomic, assign)CDXAudioNode * gunShot;
@property (nonatomic, readwrite) int reloadProgress; //in percent. 0-100
@property (nonatomic, assign) LazerSight * lazerSight;
@property (nonatomic, readwrite) BOOL hasCarrier;
@property (nonatomic,assign) id gunMan;
@property (nonatomic, readwrite) BOOL isRocketLauncher;
@property (nonatomic, readwrite) int requiredUnlockLevel;
-(void)fireBulletWithVelocity:(CGPoint)velocity bulletDegrees:(CGFloat)degrees world:(b2World*)world position:(CGPoint)shotPos gunman:(BodyNode*)currentGunMan;
-(void)reloadGun;
-(void)updateDataWithWeapon:(Weapon*)weapon;
-(void)onSoldierCreated;
-(void)onSoldierCreatedAsParent;
-(id)initWithGunTag:(int)gunTag;
+(id)gunWithName:(NSString*)name;
+(id)gunWithTag:(int)gunTag;
+(id)randomPrimaryWithId:(int)identity;
+(id)gunWithName:(NSString *)name ID:(int)idtt;
-(void)onLinkedBodyDestroyed:(BodyPart*)destroyedBody withPoint:(CGPoint)bloodPos;
 
@end
