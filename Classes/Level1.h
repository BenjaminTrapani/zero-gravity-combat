//
//  Level1.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "BodyNode.h"
#import "BaseLevelObject.h"

@interface Level1 : CCNode {
    
}
+(id)levelWithWorld:(b2World*)world identifier:(int)idtt;
-(void)createObject:(BaseLevelObject*)obj InRows:(int)rows columns:(int)columns;
-(void)createObject:(BaseLevelObject*)obj InRows:(int)rows columns:(int)columns xPadding:(float)xPad yPadding:(float)yPad;
-(void)createPlayerInWorld:(b2World*)world Pos:(CGPoint)startPos;
-(BOOL)saveLevel;

@end
