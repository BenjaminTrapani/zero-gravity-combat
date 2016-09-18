//
//  BaseAI.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyNode.h"
#import "AStar.h"
#define kSpeedFactor 30 //higher speed factor means faster overall movement speed
#define kSensitivityFactor 5000 //higher sensetivity = stupider
#define kSightFactor 70 //higher means lower
#define kHearingFactor 30 //not used currently
//#define usingEditor 1

@class Soldier;
@class JetPack;
@class Weapon;
@class Bullet;
@class CDXAudioNode;
@class PathfindingPoint;

@class ShortestPathStep;
@interface BaseAI : BodyNode <AStarDelegate>{
	float movementSpeed; //all values between 1 and 5. 5 is the best, 1 is the worst
	float reactionSpeed; //higher reaction speed means smarter
	float hearingRange;
	float sightRange;
	float patrolRadius; //this is in pixels
	float health;
	float headHealth;
	float aiState; //0-1 = patroling    1-2 = waiting/suspicious    2+ = engaged
	int lowerX;
	int upperX;
	int lowerY;
	int upperY;
	Soldier * localSoldier;
	CGSize screenSize;
	CGSize selfSize;
	CGPoint nextDest;
	JetPack * jetPack;
	Weapon * weapon;
	BOOL hasClearShot;
	NSString * blood;
	NSString * deathExplosion;
	NSString * headPoppedOffParticle;
	float longestBodyLength;
	NSString * deathSound;
	CDXAudioNode * deathSFX;
	BOOL dead;
	BOOL headAttached;
	BodyNode * headBodyNode;
	float bleedOutRate;
	NSMutableArray * path;
	BOOL pathExists;
	BOOL performedCreatePath;
	BOOL pathDone;
	AStar * pathFinder;
	BOOL hasDealloced;
	ccColor3B bloodColor;
	int killReward;
	int headshotReward;
    BOOL isUsingEditor;
    int globalIdtt;
    float _100minusReactionSpeed;
    BOOL doubleSpeed;
}
-(void)patrol;
-(void)beSuspicious;
-(void)engage;
-(void)lookForSoldier;
-(void)headPoppedOff;
-(void)bleedOut;
+(id)aiWithPos:(CGPoint)pos world:(b2World*)world bodyDef:(b2BodyDef*)def fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)name head:(NSString*)head;
-(void)rotateGunToAngle:(float)angle;

-(void)onAIHit:(CGPoint)pos Damage:(float)damage;
-(void)onAIHit:(CGPoint)pos bullet:(Bullet*)curBullet;

-(void)onHeadShot:(CGPoint)pos Damage:(float)damage;
-(void)onHeadShot:(CGPoint)pos bullet:(Bullet*)curBullet;

-(PathfindingPoint*)findBestOfEightWithPoint:(PathfindingPoint*)point;
-(void)createPathFindingPointWithCGPoint:(CGPoint)cast1 array:(NSMutableArray*)eightList parentPoint:(PathfindingPoint*)parentPoint;
-(void)chasePlayer;
-(void)createPath;
-(BOOL)isWall:(CGPoint)point parent:(ShortestPathStep*)curParent;
-(BOOL)checkBounds:(CGPoint)point;
- (void) onPathNotFound;
-(void)onPathDone:(NSMutableArray*)tempPath;
-(id)initWithPos:(CGPoint)pos world:(b2World*)world bodyDef:(b2BodyDef*)def fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)name head:(NSString*)head;
@property(nonatomic,readwrite)float movementSpeed;
@property(nonatomic,readwrite)float reactionSpeed; 
@property(nonatomic,readwrite)float hearingRange;
@property(nonatomic,readwrite)float sightRange;
@property(nonatomic,readwrite)float patrolRadius;
@property(nonatomic,readwrite)float health;
@property(nonatomic,readwrite)float headHealth;
@property(nonatomic,assign)JetPack * jetPack;
@property(nonatomic,assign)Weapon * weapon;
@property(nonatomic,assign)NSString * blood;
@property(nonatomic,assign)ccColor3B bloodColor;
@property(nonatomic,assign)NSString * deathExplosion;
@property(nonatomic,assign)NSString * deathSound;
@property(nonatomic,assign)NSString * headPoppedOffParticle;
@property(nonatomic,readwrite)BodyType curBodyType;
@property(nonatomic,readwrite)float bleedOutRate;
@property(nonatomic,readwrite)int killReward;
@property(nonatomic,readwrite)int headshotReward;

@end
