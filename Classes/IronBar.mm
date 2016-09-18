//
//  IronBar.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IronBar.h"
#import "Options.h"

@implementation IronBar
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Length:(float)length Width:(float)width Rotation:(float32)rotation
{
	if ((self = [super init])) {
        _pos = pos;
        _length = length;
        _width = width;
        _rotation = rotation;
        
		pos = [Helper relativePointFromPoint:pos];
        float __length = length;
        float __width = width;
        
        if ([Options sharedOptions].isIpad) {
            length *=2.0f;//[[Options sharedOptions]makeXConstantRelative:length];
            width *=2.0f;//[/[Options sharedOptions]makeYConstantRelative:width];
        }
		
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        
        NSString * spriteFrameName = @"ironBar.png";
		//bodyDef.angularDamping = 0.1f;
		//bodyDef.linearDamping = 0.1f;
		
		b2PolygonShape shape;
		
		shape.SetAsBox(length/PTM_RATIO, width/PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		//fixtureDef.density = 2.0f;
		//fixtureDef.friction = 0.1f;
		//fixtureDef.restitution = 0.5f;
		
		
		super.health = __length * __width;
		super.destructible = NO;
		super.contactColor = ccc3(50, 50, 50);
		super.dimensions = CGSizeMake(length, width); 
		CGRect sizeRect = CGRectMake(0, 0, length, width);
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 
		
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue *pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * width = [NSNumber numberWithFloat:_width];
    NSNumber * length = [NSNumber numberWithFloat:_length];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:width forKey:@"width"];
    [aCoder encodeObject:length forKey:@"length"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pval = [aDecoder decodeObjectForKey:@"pval"];
    NSNumber * width = [aDecoder decodeObjectForKey:@"width"];
    NSNumber * length = [aDecoder decodeObjectForKey:@"length"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue] Length:length.floatValue Width:width.floatValue Rotation:rotation.floatValue];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    
    /*[pval release];
    [width release];
    [length release];
    [rotation release];*/
    
    return self;
}
+(id)ironBarWithWorld:(b2World*)world Position:(CGPoint)pos Length:(float)length Width:(float)width Rotation:(float32) rotation{
    return [[[self alloc]initWithWorld:world Position:pos Length:length Width:width Rotation:rotation]autorelease];
}
@end
