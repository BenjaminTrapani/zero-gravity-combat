//
//  Forcefield.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Forcefield.h"
#import "Options.h"

@implementation Forcefield
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Length:(float)length{
    if ((self = [super init])) {
        _pos = pos;
        _length = length;
        _rotation = rotation;
        pos = [Helper relativePointFromPoint:pos];
        float __length = length;
        float width = [[Options sharedOptions]makeYConstantRelative:3];
		length = [[Options sharedOptions]makeXConstantRelative:length];
		//width = [[Options sharedOptions]makeYConstantRelative:width];
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        
        NSString * spriteFrameName = @"Forcefield.png";
		//bodyDef.angularDamping = 0.1f;
		//bodyDef.linearDamping = 0.1f;
		
		b2PolygonShape shape;
		
		shape.SetAsBox(length/PTM_RATIO, width/PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		//fixtureDef.density = 2.0f;
		//fixtureDef.friction = 0.1f;
		fixtureDef.restitution = 1.2f;
		
		
		super.health = __length * 3;
		super.destructible = YES;
        super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"forcefieldGone.plist"];
        super.destructionSound = [CDXAudioNode audioNodeWithFile:@"forcefieldDown.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(0, 250, 0);
		super.dimensions = CGSizeMake(length, width); 
        super.showParticlesForContacts = YES;
        super.takesDamageFromBullets = NO;
		CGRect sizeRect = CGRectMake(0, 0, length, width);
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue *pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    NSNumber * length = [NSNumber numberWithFloat:_length];
    [aCoder encodeObject:pval forKey:@"pval"];
     [aCoder encodeObject:rotation forKey:@"rotation"];
     [aCoder encodeObject:length forKey:@"length"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pval = [aDecoder decodeObjectForKey:@"pval"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    NSNumber * length = [aDecoder decodeObjectForKey:@"length"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue] Rotation:rotation.floatValue Length:length.floatValue];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;

}
-(void)performSwitchEvent:(SwitchEvent)event{
    if (event == switchEventDestroy) {
        super.health = -1;
    }
    //CCLOG(@"forcefield performSwitchEvent called");
}
+(id)forcefieldWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Length:(float)length{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Length:length]autorelease];
}
@end
