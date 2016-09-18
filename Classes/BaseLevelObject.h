//
//  BaseLevelObject.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/25/11.
//  Copyright 2011 __SB Games__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyNode.h"
#import "Bullet.h"
@class CDXAudioNode;
@interface BaseLevelObject : BodyNode {
	float health;
	BOOL destructible;
	BOOL explosive;
	CCParticleSystem * destructionParticle;
	CDXAudioNode * destructionSound;
	ccColor3B contactColor;
	float explosionForce;
	float explosionRange;
	CGSize dimensions;
	BOOL takesDamageFromCollisions;
    BOOL takesDamageFromBullets;
	BOOL exploded;
	//id destructionListener;
    BOOL isSwitch;
    SwitchEvent switchEvent;
    NSMutableArray * switchSubscribers;
    BOOL showParticlesForContacts;
    BOOL proceduralDestruction;
    NSString * pdParticle;
    NSString * pdSoundEffect;
    float pdRate;
    int numberOfDamages; //the number of places that this object has been damaged. Used only if object is procedurally destructible
    
}



@property(nonatomic,readwrite) float health;
@property(nonatomic,readwrite) BOOL destructible;
@property(nonatomic,assign) CCParticleSystem * destructionParticle; 
@property(nonatomic,assign) CDXAudioNode * destructionSound;
@property(nonatomic,assign) ccColor3B contactColor; //the color of the particle that appears when object is hit by a bullet.
@property(nonatomic,readwrite) BOOL explosive;
@property(nonatomic,readwrite) float explosionForce;
@property(nonatomic,readwrite) float explosionRange;
@property(nonatomic,readwrite) CGSize dimensions;
@property(nonatomic,readwrite) BOOL takesDamageFromCollisions;
@property(nonatomic,readwrite) BOOL isSwitch;
@property(nonatomic,readwrite) SwitchEvent switchEvent;
@property(nonatomic,retain) NSMutableArray *switchSubscribers;
@property(nonatomic,readwrite) BOOL showParticlesForContacts;
@property(nonatomic,readwrite) BOOL takesDamageFromBullets;
@property(nonatomic,readwrite) BOOL proceduralDestruction;
@property(nonatomic,assign) NSString * pdParticle;
@property(nonatomic,assign) NSString * pdSoundEffect;
@property(nonatomic,readwrite) float pdRate;

-(void)takeDamage:(float)damage rotation:(float)rot atPosition:(CGPoint)pos;
-(void)takeDamageFromBullet:(Bullet*)bullet;
- (void)performSwitchEvent:(SwitchEvent)event;
-(BaseLevelObject*)copy;
-(void)explode;
@end
