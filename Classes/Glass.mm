//
//  Glass.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Glass.h"


@implementation Glass
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Dimensions:(CGSize)Dimensions Rotation:(float)crotation{
	if ((self = [super init])) {
		originalSize = Dimensions;
		
        _pos = pos;
        _dimensions = Dimensions;
        _crotation = crotation;
        
		pos = [Helper relativePointFromPoint:pos];
		Dimensions = [Helper relativeSizeFromSize:Dimensions];
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.1f;
		bodyDef.linearDamping = 0.1f;
		bodyDef.angle = CC_DEGREES_TO_RADIANS(crotation);
		
		NSString * spriteFrameName = @"glass.png";
		
		
		
		
		
		//b2PolygonShape shape;
		b2PolygonShape shape;
		
		shape.SetAsBox(Dimensions.width / PTM_RATIO, Dimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.3f;
		CGRect sizeRect = CGRectMake(0, 0, Dimensions.width, Dimensions.height);
		
		super.health = originalSize.width*originalSize.height/1000;
		super.destructible = YES;
		super.takesDamageFromCollisions = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"breakingGlass.plist"]; 
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"glassShatter.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(100, 100, 100);
		super.dimensions = Dimensions;
		
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
		super.sprite.opacity = 100;
	}
	
	
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSValue * sval = [NSValue valueWithCGSize:_dimensions];
    NSNumber * rot = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:sval forKey:@"sval"];
    [aCoder encodeObject:rot forKey:@"rot"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval = [aDecoder decodeObjectForKey:@"pval"];
    NSValue * sval = [aDecoder decodeObjectForKey:@"sval"];
    NSNumber * rot = [aDecoder decodeObjectForKey:@"rot"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue] Dimensions:[sval CGSizeValue] Rotation:rot.floatValue];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
-(BaseLevelObject*)copy{
	BaseLevelObject * instance = [Glass glassWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:self.sprite.position Dimensions:originalSize Rotation:self.sprite.rotation];
	return instance;
}
+(id)glassWithWorld:(b2World*)world Position:(CGPoint)pos Dimensions:(CGSize)Dimensions Rotation:(float)crotation{
	return [[[self alloc]initWithWorld:world Position:pos Dimensions:Dimensions Rotation:crotation]autorelease];
}
@end
