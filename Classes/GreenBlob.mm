//
//  GreenBlob.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreenBlob.h"
#import "Options.h"
#import "JetPack.h"
#import "Weapon.h"
@implementation GreenBlob
-(id)initWithPos:(CGPoint)pos world:(b2World*)world Identifier:(int)identifier{
	//if ((self = [super init])) {
		_pos = pos;
        _ID = identifier;
		
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.3f;
		bodyDef.linearDamping = 0.9f;
		
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"greenAlien.png"];
		CGSize spriteSize = tempSprite.contentSizeInPixels;
		b2PolygonShape shape;
		spriteSize.width = spriteSize.width / 3;
		spriteSize.height = spriteSize.height / 5; //make contact listener check bodyType outside of checking if it is ai. 
		shape.SetAsBox(spriteSize.width / PTM_RATIO, spriteSize.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 1.0f;
		fixtureDef.filter.groupIndex = identifier;
		
		//[myGreenBlob createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"greenAlien.png"];
		
		super.movementSpeed = 8;
		super.reactionSpeed = 7;
		super.hearingRange = [[Options sharedOptions]makeAverageConstantRelative:200];
		super.sightRange = [[Options sharedOptions]makeAverageConstantRelative:200];
		super.patrolRadius = [[Options sharedOptions]makeAverageConstantRelative:200];
		super.health = 50;
		super.headHealth = 5;
		super.bleedOutRate = 0.5;
		super.killReward = 10;
		super.headshotReward = 5;
		super.deathSound = @"Slime.wav";
		super.headPoppedOffParticle = @"alienHeadOff.plist";
				
		super.blood = @"slimeBlood.plist";
		super.deathExplosion = @"slimeDeathExplosion.plist";
		[super initWithPos:pos world:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:@"greenAlien.png" head:@"greenAlienHead.png"];
        super.weapon = [Weapon randomPrimaryWithId:identifier]; //[Weapon gunWithName:@"L96A1" ID:identifier];
        super.weapon.body->SetTransform(super.body->GetWorldCenter(),0);
        
		
		b2RevoluteJointDef jd;
		jd.Initialize(super.body, super.weapon.body,super.body->GetWorldCenter());	
		world->CreateJoint(&jd);

		ccColor3B particleColor = ccc3(0, 0, 255);
		super.jetPack.jp.startColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.endColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.life = 0.4;
		//[self addChild:myGreenBlob];
        [[HelloWorldLayer sharedHelloWorldLayer] addChild:super.weapon];
		//[myGreenBlob addChild:myGreenBlob.weapon];
		
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
+(id)blobWithWorld:(b2World*)world Pos:(CGPoint)pos Identifier:(int)identifier{
	return [[[self alloc]initWithPos:pos world:world Identifier:identifier]autorelease];
}
-(void)dealloc{
	[super dealloc];
}
@end

