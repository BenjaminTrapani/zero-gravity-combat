//
//  PinkAlien.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseAI.h"
#import <Foundation/Foundation.h>
@interface PinkAlien : BaseAI <NSCoding>{
    CGPoint _pos;
    int _ID;
}
+(id)pinkAlienWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt;
@end
