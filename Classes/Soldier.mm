//
//  Soldier.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Soldier.h"
#import "EventBus.h"
#import "SimpleAudioEngine.h"
#import "JetPack.h"
#import "HUD.h"

#import "CDXAudioNode.h"
#import "Bullet.h"
#import "LazerSight.h"

@implementation Soldier
@synthesize maxSpeed;
@synthesize primaryWeapon;
@synthesize secondaryWeapon;
@synthesize currentWeapon;
@synthesize jetPack;
@synthesize health;
@synthesize accelerationSpeed;

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init])) {
        o = [Options sharedOptions];
		jetPack = [[JetPack alloc]initForLaterSoundAddition];
		[self createSoldierInWorld:world];
		[[EventBus sharedEventBus]addSubscriber:self toEvent:@"playerMoved"];
		//[[EventBus sharedEventBus]addSubscriber:self toEvent:@"weaponFired"];
		currentWeapon = @"primary";
		
		cisIpad = o.isIpad;
		
		}
	return self;
}

+(id) soldierWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world]autorelease];
}
-(void) dealloc
{
	CCLOG(@"soldier released");
	[jetPack release];
    
    [[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"playerMoved"];
    //[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"weaponFired"];
	//[primaryWeapon release];
	//[secondaryWeapon release];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"playerMoved"];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"weaponFired"];

	[super dealloc];
    
    if(sprite)
        [sprite release];
    
}
-(void) createSoldierInWorld:(b2World*)world{
	maxHealth = 200;
	self.health = maxHealth;
	timeSinceLastHit = 0;
	soldierWorld = world;
	
	CGPoint startPos = [HelloWorldLayer sharedHelloWorldLayer].gameStartPosition;
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = ([Helper toMeters:startPos]);
	bodyDef.angularDamping = 0.9f;
	bodyDef.linearDamping = 0.9f;
	
    primaryWeapon = [Weapon gunWithName:[NSString stringWithFormat:@"%@",[[Options sharedOptions]getPrimarySave]]];
	secondaryWeapon = [Weapon gunWithName:[NSString stringWithFormat:@"%@",[[Options sharedOptions]getSecondarySave]]];
	secondaryWeapon.sprite.visible = NO;
	secondaryWeapon.body->SetActive(false);
	primaryWeapon.scale = 0.2f;
	secondaryWeapon.scale = 0.2f;
	
	
	b2PolygonShape shape;
	
	
	b2BodyDef bd;
	b2CircleShape circ;
	b2FixtureDef fixtureDef;
	b2PolygonShape box;
	b2RevoluteJointDef jd;
	BodyNode * creator = [BodyNode alloc];
	creator.usesSpriteBatch = YES;
	float startX = startPos.x;
	float startY = startPos.y;
	
	// BODIES
	// Set these to dynamic bodies
	bd.type = b2_dynamicBody;
	
	//NSString * spriteFrameName;
	// Head
    //make all size constants relative. Do the same for spaceguard.
    
	circ.m_radius = [o makeAverageConstantRelative:5.0]/PTM_RATIO;
	fixtureDef.shape = &circ;
	fixtureDef.density = 0.3;
	fixtureDef.friction = 0.1;
	fixtureDef.restitution = 0.3;
	fixtureDef.filter.groupIndex = -8;
	bd.position.Set(startX / PTM_RATIO, startY / PTM_RATIO);
	b2Body *head = [creator createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"head.png"];
	[self addChild:creator];
	[creator release];
	
	//b2Body *head = world->CreateBody(&bd);
	// head->CreateFixture(&fixtureDef);
	
	//if (i == 0){
	//head->ApplyLinearImpulse(b2Vec2(random() * 100 - 50, random() * 100 - 50), head->GetWorldCenter());
	//}
	
	
	// UpperArm
	fixtureDef.density = 0.1;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	
	// L
	BodyNode * c4 = [BodyNode alloc];
    c4.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.07f], [o smartMultByTwo:0.3f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:10]) / PTM_RATIO);
	b2Body *upperArmL =[c4 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"arm.png"];
	[self addChild:c4];
	[c4 release];
	// upperArmL->CreateFixture(&fixtureDef);
		
	// LowerArm
	fixtureDef.density = 0.3;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	// L
	BodyNode * c6 = [BodyNode alloc];
    c6.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.06f], [o smartMultByTwo:0.3f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:20]) / PTM_RATIO);
	lowerArmL = [c6 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"arm.png"];
	[self addChild:c6];
	[c6 release];
	
    [self addChild:primaryWeapon];
	[self addChild:secondaryWeapon];
    
    bd.fixedRotation = true;
	
	BodyNode * c2 = [BodyNode alloc];
    c2.usesSpriteBatch = YES;
	// Torso1
	box.SetAsBox([o smartMultByTwo:0.1f] , [o smartMultByTwo:0.1f]);
	CCLOG(@"%i",PTM_RATIO);
	fixtureDef.shape = &box;
	fixtureDef.density = 1.0;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	bd.position.Set(startX / PTM_RATIO, (startY - [o smartMultByTwo:10]) / PTM_RATIO);
	b2Body *torso1 = [c2 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"upperTorso.png"];
	[self addChild:c2];
	[c2 release];
	NSAssert(head!=torso1, @"head = torso1");
	
	
	// Torso2
	box.SetAsBox([o smartMultByTwo:0.1f] , [o smartMultByTwo:0.1f]);
	fixtureDef.shape = &box;
	bd.position.Set(startX / PTM_RATIO, (startY - [o smartMultByTwo:18]) / PTM_RATIO);
	[super createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"torso.png"];
	
	// Torso3
	BodyNode * c3 = [BodyNode alloc];
    c3.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.1f] , [o smartMultByTwo:0.1f]);
	fixtureDef.shape = &box;
	bd.position.Set(startX / PTM_RATIO, (startY - [o smartMultByTwo:26]) / PTM_RATIO);
	b2Body *torso3 = [c3 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"lowerTorso.png"];
	[self addChild:c3];
	[c3 release];
	
    bd.fixedRotation = false;
    
	// UpperArm
	fixtureDef.density = 0.1;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	
	
	// R
	BodyNode * c5 = [BodyNode alloc];
    c5.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.07f], [o smartMultByTwo:0.3f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:10]) / PTM_RATIO);
	b2Body *upperArmR = [c5 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"arm.png"];
	[self addChild:c5];
	[c5 release];
	
	// LowerArm
	fixtureDef.density = 0.3;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	
	
	// R
	BodyNode * c7 = [BodyNode alloc];
    c7.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.06f], [o smartMultByTwo:0.3f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:20]) / PTM_RATIO);
	lowerArmR = [c7 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"arm.png"];
	[self addChild:c7];
	[c7 release];
	
	// UpperLeg
	fixtureDef.density = 1.0;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	// L
	BodyNode * c8 = [BodyNode alloc];
    c8.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.1f], [o smartMultByTwo:0.2f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:40]) / PTM_RATIO);
	b2Body *upperLegL = [c8 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"upperLeg.png"];
	[self addChild:c8];
	[c8 release];
	
	// R
	BodyNode * c9 = [BodyNode alloc];
    c9.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.1f], [o smartMultByTwo:0.2f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:40]) / PTM_RATIO);
	b2Body *upperLegR = [c9 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"upperLeg.png"];
	[self addChild:c9];
	[c9 release];
	
	// LowerLeg
	fixtureDef.density = 1.0;
	fixtureDef.friction = 0.4;
	fixtureDef.restitution = 0.1;
	// L
	BodyNode * c10 = [BodyNode alloc];
    c10.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.1f], [o smartMultByTwo:0.2f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX) / PTM_RATIO, (startY - [o smartMultByTwo:55]) / PTM_RATIO);
	b2Body *lowerLegL = [c10 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"leg.png"];
	[self addChild:c10];
	[c10 release];
	
	// R
	BodyNode * c11 = [BodyNode alloc];
    c11.usesSpriteBatch = YES;
	box.SetAsBox([o smartMultByTwo:0.1f], [o smartMultByTwo:0.2f]);
	fixtureDef.shape = &box;
	bd.position.Set((startX ) / PTM_RATIO, (startY - [o smartMultByTwo:55]) / PTM_RATIO);
	b2Body *lowerLegR = [c11 createBodyInWorld:world bodyDef:&bd fixtureDef:&fixtureDef spriteFrameName:@"leg.png"];
	[self addChild:c11];
	[c11 release];
	
	// JOINTS
	jd.enableLimit = true;
	
	
	
	// Head to shoulders
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(10);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(-10);
	jd.Initialize(super.body, head, b2Vec2(startX / PTM_RATIO, (startY-[o smartMultByTwo:10]) / PTM_RATIO));//-10
	world->CreateJoint(&jd);
	
	// Upper arm to shoulders
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);//0 
	jd.upperAngle = CC_DEGREES_TO_RADIANS(60);//60
	jd.Initialize(torso1, upperArmL, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:10]) / PTM_RATIO));
	world->CreateJoint(&jd);
	// R
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);//make shoulder unable to rotate backward. Otherwise gun shoots at soldier.
	jd.upperAngle = CC_DEGREES_TO_RADIANS(60);
	jd.Initialize(torso1, upperArmR, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:10]) / PTM_RATIO));
	world->CreateJoint(&jd);
	
	// Lower arm to upper arm
	// L
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(110);
	jd.Initialize(upperArmL, lowerArmL, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:15]) / PTM_RATIO));
	world->CreateJoint(&jd);
	// R
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(110);
	jd.Initialize(upperArmR, lowerArmR, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:15]) / PTM_RATIO));
	world->CreateJoint(&jd);
	
	
	// Shoulders/stomach
    jd.enableLimit= false;
    
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(torso1, super.body, b2Vec2(startX / PTM_RATIO, (startY - [o smartMultByTwo:8]) / PTM_RATIO)); // - 18
	world->CreateJoint(&jd);
	
	// Stomach/hips
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(0);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(super.body, torso3, b2Vec2(startX / PTM_RATIO, (startY - [o smartMultByTwo:26]) / PTM_RATIO));
	world->CreateJoint(&jd);
	
    jd.enableLimit = true;
	// Torso to upper leg
	// L
	jd.enableLimit = true;
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(-20); //-100
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(torso3, upperLegL, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:28]) / PTM_RATIO));
	world->CreateJoint(&jd);
	// R
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(-20); //-50
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(torso3, upperLegR, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:28]) / PTM_RATIO));
	world->CreateJoint(&jd);
	
	// Upper leg to lower leg
	// L
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(-120);//-170
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(upperLegL, lowerLegL, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:47]) / PTM_RATIO));
	world->CreateJoint(&jd);
	// R
	jd.lowerAngle = CC_DEGREES_TO_RADIANS(-120);
	jd.upperAngle = CC_DEGREES_TO_RADIANS(0);
	jd.Initialize(upperLegR, lowerLegR, b2Vec2((startX) / PTM_RATIO, (startY - [o smartMultByTwo:47]) / PTM_RATIO));
	world->CreateJoint(&jd);
	
	//gun to hands
	primaryWeapon.body->SetTransform(b2Vec2((startX)/PTM_RATIO,(startY-[o smartMultByTwo:27])/PTM_RATIO),CC_DEGREES_TO_RADIANS(270));//20
	secondaryWeapon.body->SetTransform(b2Vec2((startX)/PTM_RATIO,(startY-[o smartMultByTwo:27])/PTM_RATIO),CC_DEGREES_TO_RADIANS(270));//20
	//primary links
	
	jd.enableLimit = NO;
	jd.Initialize(lowerArmL, primaryWeapon.body, primaryWeapon.body->GetWorldCenter());
	world->CreateJoint(&jd);
	jd.Initialize(lowerArmR, primaryWeapon.body, primaryWeapon.body->GetWorldCenter());
	world->CreateJoint(&jd);
	jd.Initialize(lowerArmL, secondaryWeapon.body, secondaryWeapon.body->GetWorldCenter());
	world->CreateJoint(&jd);
    jd.Initialize(lowerArmR, secondaryWeapon.body, secondaryWeapon.body->GetWorldCenter());
	world->CreateJoint(&jd);
	//fine tune hand joint and image. Disable motor.
	
	
	jetPack.fakeParentPos = self.position;
	jetPack.posOffset = ccp([[Options sharedOptions]smartMultByTwo:3], [[Options sharedOptions]smartMultByTwo:10]);
	id listener = [[HelloWorldLayer sharedHelloWorldLayer]getParticleListener];
	[listener addChild:jetPack];
	
	pickupThump = [CDXAudioNode audioNodeWithFile:@"goodClick.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
    [[HelloWorldLayer sharedHelloWorldLayer] addChild:pickupThump];
    
    
	
	[self schedule:@selector(Update:)];
    CCLOG(@"kTintForDamage = %f",kMaxTintForDamage);
    
}
-(void)setMaxSpeed:(float)nmaxSpeed{
    maxSpeed = [[Options sharedOptions]makeAverageConstantRelative:nmaxSpeed];
}

