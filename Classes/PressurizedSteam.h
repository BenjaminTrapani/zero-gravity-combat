//
//  PressurizedSteam.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface PressurizedSteam : BaseLevelObject <NSCoding> {
    CGSize _dims;
}
+(id)pressurizedSteamWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize; //make output steam a factor of original size
@end
