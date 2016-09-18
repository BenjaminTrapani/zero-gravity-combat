//
//  Exit.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"

@interface Exit : BodyNode <NSCoding>{
    float upperX,lowerX,upperY,lowerY;
    CGPoint _pos;
    CGSize blockSize;
}
+(id)exitWithWorld:(b2World*)world Position:(CGPoint)pos;
@end
