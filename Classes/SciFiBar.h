//
//  SciFiBar.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface SciFiBar : BaseLevelObject <NSCoding>{
    CGPoint _pos;
    float _rotation;
    CGSize _dimensions;
}
+(id)sciFiBarWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)dimensions;
@end
