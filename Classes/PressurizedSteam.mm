//
//  PressurizedSteam.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PressurizedSteam.h"


@implementation PressurizedSteam
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize{
    if ((self = [super init])) {
        _dims = CGSizeMake(aSize.width, aSize.height);
        pos = [Helper relativePointFromPoint:pos];
        aSize = [Helper relativeSizeFromSize:aSize];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angularDamping = 0.9f;
        bodyDef.linearDamping = 0.9f;
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        
        
        NSString *spriteFrameName = @"steamCylinder.png"; //done
        
        //b2PolygonShape shape;
        b2PolygonShape shape;
        
        shape.SetAsBox(aSize.width / PTM_RATIO, aSize.height / PTM_RATIO);
        b2FixtureDef fixtureDef;
        
        fixtureDef.shape = &shape; //cshape
        fixtureDef.density = 2.0f;
        fixtureDef.friction = 0.2f;
        fixtureDef.restitution = 0.7f;
        CGRect sizeRect = CGRectMake(0, 0, aSize.width, aSize.height);
        super.health = (_dims.width * _dims.height)/15;
        super.destructible = YES;
        super.proceduralDestruction = YES;
        super.pdParticle = @"steam.plist";
        super.pdSoundEffect = @"steamHiss.wav";
        super.pdRate = 0.5f; //add this to baselevelobject and add update method to decrease health by the number of damage points times pdRate; 
        super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"burstOfSteam.plist"]; //done
        super.destructionSound = [CDXAudioNode audioNodeWithFile:@"SteamPop.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        super.contactColor = ccc3(100,100,100);
        super.explosive = YES;
        super.explosionForce = 1;
        super.explosionRange = 100;
        
        super.dimensions = aSize;
        
        [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 
    }
    return self;
}
+(id)pressurizedSteamWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Size:aSize]autorelease];
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

@end
