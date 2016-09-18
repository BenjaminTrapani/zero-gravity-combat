//
//  HelloWorldLayer.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"
#import "CDAudioManager.h"
//#import "SneakyJoystick.h"
//#import "SneakyJoystickSkinnedBase.h"
@class Soldier;
@class ParticleListener;
@class HUD;
@class Bullets;
@class CDXAudioNode;
@class GameController;
@class Level1;
@class PropertiesView;
@class LevelView;
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	//CCLayer * hudLayer;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	//HUD * myHud; 
	ParticleListener * listener;
	Soldier * mySoldier;
	bool hasParticleReset;
	ContactListener * myContactListener;
	BOOL firstLoop;
	float relativeAngle;
	BOOL isFiringStickDead;
	CCParticleSystem * flames;
	float camMomentumX;
	float camMomentumY;
	CDSoundEngine  *soundEngine;
	BOOL gameOver;
	GameController * gameController;
	CGPoint previousPos;
	CGPoint gameStartPosition;
    CGSize screenSize;
    CCSpriteBatchNode * batch1; //sprite batch for first texture atlas;
    CCSpriteBatchNode * batch2; //sprite batch for second texture atlas;
    HUD * hud;
    Level1 * currentLevel;
    PropertiesView * propertiesView;
    LevelView * levelView;
    BOOL surrenderCameraControl;
    BOOL isUsingEditor;
    BOOL locked;
	//CDXAudioNode*audioNode;
}

@property (nonatomic, readwrite) BOOL isFiringStickDead;
@property (nonatomic, assign) CCSprite * levelBacking;
@property (nonatomic, readwrite) CGPoint gameStartPosition;
@property (nonatomic, readwrite) BOOL surrenderCameraControl;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(float)getRelativeAngle;
+(HelloWorldLayer*) sharedHelloWorldLayer;
-(void)cleanupDeletes;
-(Soldier*) getLocalSoldier;
-(NSMutableArray*) getSpriteBatches;
-(ParticleListener*)getParticleListener;
-(HUD*)getHUD;
-(b2World*)getWorld;
-(void)doLeft;
-(void)doRight;
-(CDSoundEngine*)getSoundEngine;
-(void)doGameOver;
-(GameController*)getGameController;
-(void)setGameController:(GameController*)gc;
-(void)setSoldier:(Soldier*)newSoldier;
-(CGPoint)makePointRelative:(CGPoint)point;
-(Level1*)getCurrentLevel;
-(void)setCurrentLevel:(Level1*)input;
-(PropertiesView*)getPropertiesView;
-(LevelView*)getLevelView;
@end