-(void)Update:(ccTime)delta{
    float deltaSixty = (float)delta*60;
	timeSinceLastHit = timeSinceLastHit + deltaSixty;
    pickupThump.position = sprite.position;
	
	if (timeSinceLastHit>60 && health<maxHealth) {
		health+=deltaSixty*0.5f;
        [self updateScreenTint];
	}
}
#pragma mark movement and jetPack control
-(void)onPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees{
    self.jetPack.fakeParentPos = [Helper toPixels:body->GetWorldCenter()];
    self.jetPack.angle = degrees + 180;
	[self.jetPack emit];
	b2Vec2 force = [Helper toMeters:velocity];
	force.Normalize();
	b2Vec2 realForce;
    realForce = accelerationSpeed *force;
    
    body->ApplyForce(realForce, body->GetWorldCenter());
    const b2Vec2 vecVel = body->GetLinearVelocity();
    const float32 speed = vecVel.Length();
    if (speed > maxSpeed)
        body->SetLinearVelocity((maxSpeed / speed) * vecVel);
    
}
-(void)onPlayerMoved:(CGPoint)velocity jdegrees:(float)degrees direction:(NSString*)dir{
	self.jetPack.fakeParentPos = [Helper toPixels:body->GetWorldCenter()];
	if (dir == @"left") {
		self.jetPack.angle = 0 - self.sprite.rotation;
	}else {
		self.jetPack.angle = 180 - self.sprite.rotation;
	}
	[self.jetPack emit];
	
	b2Vec2 force = [Helper toMeters:velocity];
	force.Normalize();
	b2Vec2 realForce =0.15f*force;
	CGPoint pos = [Helper toPixels:body->GetWorldCenter()];
	
	pos.y = pos.y + [[Options sharedOptions]smartMultByTwo:10];
	
	b2Vec2 forcePoint = [Helper toMeters:pos];
	body->ApplyForce(realForce, forcePoint);
	soundCount ++;
	
}
#pragma mark weapon stuff
-(void)onWeaponFired:(CGPoint)velocity bulletDegrees:(CGFloat)degrees{
	
	CGPoint firePosition = [Helper toPixels:body->GetWorldCenter()];
	firePosition.x = firePosition.x + velocity.x * 70;
	firePosition.y = firePosition.y + velocity.y * 70;
	
	if (currentWeapon == @"primary") {
		[primaryWeapon fireBulletWithVelocity:velocity bulletDegrees:degrees world:soldierWorld position:firePosition gunman:self];
	}
	if (currentWeapon == @"secondary") {
		[secondaryWeapon fireBulletWithVelocity:velocity bulletDegrees:degrees world:soldierWorld position:firePosition gunman:self];
	}
	
}

