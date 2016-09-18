//
//  SandBag.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BodyNode.h"
#import "BaseLevelObject.h"
@interface SandBag :BodyNode <NSCoding> {
    int initType;
    CGPoint _pos;
    int _bags;
    int _curRadius;
    float _variance;
    int _rows;
    int _columns;
    BodyNode *_bodyToAttach;
    CGPoint _pointToAttach;
}
+(id)sandbagWithWorld:(b2World*)world position:(CGPoint)blockposition numberOfBags:(NSUInteger)bags radius:(NSUInteger)curRadius sizeVariance:(NSUInteger)variance;
+(id)sandbagWithWorld:(b2World *)world position:(CGPoint)blockposition rows:(int)rows columns:(int)columns sizeVariance:(float)variance body:(BodyNode*)bodyToAttach point:(CGPoint)pointToAttach;
@end
