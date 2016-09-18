//
//  Armory.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class WeaponDetails;
@class Weapon;
@class MyMenuItem;
@interface Armory : CCLayer {
	CCMenu * primaryMenu;
	CCMenu * secondaryMenu;
	float primaryx;
	float primaryy;
	float secondaryx;
	float secondaryy;
	float primaryMax;
	float secondaryMax;
	float padding;
	MyMenuItem* previousItem;
	MyMenuItem * secPrevItem;
	CCParticleSystem * selectedFlame;
	CCParticleSystem * secSelectedFlame;
	WeaponDetails * primaryDetails;
	WeaponDetails * secondaryDetails;
	Weapon * currentPrimary;
	Weapon * currentSecondary;
	MyMenuItem * curPrimItem;
	MyMenuItem * curSecItem;
	MyMenuItem * prevEquipPrim;
	MyMenuItem * prevEquipSec;
}
+(id)scene;
-(void)addBacking;
-(void)addGuns;
-(void)addWeaponToPrimaryMenu:(Weapon*)weapon;
-(void)addWeaponToSecondaryMenu:(Weapon*)weapon;
-(void)addProgressBars;
-(void)addButtons;
@end
