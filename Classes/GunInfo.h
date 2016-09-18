//
//  GunInfo.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
#import "cocos2d.h"
@class Soldier;
@class Weapon;
@class CDXAudioNode;
@interface GunInfo : CCNode {
	Soldier * soldier;
	CCSprite * primaryWeapon;
	CCSprite * secondaryWeapon;
	CCSprite * backing;
	CCLabelBMFont * shotsInMagAndMags;
	CCLabelBMFont * gunName;
	CGPoint location;
	BOOL reloadTimerRunning;
	float gunReloadTime;
	int loopCount;
	CGSize backingSize;
	Weapon * representedWeapon;
	CDXAudioNode * swapSound;
}
@property(nonatomic, assign)Weapon * representedWeapon;
+(id)gunInfoForPropertyUpdate;
-(id)initForPropertyUpdate;
-(id)initWithWeapon:(Weapon*)weapon;
-(void)updateWithGunProperty;
-(void)doSwap;
-(void)createProgressTimer;
-(void)updateInformation;
-(void)doReloadTimerWithTime:(float)time;
-(void)setcurrentWeapon:(Weapon *)newWeapon;
-(void)refresh; //this updates everything about a gun info for the current weapon.
@end
