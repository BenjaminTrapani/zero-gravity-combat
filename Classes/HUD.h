//
//  HUD.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//this entire object leaks. They all get dealloced when the program exits. Fix this.
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "BodyNode.h"
@class GunInfo;
@class Weapon;
@interface HUD : CCNode <CCTargetedTouchDelegate> {
	SneakyJoystick * joystick;
	SneakyJoystickSkinnedBase * skinStick;
	SneakyJoystick * firingStick;
	SneakyJoystickSkinnedBase * skinFiringStick;
	GunInfo * myGI;
	GunInfo * pickupGI;
	CGPoint location;
	CGRect giRect;
	CGRect eiRect;
	CGSize screenSize;
	CCSprite * tint;
	CCSprite * tint2;
	BOOL hasCreatedPickup;
	int closeCount;
	CCLayerColor * injured;
	
}
+(id)hud;
-(void)addJoystick;
-(void)addFiringStick;
-(void)onSoldierCreated;
-(void)gunCloseForPickup:(Weapon*)weapon;
-(void)addRotateArrows;
-(void)onTouchEnded;
-(void)doReloadTimer;

@property (nonatomic, assign) SneakyJoystick * joystick;
@property (nonatomic, assign) SneakyJoystickSkinnedBase * skinStick;
@property (nonatomic, assign) SneakyJoystick * firingStick;
@property (nonatomic, assign) GunInfo * myGI;
@property (nonatomic, assign) CCLayerColor * injured;
@end
