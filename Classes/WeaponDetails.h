//
//  WeaponDetails.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Weapon;
@class GPBar;
@interface WeaponDetails : CCNode {
	CCLabelTTF * accuracyLabel;
	CCLabelTTF * damageLabel;
	CCLabelTTF * rateOfFireLabel;
	CCLabelTTF * recoilLabel;
	CCLabelTTF * reloadTimeLabel;
	CCLabelTTF * nameLabel;
	GPBar * accuracy;
	GPBar * damage;
	GPBar * rateOfFire;
	GPBar * recoil;
	//GPBar * reloadTime;
}
-(void)updateDataWithWeapon:(Weapon*)weapon;
+(id)details;
@end
