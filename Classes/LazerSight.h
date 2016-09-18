//
//  LazerSight.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"

@interface LazerSight : CCNode {
	CCSprite * redDot;
	float loopsSinceLastShow;
	int ignoreIndexForCallback;
	CGPoint startDraw;
}
+(id)lazerSightWithWeapon:(Weapon*)curWeapon;
-(void)showLazerSight;
@end
