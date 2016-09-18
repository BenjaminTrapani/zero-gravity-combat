//
//  IronBar.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface IronBar : BaseLevelObject <NSCoding>{
    CGPoint _pos;
    float _length;
    float _width;
    float32 _rotation;
}
+(id)ironBarWithWorld:(b2World*)world Position:(CGPoint)pos Length:(float)length Width:(float)width Rotation:(float32) rotation;
@end
