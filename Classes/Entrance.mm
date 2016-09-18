//
//  Entrance.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Entrance.h"
#import "HelloWorldLayer.h"
#import "GameController.h"
#import "Options.h"
#import "CDXAudioNode.h"
#import "EventBus.h"
#import "Glass.h"
#import "Soldier.h"
@implementation Entrance
-(id)initWithWorld:(b2World*)world position:(CGPoint)pos{
	if ((self = [super init])) {
        NSAssert(world!=NULL,@"world equals null in entrance init");
        CCLOG(@"entrance init position = %f, %f",pos.x,pos.y);
        CCLOG(@"world body count = %i",world->GetBodyCount());
        _pos = pos;
		CGSize blockDimensions = CGSizeMake(30, 5);
		blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
		pos = [Helper relativePointFromPoint:pos];
		
		
		
		audioNode = [CDXAudioNode audioNodeWithFile:@"entranceSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		//audioNode.position = pos;
		[self addChild:audioNode];
		
		
		CCParticleSystem * entranceParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"entranceParticle.plist"];
		entranceParticle.position = pos;
		entranceParticle.autoRemoveOnFinish = YES;
		[self addChild:entranceParticle];
		
		CGPoint bottomPos = ccp(pos.x, pos.y -[[Options sharedOptions] makeYConstantRelative:50]);
		CGPoint upperPos = ccp(pos.x, pos.y + [[Options sharedOptions] makeYConstantRelative:50]);
		
		Glass*leftGlass = [Glass glassWithWorld:world Position:ccp(_pos.x-blockDimensions.width/2-4,_pos.y) Dimensions:CGSizeMake(2, 40) Rotation:0];
		Glass*rightGlass = [Glass glassWithWorld:world Position:ccp(_pos.x+blockDimensions.width/2+4,_pos.y) Dimensions:CGSizeMake(2, 40) Rotation:0];
		[self addChild:leftGlass];
		[self addChild:rightGlass];
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:upperPos]);
		//bodyDef.angularDamping = 0.9f;
		//bodyDef.linearDamping = 0.9f;
		
		NSString * spriteFrameName = @"entranceBlock.png";
		
		b2PolygonShape shape;
		shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect creationRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
		
		
				
		BaseLevelObject * upperBar = [[BaseLevelObject alloc] init];
		BaseLevelObject * lowerBar = [[BaseLevelObject alloc] init];
		upperBar.destructible = NO;
		lowerBar.destructible = NO;
		upperBar.contactColor = ccc3(0, 100, 0);
		lowerBar.contactColor = ccc3(0, 100, 0);
		[upperBar createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];
		bodyDef.position = [Helper toMeters:bottomPos];
		[lowerBar createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];
		[self addChild:upperBar];
		[self addChild:lowerBar];
		[upperBar release];
		[lowerBar release];
        
        [audioNode play];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pointVal = [NSValue valueWithCGPoint:_pos];
    [aCoder encodeObject:pointVal forKey:@"pointVal"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pointVal = [aDecoder decodeObjectForKey:@"pointVal"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pointVal CGPointValue]];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)entranceWithWorld:(b2World*)world position:(CGPoint)pos{
	return [[[self alloc]initWithWorld:world position:pos]autorelease];
}
@end
