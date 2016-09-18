//
//  Entrance.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseLevelObject.h"
#import "Helper.h"
@class CDXAudioNode;
@interface Entrance : BodyNode {
	CDXAudioNode * audioNode;
    CGPoint _pos;
}
+(id)entranceWithWorld:(b2World*)world position:(CGPoint)pos;
@end
