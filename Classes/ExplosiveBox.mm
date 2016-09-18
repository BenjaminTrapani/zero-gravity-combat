//
//  ExplosiveBox.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplosiveBox.h"


@implementation ExplosiveBox
-(id)initWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation Dimensions:(CGSize)_dimensions{
	if ((self = [super init])) {
        _pos = pos;
        _rotation = rotation;
        __dimensions = _dimensions;
        
        pos = [Helper relativePointFromPoint:pos];
        
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.9f;
		bodyDef.linearDamping = 0.9f;
		bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
		NSString * spriteFrameName = @"ExplosiveBox.png";
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		CGSize blockDimensions = CGSizeMake(tempSprite.contentSize.width, tempSprite.contentSize.height);
        //blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
        //_dimensions = [Helper relativeSizeFromSize:_dimensions];
		//if (_dimensions.width==0 && _dimensions.height ==0) {
         //   blockDimensions = CGSizeMake(tempSprite.contentSize.width, tempSprite.contentSize.height);
        //}else{
            //blockDimensions = _dimensions;
        //}
		
		
		//b2PolygonShape shape;
		b2PolygonShape shape;
		
		shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 5.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect sizeRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
		
		super.health = 8;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"]; //make particles horizontal. edit variances to match fixture size
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"BarrelExplosion.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(205, 133, 63);
		super.explosive = YES;
		super.explosionForce = 4;
		super.explosionRange = 100;
		super.dimensions = blockDimensions;
		super.takesDamageFromCollisions = YES;
        
        //make this image a little smaller. Edit electric arc. Make a body that is linked at either end to the two electric ends. High restitution. If the player hits this body, play a bounce type of sound effect and injure the player.
        
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSValue * sizeVal = [NSValue valueWithCGSize:__dimensions];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:sizeVal forKey:@"sizeVal"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval = [aDecoder decodeObjectForKey:@"pval"];
    NSValue * sizeVal = [aDecoder decodeObjectForKey:@"sizeVal"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pval CGPointValue] rotation:rotation.floatValue Dimensions:[sizeVal CGSizeValue]];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
-(BaseLevelObject*)copy{
	ExplosiveBox * instance = [ExplosiveBox explosiveBoxWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:self.sprite.position rotation:CC_RADIANS_TO_DEGREES(super.body->GetAngle()) Dimensions:super.dimensions];
	return instance;
    
}
+(id)explosiveBoxWithWorld:(b2World*)world position:(CGPoint)pos rotation:(float)rotation{
	return [[[self alloc]initWithWorld:world position:pos rotation:rotation Dimensions:CGSizeZero]autorelease];
}
+(id)explosiveBoxWithWorld:(b2World *)world position:(CGPoint)pos rotation:(float)rotation Dimensions:(CGSize)dimensions{
    return [[[self alloc]initWithWorld:world position:pos rotation:rotation Dimensions:dimensions]autorelease];
}
@end
