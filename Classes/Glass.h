//
//  Glass.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseLevelObject.h"
@interface Glass : BaseLevelObject <NSCoding>{
	CGSize originalSize;
    CGPoint _pos;
    CGSize _dimensions;
    float _crotation;
}
+(id)glassWithWorld:(b2World*)world Position:(CGPoint)pos Dimensions:(CGSize)Dimensions Rotation:(float)crotation;
@end
