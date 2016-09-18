//
//  JetPack.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDXAudioNode.h"
@interface JetPack : CCNode {
	float angle;
	CCParticleSystem * jp;
	CGPoint fakeParentPos;
	CGPoint posOffset;
	BOOL isActive;
	int inactiveCount;
	CDXAudioNode * JetPackSound;
	float soundCount;
    float interval;
}
@property (nonatomic, readwrite)float angle;
@property (nonatomic, readwrite) CGPoint fakeParentPos;
@property (nonatomic, readwrite) CGPoint posOffset;
@property (nonatomic, assign) CCParticleSystem * jp;
-(void)startEmitting;
-(void)stopEmitting;
-(void)createSound;
-(void)emit; //call this every frame to keep particle emiting.
@end
