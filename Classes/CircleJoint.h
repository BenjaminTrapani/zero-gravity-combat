//
//  CircleJoint.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"

@interface CircleJoint : BaseLevelObject <NSCoding>{
    CGPoint _pos;
    float _radius;
    BaseLevelObject * _Obj1;
    BaseLevelObject * _Obj2;
    b2Body * _bobj1;
    b2Body *_bobj2;
}
+(id)jointWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius levelObject1:(BaseLevelObject*)Obj1 levelObject2:(BaseLevelObject*)Obj2;
@end
