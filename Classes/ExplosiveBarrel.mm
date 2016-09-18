//
//  ExplosiveBarrel.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExplosiveBarrel.h"


@implementation ExplosiveBarrel
-(id)initWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation{
	if ((self = [super init])) {
        _pos = pos;
        pos = [Helper relativePointFromPoint:pos];
        _rotation = rotation;
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.9f;
		bodyDef.linearDamping = 0.9f;
		bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
		NSString * spriteFrameName = @"explosiveBarrelSmall.png";
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		CGSize blockDimensions = CGSizeMake(tempSprite.contentSize.width, tempSprite.contentSize.height);
		
		
		
		//b2PolygonShape shape;
		b2PolygonShape shape;
		
		shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 10.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect sizeRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
		
		super.health = 8;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"]; //make particles horizontal. edit variances to match fixture size
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"BarrelExplosion.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(25, 25, 25);
		super.explosive = YES;
		super.explosionForce = 8;
		super.explosionRange = 150;
		super.dimensions = blockDimensions;
		
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSNumber * rot = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    NSValue * cgPointVal = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    [aCoder encodeObject:rot forKey:@"rot"];
    [aCoder encodeObject:cgPointVal forKey:@"cgPointVal"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSNumber * rot = [aDecoder decodeObjectForKey:@"rot"];
    NSValue * cgPointVal = [aDecoder decodeObjectForKey:@"cgPointVal"];
    
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[cgPointVal CGPointValue] rotation:rot.floatValue];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
-(BaseLevelObject*)copy{
	ExplosiveBarrel * instance = [ExplosiveBarrel explosiveBarrelWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:self.sprite.position rotation:CC_RADIANS_TO_DEGREES(body->GetAngle())];
	return instance;

}
+(id)explosiveBarrelWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation{
	return [[[self alloc]initWithWorld:world position:pos rotation:rotation]autorelease];
}
@end
