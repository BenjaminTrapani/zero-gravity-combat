//
//  SciFiBar.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SciFiBar.h"


@implementation SciFiBar
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)cdimensions{
    if ((self = [super init])) {
        _pos = pos;
        _rotation = rotation;
        _dimensions = cdimensions;
        
        b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.2f;
		bodyDef.linearDamping = 0.2f;
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        //bodyDef.allowSleep = false;
		NSString * spriteFrameName = @"slidingDoor.png";
        
        cdimensions = [Helper relativeSizeFromSize:cdimensions];
		//CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
        //b2PolygonShape shape;
		b2PolygonShape shape;
		
		shape.SetAsBox(cdimensions.width / PTM_RATIO, cdimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
        
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 5.0f;
		fixtureDef.restitution = 0.5f;
		CGRect sizeRect = CGRectMake(0, 0, cdimensions.width, cdimensions.height);
        
        super.destructible = NO;
        super.contactColor = ccc3(250, 250, 0);
        super.explosive = NO;
        super.dimensions = cdimensions;
        
        [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval1 = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    [aCoder encodeObject:pval1 forKey:@"pval1"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    [aCoder encodeFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle()) forKey:@"_rotation"];
    [aCoder encodeCGSize:_dimensions forKey:@"_dimensions"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pval1 = [aDecoder decodeObjectForKey:@"pval1"];
    float curRotation = [aDecoder decodeFloatForKey:@"_rotation"];
    CGSize curDims = [aDecoder decodeCGSizeForKey:@"_dimensions"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval1 CGPointValue] Rotation:curRotation Dimensions:curDims];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
    
}

+(id)sciFiBarWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)dimensions{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Dimensions:dimensions]autorelease];
}
@end
