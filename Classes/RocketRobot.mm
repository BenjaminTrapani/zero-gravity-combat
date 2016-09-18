//
//  RocketRobot.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RocketRobot.h"
#import "Weapon.h"
#import "Options.h"
#import "JetPack.h"
@implementation RocketRobot
-(id)initWithPos:(CGPoint)pos world:(b2World*)world Identifier:(int)identifier{
    _pos = pos;
    _ID = identifier;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = ([Helper toMeters:pos]);
    bodyDef.angularDamping = 0.3f;
    bodyDef.linearDamping = 0.9f;
    
    CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"smallRocketRobot.png"];
    CGSize spriteSize = tempSprite.contentSizeInPixels;
    b2PolygonShape shape;
    spriteSize.width = spriteSize.width / 2.5f;
    spriteSize.height = spriteSize.height / 2.5f; 
    shape.SetAsBox(spriteSize.width / PTM_RATIO, spriteSize.height / PTM_RATIO);
    b2FixtureDef fixtureDef;
    
    fixtureDef.shape = &shape; //cshape
    fixtureDef.density = 2.0f;
    fixtureDef.friction = 0.2f;
    fixtureDef.restitution = 1.0f;
    fixtureDef.filter.groupIndex = identifier;
    
    
	//if ((self = [super init])) {
		
		
		super.movementSpeed = 6;
		super.reactionSpeed = 3;
		super.hearingRange = [[Options sharedOptions]makeAverageConstantRelative:350];
		super.sightRange = [[Options sharedOptions]makeAverageConstantRelative:250];
		super.patrolRadius = [[Options sharedOptions]makeAverageConstantRelative:300];
		super.health = 75;
		//super.headHealth = 20;
		super.bleedOutRate = 2;
		super.killReward = 20;
		//super.headshotReward = 5;
		super.deathSound = @"robotDeathSound.wav";
		//super.headPoppedOffParticle = @"robotHeadOff.plist";
        [super initWithPos:pos world:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"smallRocketRobot.png" head:nil];
		super.weapon = [Weapon gunWithName:@"LAV 15" ID:identifier];
        super.weapon.accuracy -= 2.0f;
        super.weapon.rateOfFire -= 2.0f; //test the effect. Trying to increase time between shots.
		super.weapon.body->SetTransform(super.body->GetWorldCenter(),0);
		b2RevoluteJointDef jd;
		jd.Initialize(super.body, super.weapon.body,super.body->GetWorldCenter());	
		world->CreateJoint(&jd);
		
		super.blood = @"robotBlood.plist";
		super.bloodColor = ccc3(100, 100, 100);
		super.deathExplosion = @"rocketRobotDeath.plist";
		
		ccColor3B particleColor = ccc3(200, 0, 0);
        ccColor3B particleEndColor = ccc3(250, 250, 0);
		super.jetPack.jp.startColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.endColor = ccc4FFromccc3B(particleEndColor);
		super.jetPack.jp.life = 0.2;
        
		//[self addChild:myRobot];
		//[self addChild:super.weapon];
		[[HelloWorldLayer sharedHelloWorldLayer] addChild:super.weapon];
	//}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:_pos];
    [aCoder encodeInt:_ID forKey:@"_ID"];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval = [aDecoder decodeObjectForKey:@"pval"];
    int idtt = [aDecoder decodeIntForKey:@"_ID"];
    [self initWithPos:[pval CGPointValue] world:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Identifier:idtt];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)RocketRobotWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt{
	return [[[self alloc]initWithPos:pos world:world Identifier:idtt]autorelease];
}
@end