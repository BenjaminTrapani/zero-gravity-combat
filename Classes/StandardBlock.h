//
//  StandardBlock.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"
@interface StandardBlock : BaseLevelObject<NSCoding>{
	CGSize originalSize;
    CGPoint _blockPosition;
    CGSize _blockDimensions;
    float _crotation;
}
+(id)blockWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize) blockDimensions Rotation:(float)crotation;
-(void)createBlockInWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions Rotation:(float)crotation;
-(NSMutableDictionary*)getProperties;
-(id)initWithProperties:(NSMutableDictionary*)_properties;
@end
