//
//  ParticleListener.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface ParticleListener : CCNode {
	CCParticleSystem * propulsionFlames;
}
@property (nonatomic, assign) CCParticleSystem * propulsionFlames;
-(void)onBulletHit:(id)bullet position:(CGPoint)pos;

@end
