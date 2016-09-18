//
//  Forcefield.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "BaseLevelObject.h"

@interface Forcefield : BaseLevelObject <NSCoding>{
    CGPoint _pos;
    float _rotation;
    float _length;
}
+(id)forcefieldWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Length:(float)length;
-(void)performSwitchEvent:(SwitchEvent)event;
@end
