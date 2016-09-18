//
//  PinkAlien.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PinkAlien.h"
#import "Options.h"
#import "Weapon.h"
#import "JetPack.h"
@implementation PinkAlien
-(id)initWithPos:(CGPoint)pos world:(b2World*)world Identifier:(int)identifier{
    _pos = pos; //scale the sprite so it is smaller. Use cgsize and makerelative
    _ID = identifier;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = ([Helper toMeters:pos]);
    bodyDef.angularDamping = 0.3f;
    bodyDef.linearDamping = 0.9f;
    
    CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"pinkAlien.png"];
    CGSize spriteSize = tempSprite.contentSizeInPixels;
    b2PolygonShape shape;
    spriteSize.width = spriteSize.width / 4;
    spriteSize.height = spriteSize.height / 4; 
    shape.SetAsBox(spriteSize.width / PTM_RATIO, spriteSize.height / PTM_RATIO);
    b2FixtureDef fixtureDef;
    
    fixtureDef.shape = &shape; //cshape
    fixtureDef.density = 0.5f;
    fixtureDef.friction = 0.6f;
    fixtureDef.restitution = 0.5f;
    fixtureDef.filter.groupIndex = identifier;
    
    
	//if ((self = [super init])) {
		
		
		super.movementSpeed = 15;
		super.reactionSpeed = 20;
		super.hearingRange = [[Options sharedOptions]makeAverageConstantRelative:100];
		super.sightRange = [[Options sharedOptions]makeAverageConstantRelative:100];
		super.patrolRadius = [[Options sharedOptions]makeAverageConstantRelative:150];
		super.health = 35;
		super.headHealth = 15;
		super.bleedOutRate = 0.75f;
		super.killReward = 10;
		super.headshotReward = 5;
		super.deathSound = @"bodyPartDeathSound.wav";
		super.headPoppedOffParticle = @"robotHeadOff.plist";
        [super initWithPos:pos world:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"pinkAlien.png" head:@"pinkAlienHead.png"];
		super.weapon = [Weapon randomPrimaryWithId:identifier]; //[Weapon gunWithName:@"L96A1" ID:identifier];
		super.weapon.body->SetTransform(super.body->GetWorldCenter(),0);
		b2RevoluteJointDef jd;
		jd.Initialize(super.body, super.weapon.body,super.body->GetWorldCenter());	
		world->CreateJoint(&jd);
		
		super.blood = @"robotBlood.plist";
		super.bloodColor = ccc3(0,0,250); //230,181, 230
		super.deathExplosion = @"pinkAlienDeathParticle.plist";
		
		ccColor3B particleColor = ccc3(0, 0, 250);
		super.jetPack.jp.startColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.endColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.life = 0.2;
        
		//[self addChild:myRobot];
		//[self addChild:super.weapon];
		[[HelloWorldLayer sharedHelloWorldLayer] addChild:super.weapon];
        super.weapon.recoil /= 5.0f;
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

+(id)pinkAlienWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt{
    return [[[self alloc]initWithPos:pos world:world Identifier:idtt]autorelease];
}
@end
