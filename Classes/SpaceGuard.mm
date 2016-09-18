//
//  SpaceGuard.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpaceGuard.h"
#import "Options.h"
#import "Weapon.h"
#import "JetPack.h"
#import "BodyPart.h"
@implementation SpaceGuard
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt{
    _pos = pos;
    _ID = idtt;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    pos = [Helper relativePointFromPoint:pos];
    bodyDef.position = ([Helper toMeters:pos]);
    bodyDef.angularDamping = 0.3f;
    bodyDef.linearDamping = 0.9f;
    
    CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"ssTorso.png"]; //make one torso sprite, upper leg, lower leg, upper arm, lower arm. Don't forget to set the health of each body part. In body part class, make a function that, on destruction, notifies linked body parts. Based on the positions of the linked body parts, add a blood spirt and direction. 
    CGSize spriteSize = tempSprite.contentSizeInPixels;
    b2PolygonShape cshape;
    spriteSize.width = spriteSize.width / 4;
    spriteSize.height = spriteSize.height / 4; 
    cshape.SetAsBox(spriteSize.width / PTM_RATIO, spriteSize.height / PTM_RATIO);
    b2FixtureDef cfixtureDef;
    
    cfixtureDef.shape = &cshape; //cshape
    cfixtureDef.density = 1.0f;
    cfixtureDef.friction = 0.2f;
    cfixtureDef.restitution = 1.0f;
    cfixtureDef.filter.groupIndex = idtt;
    
    
	//if ((self = [super init])) {
		super.movementSpeed = 8;
		super.reactionSpeed = 5;
		super.hearingRange = [[Options sharedOptions]makeAverageConstantRelative:350];
		super.sightRange = [[Options sharedOptions]makeAverageConstantRelative:200];
		super.patrolRadius = [[Options sharedOptions]makeAverageConstantRelative:150];
		super.health = 75;
		super.headHealth = 30;
		super.bleedOutRate = 0.40f;
		super.killReward = 15;
		super.headshotReward = 5;
		super.deathSound = @"bodyPartDeathSound.wav";
		super.headPoppedOffParticle = @"bloodSpirt.plist";
        bodyDef.fixedRotation = TRUE;
        [super initWithPos:_pos world:world bodyDef:&bodyDef fixtureDef:&cfixtureDef spriteFrameName:@"ssTorso.png" head:@"ssHead.png"];
		super.weapon = [Weapon randomPrimaryWithId:idtt]; //[Weapon gunWithName:@"L96A1" ID:identifier];
		
		//b2RevoluteJointDef jed;
		//jed.Initialize(super.body, super.weapon.body,super.body->GetWorldCenter());	
		//world->CreateJoint(&jed);
		
		super.blood = @"robotBlood.plist";
		super.bloodColor = ccc3(250, 0, 0);
		super.deathExplosion = @"bodyPartDeathParticle.plist";
		
		ccColor3B particleColor = ccc3(200, 200, 0);
		super.jetPack.jp.startColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.endColor = ccc4FFromccc3B(particleColor);
		super.jetPack.jp.life = 0.2;
        
		//[self addChild:myRobot];
		//[self addChild:super.weapon];
		[[HelloWorldLayer sharedHelloWorldLayer] addChild:super.weapon];
        super.weapon.recoil /= 5.0f;
        b2PolygonShape shape;
        
        /*int num = 8;
         b2Vec2 verts[] = {
         b2Vec2(-10.7f / PTM_RATIO, -34.0f / PTM_RATIO),
         b2Vec2(8.2f / PTM_RATIO, -33.2f / PTM_RATIO),
         b2Vec2(8.0f / PTM_RATIO, -15.0f / PTM_RATIO),
         b2Vec2(2.5f / PTM_RATIO, 0.0f / PTM_RATIO),
         b2Vec2(3.0f / PTM_RATIO, 32.5f / PTM_RATIO),
         b2Vec2(-5.5f / PTM_RATIO, 33.0f / PTM_RATIO),
         b2Vec2(-5.7f / PTM_RATIO, -16.0f / PTM_RATIO),
         b2Vec2(-11.5f / PTM_RATIO, -33.5f / PTM_RATIO)
         };
         */
        
        //shape.Set(verts, num);
        
        /*shape.SetAsBox(spriteSize.width/PTM_RATIO/2, spriteSize.height/PTM_RATIO/2);
         b2FixtureDef fixtureDef;
         
         b2CircleShape cshape;
         float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO)*0.5f;
         cshape.m_radius = radiusInMeters;
         
         fixtureDef.shape = &shape; //cshape
         fixtureDef.density = 0.5f; //used to be 1.0f
         fixtureDef.friction = 0.2f;
         fixtureDef.restitution = 0.5f;
         [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
         */
        
        
        
        b2BodyDef bd;
        b2CircleShape circ;
        b2FixtureDef fixtureDef;
        b2PolygonShape box;
        b2RevoluteJointDef jd;
       // BodyNode * creator = [BodyNode alloc];
      //  creator.usesSpriteBatch = YES;
        float startX = pos.x;
        float startY = pos.y;
        
        // BODIES
        // Set these to dynamic bodies
        bd.type = b2_dynamicBody;
        
        //NSString * spriteFrameName;
        // Head
       /* circ.m_radius = 5.0/PTM_RATIO;
        fixtureDef.shape = &circ;
        fixtureDef.density = 0.3;
        fixtureDef.friction = 0.1;
        fixtureDef.restitution = 0.3;
        fixtureDef.filter.groupIndex = -8;
        bd.position.Set(startX / PTM_RATIO, startY / PTM_RATIO);
        b2Body *head = [creator createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"head.png"];
        [self addChild:creator];
        [creator release];
        */
        //b2Body *head = world->CreateBody(&bd);
        // head->CreateFixture(&fixtureDef);
        
        //if (i == 0){
        //head->ApplyLinearImpulse(b2Vec2(random() * 100 - 50, random() * 100 - 50), head->GetWorldCenter());
        //}
        
        
        // UpperArm
        fixtureDef.density = 0.1;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        fixtureDef.filter.groupIndex = idtt; /***/
        // L
        BodyPart * c4 = [BodyPart alloc];
        c4.health = 30;
        c4.usesSpriteBatch = YES;
        box.SetAsBox(0.07f, 0.3f);
        fixtureDef.shape = &box;
        Options * o = [Options sharedOptions];
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:10]) / PTM_RATIO);
        b2Body *upperArmL =[c4 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssUpperArm.png"];
        [self addChild:c4];
        [c4 release];
        // upperArmL->CreateFixture(&fixtureDef);
		
        // LowerArm
        fixtureDef.density = 0.3;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        // L
        BodyPart * c6 = [BodyPart alloc];
        c6.health = 20;
        c6.usesSpriteBatch = YES;
        box.SetAsBox(0.06f, 0.3f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:20]) / PTM_RATIO);
        b2Body * lowerArmL = [c6 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssLowerArm.png"];
        [self addChild:c6];
        [c6 release];
        //lowerArmL->CreateFixture(&fixtureDef);
        
        //hands
        //L
        /*fixtureDef.density = 0.1;
         BodyNode * c13 = [BodyNode alloc];
         box.SetAsBox(0.06f, 0.06f);
         fixtureDef.shape = &box;
         bd.position.Set((startX) / PTM_RATIO, (startY - 20) / PTM_RATIO);
         b2Body *leftHand = [c13 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"hand.png"];
         [self addChild:c13];
         [c13 release];
         */
        
        /*bd.fixedRotation = true;
        
        BodyPart * c2 = [BodyPart alloc];
        c2.usesSpriteBatch = YES;
        // Torso1
        box.SetAsBox(0.1f , 0.1f);
        CCLOG(@"%i",PTM_RATIO);
        fixtureDef.shape = &box;
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        bd.position.Set(startX / PTM_RATIO, (startY - 10) / PTM_RATIO);
        b2Body *torso1 = [c2 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"upperTorso.png"];
        [self addChild:c2];
        [c2 release];
       
        
        // b2Body *torso1 = world->CreateBody(&bd);
        // torso1->CreateFixture(&fixtureDef); //error is right here
        
        // Torso2
        box.SetAsBox(0.1f , 0.1f);
        fixtureDef.shape = &box;
        bd.position.Set(startX / PTM_RATIO, (startY - 18) / PTM_RATIO);
        //keep this super because soldier needs some body node values, otherwise bad access in tick.
        b2Body * torso 2 = [super createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"torso.png"];
        // torso2->CreateFixture(&fixtureDef);
        
        // Torso3
        BodyPart * c3 = [BodyPart alloc];
        c3.usesSpriteBatch = YES;
        box.SetAsBox(0.1f , 0.1f);
        fixtureDef.shape = &box;
        bd.position.Set(startX / PTM_RATIO, (startY - 26) / PTM_RATIO);
        b2Body *torso3 = [c3 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"lowerTorso.png"];
        [self addChild:c3];
        [c3 release];
        // torso3->CreateFixture(&fixtureDef);
        
        bd.fixedRotation = false;
        */
        // UpperArm
        fixtureDef.density = 0.1;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        
        
        // R
        BodyPart * c5 = [BodyPart alloc];
        c5.health = 30;
        c5.usesSpriteBatch = YES;
        box.SetAsBox(0.07f, 0.3f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:10]) / PTM_RATIO);
        b2Body *upperArmR = [c5 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssUpperArm.png"];
        [self addChild:c5];
        [c5 release];
        // upperArmR->CreateFixture(&fixtureDef);
        
        // LowerArm
        fixtureDef.density = 0.3;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        
        
        // R
        BodyPart * c7 = [BodyPart alloc];
        c7.health = 20;
        c7.usesSpriteBatch = YES;
        box.SetAsBox(0.06f, 0.3f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:20]) / PTM_RATIO);
        b2Body * lowerArmR = [c7 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssLowerArm.png"];
        [self addChild:c7];
        [c7 release];
        //lowerArmR->CreateFixture(&fixtureDef);
        
        //hands 
        //R
        /*fixtureDef.density = 0.1;
         BodyNode * c12 = [BodyNode alloc];
         box.SetAsBox(0.06f, 0.06f);
         fixtureDef.shape = &box;
         bd.position.Set((startX) / PTM_RATIO, (startY - 20) / PTM_RATIO);
         b2Body *rightHand = [c12 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"hand.png"];
         [self addChild:c12];
         [c12 release];
         */
        
        // UpperLeg
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        // L
        BodyPart * c8 = [BodyPart alloc];
        c8.health = 40;
        c8.usesSpriteBatch = YES;
        box.SetAsBox(0.1f, 0.2f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:20]) / PTM_RATIO);  //-40
        b2Body *upperLegL = [c8 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssUpperLeg.png"];
        [self addChild:c8];
        [c8 release];
        // upperLegL->CreateFixture(&fixtureDef);
        // R
        BodyPart * c9 = [BodyPart alloc];
        c9.health = 40;
        c9.usesSpriteBatch = YES;
        box.SetAsBox(0.1f, 0.2f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:20]) / PTM_RATIO);
        b2Body *upperLegR = [c9 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssUpperLeg.png"];
        [self addChild:c9];
        [c9 release];
        // upperLegR->CreateFixture(&fixtureDef);
        
        // LowerLeg
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        // L
        BodyPart * c10 = [BodyPart alloc];
        c10.health = 40;
        c10.usesSpriteBatch = YES;
        box.SetAsBox(0.1f, 0.2f);
        fixtureDef.shape = &box;
        bd.position.Set((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:35]) / PTM_RATIO); //55
        b2Body *lowerLegL = [c10 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssLowerLeg.png"];
        [self addChild:c10];
        [c10 release];
        //lowerLegL->CreateFixture(&fixtureDef);
        // R
        BodyPart * c11 = [BodyPart alloc];
        c11.health = 40;
        c11.usesSpriteBatch = YES;
        box.SetAsBox(0.1f, 0.2f);
        fixtureDef.shape = &box;
        bd.position.Set((startX ) / PTM_RATIO, (startY - [o makeAverageConstantRelative:35]) / PTM_RATIO);
        b2Body *lowerLegR = [c11 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"ssLowerLeg.png"];
        [self addChild:c11];
        [c11 release];
        //lowerLegR->CreateFixture(&fixtureDef);
        
        // JOINTS
        jd.enableLimit = true;
        
        
        
        // Head to shoulders
        /*jd.lowerAngle = CC_DEGREES_TO_RADIANS(10);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(-10);
        jd.Initialize(super.body, head, b2Vec2(startX / PTM_RATIO, (startY-10) / PTM_RATIO));//-10
        world->CreateJoint(&jd);
        */
        // Upper arm to shoulders
        //jd.enableLimit = false;
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(180-0);//0 
        jd.upperAngle = CC_DEGREES_TO_RADIANS(180-60);//60
        jd.Initialize(super.body, upperArmL, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:10]) / PTM_RATIO));
        world->CreateJoint(&jd);
        // R
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(180-0);//make shoulder unable to rotate backward. Otherwise gun shoots at soldier.
        jd.upperAngle = CC_DEGREES_TO_RADIANS(180-60);
        jd.Initialize(super.body, upperArmR, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:10]) / PTM_RATIO));
        world->CreateJoint(&jd);
        //jd.enableLimit = true;
        // Lower arm to upper arm
        // L
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(110);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(180);
        jd.Initialize(upperArmL, lowerArmL, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:15]) / PTM_RATIO));
        world->CreateJoint(&jd);
        // R
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(180-110);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(180);
        jd.Initialize(upperArmR, lowerArmR, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:15]) / PTM_RATIO));
        world->CreateJoint(&jd);
        
        jd.enableLimit = false; //link weapon to lower arm
        super.weapon.body->SetTransform(b2Vec2((startX)/PTM_RATIO,(startY-[o makeAverageConstantRelative:27])/PTM_RATIO),CC_DEGREES_TO_RADIANS(270));//20
        jd.Initialize(lowerArmL, super.weapon.body, super.weapon.body->GetWorldCenter());
        world->CreateJoint(&jd);
        //hands to lower arm
        //jd.enableLimit = false;
        
        //L
        /*jd.lowerAngle = CC_DEGREES_TO_RADIANS(-90);
         jd.upperAngle = CC_DEGREES_TO_RADIANS(90);
         jd.Initialize(lowerArmL, leftHand, b2Vec2((startX)/PTM_RATIO, (startY - 30) / PTM_RATIO));
         world->CreateJoint(&jd);
         //R
         jd.Initialize(lowerArmR, rightHand, b2Vec2((startX)/PTM_RATIO, (startY - 30) / PTM_RATIO));
         world->CreateJoint(&jd);
         */
        //jd.enableLimit = true;
        
        
        // Shoulders/stomach
