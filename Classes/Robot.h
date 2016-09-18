//
//  Robot.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAI.h"

@interface Robot : BaseAI <NSCoding>{
	CGPoint _pos;
    int _ID;
}
+(id)robotWithWorld:(b2World*)world Position:(CGPoint)pos identifier:(int)idtt;
@end
