//
//  DoorSwitch.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface DoorSwitch : BaseLevelObject <NSCoding> {
    CGSize _dimensions;
    CGPoint _pos;
    float _rotation;
}
+(id)doorSwitchWithWorld:(b2World*)world position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)dimensions Objects:(NSMutableArray*)objs Event:(SwitchEvent)event;
@end
