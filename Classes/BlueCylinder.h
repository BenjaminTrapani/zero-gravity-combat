//
//  BlueCylinder.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"

@interface BlueCylinder : BaseLevelObject <NSCoding>{
    CGSize _dims;
}
+(id)blueCylinderWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)size;
@end
