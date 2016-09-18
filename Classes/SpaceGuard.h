//
//  SpaceGuard.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAI.h"
@class BodyPart;
@interface SpaceGuard : BaseAI <NSCoding>{
    //make this ai a biped with destructible joints and a lot of blood and gore
    CGPoint _pos;
    int _ID;
    float damageIncrement;
}
+(id)spaceGuardWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt;
-(void)onBodyPartDestroyed:(BodyPart*)aBodyPart;
-(void)spaceGuardUpdate;
@end