-(void)swapWeapon{
	if (currentWeapon == @"primary") {
		currentWeapon = @"secondary";
		primaryWeapon.sprite.visible = NO;
		secondaryWeapon.sprite.visible = YES;
		primaryWeapon.body->SetActive(false);
		secondaryWeapon.body->SetTransform(primaryWeapon.body->GetWorldCenter(),0);
		secondaryWeapon.body->SetActive(true);
		return;
	}
	if (currentWeapon == @"secondary") {
		currentWeapon = @"primary";
		secondaryWeapon.sprite.visible = NO;
		primaryWeapon.sprite.visible = YES;
		primaryWeapon.body->SetTransform(secondaryWeapon.body->GetWorldCenter(),0);
		primaryWeapon.body->SetActive(true);
		secondaryWeapon.body->SetActive(false);
	}
}
-(Weapon*)getCurrentWeapon{
	if (currentWeapon == @"primary") {
		return primaryWeapon;
	}
	if (currentWeapon == @"secondary") {
		return secondaryWeapon;
	}
}
-(void)rotateGunToAngle:(float)angle{
	if (currentWeapon == @"primary") {
        primaryWeapon.body->SetAngularVelocity(0);
		primaryWeapon.body->SetTransform(primaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((primaryWeapon.recoil * CCRANDOM_0_1())*2)+angle));
	}else {
        secondaryWeapon.body->SetAngularVelocity(0);
		secondaryWeapon.body->SetTransform(secondaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((secondaryWeapon.recoil * CCRANDOM_0_1())*2)+angle));
	}
}

