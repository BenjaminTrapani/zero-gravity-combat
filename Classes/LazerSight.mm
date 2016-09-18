//
//  LazerSight.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LazerSight.h"
#import "RaysCastCallback.h"
#import "Options.h"

@implementation LazerSight
-(id)initWithWeapon:(Weapon*)curWeapon{
	if ((self = [super init])) {
		ignoreIndexForCallback = curWeapon.body->GetFixtureList()->GetFilterData().groupIndex;
		self.scale = 2.5;
		
		redDot = [CCSprite spriteWithSpriteFrameName:@"redDot.png"];
		redDot.visible = NO;
		[self addChild:redDot];
		CGSize weaponSize = curWeapon.sprite.contentSize;
		weaponSize.width/=2.5;
		weaponSize.height/=2.5;
		startDraw = ccp(weaponSize.width,weaponSize.height/2);
		loopsSinceLastShow = 0;
		[self schedule:@selector(updateLazer:)];
	}
	return self;
}
-(void)updateLazer:(ccTime)delta{
	float interval = 60*delta;
	loopsSinceLastShow += interval;
	if (loopsSinceLastShow>3 && redDot.visible == YES) {
		//lazerSprite.visible = NO;
		redDot.visible = NO;
		//CCLOG(@"lazerSpriteHid");
	}
}
-(void)showLazerSight{
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	loopsSinceLastShow = 0;
	
	CGPoint parentPos = [self parent].position;
	
	redDot.position = ccp(screenSize.width*1.3,0);
	CGPoint redDotWorldPos = [self convertToWorldSpace:redDot.position];
	
	RaysCastCallback callback;
	callback.ignoreIndex = ignoreIndexForCallback;
	[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, [Helper toMeters:parentPos], [Helper toMeters:redDotWorldPos] );
	if (callback.m_fixture) {
		redDot.position = [self convertToNodeSpace:[Helper toPixels:callback.m_point]];//this needs to be relative
	}
	redDot.visible = YES;
}
-(void)draw{
	if (redDot.visible==YES) {
		glColor4f(1.0, 0.0, 0.0, 0.3);
		glLineWidth(1.5f);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		ccDrawLine(startDraw, redDot.position);
	}
	
}
+(id)lazerSightWithWeapon:(Weapon*)curWeapon{
	return [[[self alloc]initWithWeapon:curWeapon]autorelease];
}
@end
