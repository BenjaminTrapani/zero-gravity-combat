//
//  ElectricEnd.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElectricEnd.h"
#import "Options.h"

@implementation ElectricEnd
@synthesize enabled;
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius Range:(float)range Enabled:(BOOL)curEnabled FileName:(NSString*)fileName{
	if ((self = [super init])) {
		pos = [Helper relativePointFromPoint:pos];
        float _unrelRadius = radius;
		radius = [[Options sharedOptions]makeAverageConstantRelative:radius];
		_range = [[Options sharedOptions]makeAverageConstantRelative:range];
		enabled = curEnabled;
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.1f;
		bodyDef.linearDamping = 0.1f;
		
		
		NSString * spriteFrameName = fileName;
		
		//b2PolygonShape shape;
		b2CircleShape shape;
		
		shape.m_radius = radius/PTM_RATIO;
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 2.0f;
		fixtureDef.friction = 0.1f;
		fixtureDef.restitution = 0.5f;
		
		
		super.health = _unrelRadius*_unrelRadius/2;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ElectricEndDestructionParticle.plist"]; 
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(0, 100, 0);
		super.dimensions = CGSizeMake(radius*2, radius*2); 
		CGRect sizeRect = CGRectMake(0, 0, radius, radius);
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 
		
	}
	return self;
}
+(id)electricEndWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius Range:(float)range Enabled:(BOOL)curEnabled FileName:(NSString*)fileName{
	return [[[self alloc]initWithWorld:world Position:pos Radius:radius Range:range Enabled:curEnabled FileName:fileName]autorelease];
}
@end
