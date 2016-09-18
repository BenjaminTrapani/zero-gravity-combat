//
//  Bullet.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
@interface Bullet : BodyNode {
	float damage;
}
@property (nonatomic, readwrite)float damage;
+(id)bulletWithWorld:(b2World*)world position:(CGPoint)bulletPosition angle:(float)inputAngle groupIndex:(int)index;
-(void)setAngle:(float)angle;
@end
