//
//  WaterPipe.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface WaterPipe : BaseLevelObject <NSCoding> {
    //CCParticleSystem * waterFlow;
    BOOL _isMirrored;
   
}
+(id)waterPipeWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Mirrored:(BOOL)mirrored;
@end
