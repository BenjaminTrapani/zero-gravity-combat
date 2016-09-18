//
//  RotatingWheel.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RotatingWheel.h"
#import "Options.h"
#import "CDXAudioNode.h"
#import "Soldier.h"
@implementation RotatingWheel
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius enabled:(BOOL)enabled Velocity:(float)velocity{
    if ((self = [super init])) {
        _enabled = enabled;
        _velocity = velocity;
        _radius = radius;
        
        float relRadius = [[Options sharedOptions]makeAverageConstantRelative:radius];
        
        b2BodyDef rotatorWheelDef;
        rotatorWheelDef.type = b2_kinematicBody;
        rotatorWheelDef.position = [Helper toMeters:pos];
        rotatorWheelDef.angularDamping = 0.0f;
        rotatorWheelDef.linearDamping = 0.0f;
        //rotatorWheelDef.active = false;
        NSString * wheelName = @"ElectricDoorRotatorSmall.png";
        
        b2CircleShape wheelShape;
        wheelShape.m_radius = relRadius/PTM_RATIO;
        
        b2FixtureDef wheelFixDef;
        wheelFixDef.shape = &wheelShape;
        wheelFixDef.density = 1.0f;
        wheelFixDef.friction = 5.0f;
        wheelFixDef.restitution = 0.3f;
        CGRect wheelRect = CGRectMake(0, 0, relRadius, relRadius);
        super.destructible = NO;
        super.contactColor = ccc3(70, 70, 70);
        super.explosive = NO;
        super.dimensions = wheelRect.size;
                
        [super createBodyInWorld:world bodyDef:&rotatorWheelDef fixtureDef:&wheelFixDef spriteFrameName:wheelName rect:wheelRect];
        motorSound = [CDXAudioNode audioNodeWithFile:@"Electric Motor.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        motorSound.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        motorSound.playMode = kAudioNodeLoop;
        [self addChild:motorSound]; 
        //[super.sprite addChild:motorSound];
        
        //super.sprite.visible = NO;
        [self schedule:@selector(updateWheel:)];
    }
    return self;
}
-(void)updateWheel:(ccTime)delta{
    motorSound.position = sprite.position;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeCGPoint:[Helper toPixels:super.body->GetWorldCenter()] forKey:@"pval"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    [aCoder encodeFloat:_radius forKey:@"_radius"];
    [aCoder encodeBool:_enabled forKey:@"_enabled"];
    [aCoder encodeFloat:_velocity forKey:@"_velocity"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    CGPoint pval = [aDecoder decodeCGPointForKey:@"pval"];
    pval = [Helper relativePointFromPoint:pval];
    float curRadius = [aDecoder decodeFloatForKey:@"_radius"];
    BOOL enabled = [aDecoder decodeBoolForKey:@"enabled"];
    float velocity = [aDecoder decodeFloatForKey:@"_velocity"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:pval Radius:curRadius enabled:enabled Velocity:velocity];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
    
}

+(id)rotatingWheelWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius enabled:(BOOL)enabled Velocity:(float)velocity{
    return [[[self alloc]initWithWorld:world Position:pos Radius:radius enabled:enabled Velocity:velocity]autorelease];
}
-(void)startRotating{
    [motorSound play];
    super.body->SetAngularVelocity(_velocity);
}
-(void)stopRotating{
    [motorSound stop];
    super.body->SetAngularVelocity(0.0f);
}
-(void)performSwitchEvent:(SwitchEvent)event{
    if (event==switchEventActivateMotor) {
        [self startRotating];
        [self removeAllDestructionListeners];
    }
}
@end
