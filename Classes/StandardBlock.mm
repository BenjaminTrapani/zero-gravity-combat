//
//  StandardBlock.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StandardBlock.h"


@implementation StandardBlock
-(id) initWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions Rotation:(float)crotation
{
	if ((self = [super init])) {
		[self createBlockInWorld:world position:blockposition Dimensions:blockDimensions Rotation:crotation];
	}
	return self;
}

+(id)blockWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize) blockDimensions Rotation:(float)crotation
{
	return [[[self alloc] initWithWorld:world position:blockposition Dimensions:blockDimensions Rotation:crotation]autorelease];
}
-(void) dealloc
{
	[super dealloc];
}
-(void)createBlockInWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions Rotation:(float)crotation{
	
	originalSize = blockDimensions;
	
    _blockPosition = blockposition;
    _blockDimensions = blockDimensions;
    _crotation = crotation;
	CCLOG(@"standard block rotation = %f",crotation);
	
	blockposition = [Helper relativePointFromPoint:blockposition];
	blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = ([Helper toMeters:blockposition]);
	bodyDef.angularDamping = 0.9f;
	bodyDef.linearDamping = 0.9f;
	bodyDef.angle = CC_DEGREES_TO_RADIANS(crotation);
	
	NSString * spriteFrameName = @"standardBlockImage.png";
	
	
	
	
	
	//b2PolygonShape shape;
	b2PolygonShape shape;
	
	shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
	b2FixtureDef fixtureDef;
	
	fixtureDef.shape = &shape; //cshape
	fixtureDef.density = 10.0f;
	fixtureDef.friction = 0.2f;
	fixtureDef.restitution = 0.5f;
	CGRect sizeRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
	
	super.health = originalSize.width*originalSize.height/7;
	super.destructible = YES;
	super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"standardBlockDeath.plist"]; //make particles horizontal. edit variances to match fixture size
	super.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
	super.contactColor = ccc3(0, 0, 255);
	super.dimensions = blockDimensions;
	super.usesSpriteBatch = YES;
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * sizeValue = [NSValue valueWithCGSize:_blockDimensions];
    NSValue * pointValue = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:sizeValue forKey:@"sizeValue"];
    [aCoder encodeObject:pointValue forKey:@"pointValue"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:super.uniqueID forKey:@"uniqueID"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * sizeValue = [aDecoder decodeObjectForKey:@"sizeValue"];
    NSValue * pointValue = [aDecoder decodeObjectForKey:@"pointValue"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pointValue CGPointValue] Dimensions:[sizeValue CGSizeValue] Rotation:rotation.floatValue];
   super.uniqueID = [aDecoder decodeObjectForKey:@"uniqueID"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    
    /*[sizeValue release];
    [pointValue release];
    [rotation release];*/
    
    return self;
}
-(BaseLevelObject*)copy{
	StandardBlock * instance = [StandardBlock blockWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:self.sprite.position Dimensions:originalSize Rotation:self.sprite.rotation];
	return instance;
}
@end
