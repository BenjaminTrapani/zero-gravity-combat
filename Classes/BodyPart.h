//
//  BodyPart.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLevelObject.h"
@interface BodyPart : BaseLevelObject {
    float maxHealth;
}
@property (nonatomic, readwrite) float spirtDirection;
@property (nonatomic, readwrite) CGPoint relativeSpirtPosition;
@property (nonatomic, readwrite) float maxHealth;
-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef
                  fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)fileName;
-(void)onLinkedBodyDestroyed:(BodyPart*)destroyedBody withPoint:(CGPoint)bloodPos;
@end