-(void)rotateGunToAngle:(float)angle shaking:(BOOL)shaking{
	if (shaking) {
		if (currentWeapon == @"primary") {
             primaryWeapon.body->SetAngularVelocity(0);
			primaryWeapon.body->SetTransform(primaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((primaryWeapon.recoil * CCRANDOM_0_1())*2)+angle));
			
		}else {
            secondaryWeapon.body->SetAngularVelocity(0);
			secondaryWeapon.body->SetTransform(secondaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((secondaryWeapon.recoil * CCRANDOM_0_1())*2)+angle));
		}
	}else {
		if (currentWeapon == @"primary") {
             primaryWeapon.body->SetAngularVelocity(0);
			primaryWeapon.body->SetTransform(primaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(angle));
			[primaryWeapon.lazerSight showLazerSight];
		}else {
            secondaryWeapon.body->SetAngularVelocity(0);
			secondaryWeapon.body->SetTransform(secondaryWeapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(angle));
			[secondaryWeapon.lazerSight showLazerSight];
		}
	}

}

-(Weapon*)updateCurrentWeaponWithWeapon:(Weapon*)newWeapon{
	Weapon * weaponToReturn;
	[pickupThump play];
	if (currentWeapon == @"primary") {
		
		if ([newWeapon.gunName isEqualToString:primaryWeapon.gunName]) {
			[primaryWeapon addBulletsFromWeapon:newWeapon];
            newWeapon.sprite.visible = NO;
            newWeapon.body->SetActive(false);
		}else {
			weaponToReturn = [[Weapon alloc]initWithGunTag:1];
			[weaponToReturn updateDataWithWeapon:primaryWeapon];
			[primaryWeapon updateDataWithWeapon:newWeapon];
			[newWeapon updateDataWithWeapon:weaponToReturn];
			[weaponToReturn release];
			
		}

				
		[[[HelloWorldLayer sharedHelloWorldLayer]getHUD].myGI updateInformation];
		
	}
	if (currentWeapon == @"secondary") {
        if ([newWeapon.gunName isEqualToString:secondaryWeapon.gunName]) {
			[secondaryWeapon addBulletsFromWeapon:newWeapon];
			newWeapon.sprite.visible = NO;
            newWeapon.body->SetActive(false);
		}else {
			weaponToReturn = [[Weapon alloc]initWithGunTag:1];
			[weaponToReturn updateDataWithWeapon:secondaryWeapon];
			[secondaryWeapon updateDataWithWeapon:newWeapon];
			[newWeapon updateDataWithWeapon:weaponToReturn];
			[weaponToReturn release];
		}
		[[[HelloWorldLayer sharedHelloWorldLayer]getHUD].myGI updateInformation];
		 
	}
	return weaponToReturn;
	
}