/*        jd.enableLimit= false;
        
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
        jd.Initialize(torso1, super.body, b2Vec2(startX / PTM_RATIO, (startY - 8) / PTM_RATIO)); // - 18
        world->CreateJoint(&jd);
        
        // Stomach/hips
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
        jd.Initialize(super.body, torso3, b2Vec2(startX / PTM_RATIO, (startY - 26) / PTM_RATIO));
        world->CreateJoint(&jd);
        
        jd.enableLimit = true;
 */
        // Torso to upper leg
        // L
        jd.enableLimit = true;
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0); //-100
        jd.upperAngle = CC_DEGREES_TO_RADIANS(50);
        jd.Initialize(super.body, upperLegL, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:8]) / PTM_RATIO));
        world->CreateJoint(&jd);
        // R
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0); //-50
        jd.upperAngle = CC_DEGREES_TO_RADIANS(50);
        jd.Initialize(super.body, upperLegR, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:8]) / PTM_RATIO));
        world->CreateJoint(&jd);
        
        // Upper leg to lower leg
        // L
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);//-170
        jd.upperAngle = CC_DEGREES_TO_RADIANS(110);
        jd.Initialize(upperLegL, lowerLegL, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:27]) / PTM_RATIO));
        world->CreateJoint(&jd);
        // R
        jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
        jd.upperAngle = CC_DEGREES_TO_RADIANS(110);
        jd.Initialize(upperLegR, lowerLegR, b2Vec2((startX) / PTM_RATIO, (startY - [o makeAverageConstantRelative:27]) / PTM_RATIO));
        world->CreateJoint(&jd);
        [self schedule:@selector(spaceGuardUpdate:)];
	//}
	return self;
}
-(void)spaceGuardUpdate:(ccTime)delta{
    super.health -= damageIncrement*delta;
}
-(void)onBodyPartDestroyed:(BodyPart*)aBodyPart{
    damageIncrement += aBodyPart.maxHealth/10;
}
-(void)onLinkedBodyDestroyed:(BodyPart*)destroyedBody withPoint:(CGPoint)bloodPos{
    CCParticleSystem * bloodSpirt = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bloodSpirt.plist"];
    bloodSpirt.position = [super.sprite convertToNodeSpace:bloodPos];
    [super.sprite addChild:bloodSpirt];
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
    
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:point Identifier:idtt];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}

+(id)spaceGuardWithWorld:(b2World*)world Position:(CGPoint)pos Identifier:(int)idtt{
    return [[[self alloc]initWithWorld:world Position:pos Identifier:idtt]autorelease];
}
@end
