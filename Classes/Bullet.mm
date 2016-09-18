//
//  Bullet.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


@implementation Bullet
@synthesize damage;

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos angle:(float)initAngle groupIndex:(int)index
{
	if ((self = [super init])) {
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 1.0f;
		bodyDef.linearDamping = 0.0f;
		bodyDef.bullet = TRUE;
        bodyDef.fixedRotation = TRUE;
		float32 radianAngle = CC_DEGREES_TO_RADIANS(initAngle);
		bodyDef.angle = radianAngle;
		
		
		NSString * spriteFrameName = @"bulletImage.png";
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		CGSize bulletSize = tempSprite.contentSize;		
				
		
		b2PolygonShape shape;
		
		shape.SetAsBox(bulletSize.width / PTM_RATIO/2, bulletSize.height / PTM_RATIO/2);
		
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; 
		fixtureDef.density = 0.2f; //1.0f
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.1f;
		fixtureDef.filter.groupIndex = index; //prevents gunman from shooting themselves.
		fixtureDef.filter.categoryBits = CATEGORY_BULLET;
		fixtureDef.filter.maskBits = MASK_BULLET;
		//CCLOG(@"bodyDef angle = %f32",bodyDef.angle);
        super.usesSpriteBatch = YES;
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
		//super.body->SetBullet(true);
	}
	return self;
}
-(void)setAngle:(float)angle{
	float32 radianAngle = CC_DEGREES_TO_RADIANS(angle);
	super.body->SetTransform(b2Vec2(0,0),radianAngle);
	
}

+(id)bulletWithWorld:(b2World*)world position:(CGPoint)bulletPosition angle:(float)inputAngle groupIndex:(int)index{
	return [[[self alloc]initWithWorld:world position:bulletPosition angle:inputAngle groupIndex:index]autorelease];
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
