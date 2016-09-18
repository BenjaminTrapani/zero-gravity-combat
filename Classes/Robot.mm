//
//  Robot.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Robot.h"
#import "Options.h"
#import "Weapon.h"
#import "JetPack.h"

@implementation Robot
-(id)initWithPos:(CGPoint)pos world:(b2World*)world Identifier:(int)identifier{
    _pos = pos;
    _ID = identifier;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = ([Helper toMeters:pos]);
    bodyDef.angularDamping = 0.3f;
    bodyDef.linearDamping = 0.9f;
    
    CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"smallRobot.png"];
    CGSize spriteSize = tempSprite.contentSizeInPixels;
    b2PolygonShape shape;
    spriteSize.width = spriteSize.width / 4;
    spriteSize.height = spriteSize.height / 4; 
    shape.SetAsBox(spriteSize.width / PTM_RATIO, spriteSize.height / PTM_RATIO);
    b2FixtureDef fixtureDef;
    
    fixtureDef.shape = &shape; //cshape
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.2f;
    fixtureDef.restitution = 1.0f;
    fixtureDef.filter.groupIndex = identifier;
    

	//if ((self = [super init])) {
		
		
		super.movementSpeed = 8;
		super.reactionSpeed = 20;
		super.hearingRange = [[Options sharedOptions]makeAverageConstantRelative:350];
		super.sightRange = [[Options sharedOptions]makeAverageConstantRelative:200];
		super.patrolRadius = [[Options sharedOptions]makeAverageConstantRelative:150];
		super.health = 45;
		super.headHealth = 5;
		super.bleedOutRate = 0.75;
		super.killReward = 10;
		super.headshotReward = 5;
		super.deathSound = @"robotDeathSound.wav";
		super.headPoppedOffParticle = @"robotHeadOff.plist";
        [super initWithPos:pos world:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"smallRobot.png" head:@"robotHead.png"];
		super.weapon = [Weapon randomPrimaryWithId:identifier]; //[Weapon gunWithName:@"L96A1" ID:identifier];
		super.weapon.body->SetTransform(super.body->GetWorldCenter(),0);
		b2RevoluteJointDef jd;
		jd.Initialize(super.body, super.weapon.body,super.body->GetWorldCenter());	
		world->CreateJoint(&jd);
		
		super.blood = @"robotBlood.plist";
		super.bloodColor = ccc3(200, 200, 0);
		super.deathExplosion = @"robotDeathParticle.plist";
		
		ccColor3B particleColor = ccc3(200, 200, 0);
		super.jetPack.jp.startColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.endColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.life = 0.2;
        
		//[self addChild:myRobot];
		//[self addChild:super.weapon];
		[[HelloWorldLayer sharedHelloWorldLayer] addChild:super.weapon];
        super.weapon.recoil/=5.0f;
	//}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * cgp = [NSValue valueWithCGPoint:_pos];
    NSNumber * num = [NSNumber numberWithInt:_ID];
    [aCoder encodeObject:cgp forKey:@"pointValue"];
    [aCoder encodeObject:num forKey:@"identifier"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pointValue = [aDecoder decodeObjectForKey:@"pointValue"];
    CGPoint point = [pointValue CGPointValue];
    NSNumber * num = [aDecoder decodeObjectForKey:@"identifier"];
    int idtt = num.intValue;
    
    [self initWithPos:point world:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Identifier:idtt];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}

+(id)robotWithWorld:(b2World*)world Position:(CGPoint)pos identifier:(int)idtt;{
	return [[[self alloc]initWithPos:pos world:world Identifier:idtt]autorelease];
}
@end
