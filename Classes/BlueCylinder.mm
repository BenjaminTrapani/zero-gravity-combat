//
//  BlueCylinder.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BlueCylinder.h"


@implementation BlueCylinder
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)size{
    if ((self = [super init])) {
        pos = [Helper relativePointFromPoint:pos];
        CGSize untransformedSize = CGSizeMake(size.width, size.height);
        _dims = untransformedSize;
        size = [Helper relativeSizeFromSize:size];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angularDamping = 0.9f;
        bodyDef.linearDamping = 0.9f;
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        
        
        NSString *spriteFrameName = @"AlienCylinder.png";
        
        //b2PolygonShape shape;
        b2PolygonShape shape;
        
        shape.SetAsBox(size.width / PTM_RATIO, size.height / PTM_RATIO);
        b2FixtureDef fixtureDef;
        
        fixtureDef.shape = &shape; //cshape
        fixtureDef.density = 5.0f;
        fixtureDef.friction = 0.2f;
        fixtureDef.restitution = 0.5f;
        CGRect sizeRect = CGRectMake(0, 0, size.width, size.height);
        
        super.health = (untransformedSize.width * untransformedSize.height)/10;
        super.destructible = YES;
        super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"standardBlockDeath.plist"]; 
        super.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        super.contactColor = ccc3(0, 0, 250);
        super.explosive = YES;
        super.explosionForce = 2;
        super.explosionRange = 150;
        
        super.dimensions = size;
        
        [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeCGPoint:[Helper toPixels:body->GetWorldCenter()] forKey:@"pos"];
    [aCoder encodeFloat:CC_RADIANS_TO_DEGREES(body->GetAngle()) forKey:@"rot"];
    [aCoder encodeCGSize:_dims forKey:@"dims"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[aDecoder decodeCGPointForKey:@"pos"]  Rotation:[aDecoder decodeFloatForKey:@"rot"] Size:[aDecoder decodeCGSizeForKey:@"dims"]];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)blueCylinderWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)size{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Size:size]autorelease];
}
@end
