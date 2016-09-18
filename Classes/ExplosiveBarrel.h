//
//  ExplosiveBarrel.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface ExplosiveBarrel : BaseLevelObject <NSCoding> {
    CGPoint _pos;
    float _rotation;
}
+(id)explosiveBarrelWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation;
-(BaseLevelObject*)copy;
@end
