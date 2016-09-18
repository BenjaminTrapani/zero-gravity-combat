//
//  GroundBlock.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "BaseLevelObject.h"

@interface GroundBlock : BaseLevelObject <NSCoding>{
    CGSize _aSize;
}
+(id)groundBlockWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize;
@end