-(void)reloadWeapon{
	
	if (currentWeapon == @"primary") {
		[primaryWeapon reloadGun];
		return;
	}
	if (currentWeapon == @"secondary") {
		[secondaryWeapon reloadGun];
	}
	
}
-(void)takeDamage:(float)damage atPosition:(CGPoint)pos{
    timeSinceLastHit = 0;
	self.health -= damage;
	CCParticleSystem * blood = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"soldierBlood.plist"];
	blood.position = pos;
	blood.autoRemoveOnFinish = YES;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:blood];

}
-(void)takeDamageFromBullet:(Bullet*)bullet{
	timeSinceLastHit = 0;
	self.health -= bullet.damage;
	CCParticleSystem * blood = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"soldierBlood.plist"];
	blood.position = [Helper toPixels:bullet.body->GetWorldCenter()];
	blood.autoRemoveOnFinish = YES;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:blood];
	
}
-(void)updateScreenTint{
    float opVal = (255.0f-((health/maxHealth)*255.0f))*kMaxTintForDamage;
    
    [[[HelloWorldLayer sharedHelloWorldLayer]getHUD].injured setOpacity:opVal];
}
-(void)setHealth:(float)newHealth{
    
	health = newHealth;
	if (health<=0) {
		[[HelloWorldLayer sharedHelloWorldLayer]doGameOver];
	}
	if (health<maxHealth) {
        [self updateScreenTint];
	}
}
@end
