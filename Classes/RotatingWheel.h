//
//  RotatingWheel.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"
@class CDXAudioNode;
@interface RotatingWheel : BaseLevelObject <NSCoding>{
    BOOL _enabled;
    float _velocity;
    float _radius;
    CDXAudioNode * motorSound;
}
+(id)rotatingWheelWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius enabled:(BOOL)enabled Velocity:(float)velocity;
-(void)startRotating;
-(void)stopRotating;
-(void)performSwitchEvent:(SwitchEvent)event;
@end
