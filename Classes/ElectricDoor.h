//
//  ElectricDoor.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"
@class SciFiBar;
@class RotatingWheel;
@class IronBar;
@class DoorSwitch;
@interface ElectricDoor : BaseLevelObject <NSCoding>{
    RotatingWheel* leftWheel1;
    RotatingWheel* leftWheel2;
    RotatingWheel* rightWheel1;
    RotatingWheel* rightWheel2; 
    IronBar * leftBar;
    IronBar * rightBar;
    CGPoint _pos1;
    CGPoint _pos2;
    CGPoint _sPos;
    float _radius;
    float _width;
    DoorSwitch * curSwitch;
    BOOL leftSideStopped;
    BOOL rightSideStopped;
}
+(id)electricDoorWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius Width:(float)width switchPos:(CGPoint)sPos;
@end
