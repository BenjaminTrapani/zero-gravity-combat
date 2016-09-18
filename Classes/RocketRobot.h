//
//  RocketRobot.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "BaseAI.h"

@interface RocketRobot : BaseAI <NSCoding>{
    CGPoint _pos;
    int _ID;
}
+(id)RocketRobotWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt;
@end
