//
//  ExplosiveBox.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface ExplosiveBox : BaseLevelObject <NSCoding>{
    CGPoint _pos;
    float _rotation;
    CGSize __dimensions;
}
-(BaseLevelObject*)copy;
+(id)explosiveBoxWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation;
+(id)explosiveBoxWithWorld:(b2World *)world position:(CGPoint)pos rotation:(float)rotation Dimensions:(CGSize)_dimensions;
@end
