//
//  standardWall.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"
@interface standardWall :BaseLevelObject <NSCoding> {
    int initType;
    CGPoint _blockPosition;
    CGSize _blockDimensions;
    float _crotation;
}
+(id)wallWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions;
+(id)wallWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions Rotation:(float)rotation;

@end
