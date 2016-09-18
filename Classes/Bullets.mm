//
//  Bullets.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bullets.h"
#import "Bullet.h"
#import "SimpleAudioEngine.h"
#import "EventBus.h"
#import "Weapon.h"
#import "Rocket.h"
#import "BulletCast.h"
#import "BaseAI.h"
#import "GreenBlob.h"
#import "BaseLevelObject.h"
#import "ElectricArc.h"
#import "Soldier.h"


@implementation Bullets
@synthesize usingRockets;
@synthesize bulletBodyIndex;


-(id) initWithGroupIndex:(int)index;
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		//[self schedule:@selector(Update:)];
		//[[EventBus sharedEventBus]addSubscriber:self toEvent:@"bulletHit"];
        /*CGSize screenSize = [[CCDirector sharedDirector]winSize];
        b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
        maxBullets = 10;
        for (int i = 0; i<maxBullets; i++) {
           bullet[i] = [Bullet bulletWithWorld:world position:ccp(-screenSize.width,-screenSize.height) angle:0 groupIndex:index];
            [self addChild:bullet[i] z:100 tag:i];
        }
         */
        bulletIndex = 0;
        usingRockets = NO;
    }
	return self;
}
-(id)initForRocketsWithGroupIndex:(int)index{
    if ((self = [super init])) {
       /* CGSize screenSize = [[CCDirector sharedDirector]winSize];
        b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
        maxBullets = 10;
        for (int i = 0; i<maxBullets; i++) {
            bullet[i] = [Bullet bulletWithWorld:world position:ccp(-screenSize.width,-screenSize.height) angle:0 groupIndex:index];
            [self addChild:bullet[i] z:100 tag:i];
        }
        bulletIndex = 0;

        */
        usingRockets = YES;
        bulletBodyIndex = index;
    }
    return self;
    
}
-(void)fireBulletWithVelocity:(CGPoint)velocity bulletDegrees:(CGFloat)degrees world:(b2World*)world position:(CGPoint)shotPos gunman:(BodyNode*)currentGunMan weapon:(Weapon*)currentWeapon interval:(float)interval{
    //return;
	timeBetweenShots = 11 - currentWeapon.rateOfFire;
	shotCount += interval;
	//idToAssign ++;
	//bullet firing isn't costly. Everything leading up to it is though, including some of the logic in this function. Try storing all these values passed in this function permanently in the bullets class
    //CCLOG(@"bullet fired degrees = %f",degrees); bullet degrees aren't getting corrupted
	
	if (shotCount<timeBetweenShots && currentWeapon.fireType != @"sa") {
		//CCLOG(@"1");
		return;
	}else {
		shotCount = 0;
		currentWeapon.shotsLeftInMag = currentWeapon.shotsLeftInMag - 1;
	}
	
	//NSAssert(currentWeapon.gunShot!=nil,@"currentWeapon.gunShot=nil"); succeeded
    
	[currentWeapon.gunShot play];
    
	//Bullet * currentBullet = [Bullet bulletWithWorld:world position:shotPos angle:degrees];
	//currentBullet.position = shotPos;
	//currentBullet.damage = self.damage;
	////CCSpriteBatchNode * batch = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatch];
	////[batch addChild:currentBullet];
	//[[HelloWorldLayer sharedHelloWorldLayer]addChild:currentBullet];
	////[self addChild:currentBullet];
    //return;
	
    
    /*b2Vec2 force = [Helper toMeters:velocity];
	force.Normalize();
	b2Vec2 realForce = 150.0f * force; //the number times the force determines the relative speed of bullets. used to be 75.0f
	float realAccuracy = (11 - currentWeapon.accuracy)*5;//this is the relative accuracy of all guns. used to be 3
	float amountToVary = CCRANDOM_MINUS1_1()*realAccuracy;
	realForce.x = realForce.x + amountToVary;
	realForce.y = realForce.y + amountToVary;
    */
     
    if (!usingRockets) {
        
    
    /*bulletIndex ++;
    if (bulletIndex>=maxBullets) {
        bulletIndex = 0;
    }
    
    float32 radianAngle = CC_DEGREES_TO_RADIANS(degrees);
    //CCLOG(@"radian angle = %f",radianAngle); this is also fine
	//Bullet * currentBullet = (Bullet*)[self getChildByTag:bulletIndex];
    bullet[bulletIndex].damage = currentWeapon.damage;
   bullet[bulletIndex].sprite.visible = YES;
    b2Vec2 vecPos = [Helper toMeters:shotPos];
    bullet[bulletIndex].body->SetLinearVelocity(b2Vec2_zero);
    bullet[bulletIndex].body->SetActive(true);
	bullet[bulletIndex].body->SetTransform(vecPos, radianAngle);	
    //currentBullet.body->SetTransform(vecPos, radianAngle);
    //[self addChild:currentBullet];
	
	
	
	bullet[bulletIndex].body->ApplyForce(realForce, vecPos);
	//CGPoint pointRecoil = ccp(velocity.x *  currentWeapon.recoil, velocity.y *  currentWeapon.recoil);
	//pointRecoil.x = pointRecoil.x * -20; //-300
	//pointRecoil.y = pointRecoil.y * -20;
     
    */
        float realAccuracy = (11 - currentWeapon.accuracy)*200;//this is the relative accuracy of all guns. used to be 3
        float amountToVary = CCRANDOM_MINUS1_1()*realAccuracy;
        b2Vec2 destPoint = [Helper toMeters:ccp((shotPos.x + velocity.x*10000.0f)+amountToVary, (shotPos.y + velocity.y*10000.0f) + amountToVary)]; //add shot position to this. Fix and test
        //don't forget to modify this taking into account accuracy
        BulletCast callback;
        callback.ignoreIndex = currentWeapon.body->GetFixtureList()->GetFilterData().groupIndex;
        world->RayCast(&callback, [Helper toMeters:shotPos], destPoint);
        b2Vec2 contactPoint = callback.m_point;
        b2Vec2 recoilVec = b2Vec2((velocity.x *  currentWeapon.recoil)*-0.625f, (velocity.y *  currentWeapon.recoil)*-0.625f);//[Helper toMeters:pointRecoil];
        currentGunMan.body->ApplyForce(recoilVec, currentGunMan.body->GetWorldCenter());
        
        [[EventBus sharedEventBus]doBulletHit:nil position:[Helper toPixels:contactPoint]];
        
        
        
        if(callback.m_fixture){
            BodyNode * bodyNodeB = (BodyNode*)callback.m_fixture->GetBody()->GetUserData();
            b2Vec2 forceVec = recoilVec;
            forceVec *=-1;
            forceVec *= currentWeapon.damage;
            bodyNodeB.body->ApplyForce(forceVec,contactPoint);
            
        if (bodyNodeB.userData == kBodyTypeHead) {
			[(BaseAI*)[bodyNodeB parent] onHeadShot:[Helper toPixels:contactPoint] Damage:currentWeapon.damage];
			return;
		}
		
		if ([[bodyNodeB parent] isKindOfClass:[Soldier class]] || [bodyNodeB isKindOfClass:[Soldier class]]) {
			[[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier]takeDamage:currentWeapon.damage atPosition:[Helper toPixels:contactPoint]];  
			return;
		}else if ([bodyNodeB isKindOfClass:[BaseAI class]]) {
            [(BaseAI*)bodyNodeB onAIHit:[Helper toPixels:contactPoint] Damage:currentWeapon.damage];
            return;
			
		}else if ([bodyNodeB isKindOfClass:[BaseLevelObject class]]) {
            float rotation = CC_RADIANS_TO_DEGREES(angleBetweenPoints(shotPos, [Helper toPixels:contactPoint]));
			[(BaseLevelObject*)bodyNodeB takeDamage:currentWeapon.damage rotation:rotation atPosition:[Helper toPixels:contactPoint]];
            return;
            //CCLOG(@"hit base level object hit"); gets called
		}else {
			
			CCParticleSystem * bulletHit = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
			bulletHit.autoRemoveOnFinish = YES;
			bulletHit.position = [Helper toPixels:contactPoint];
			[[HelloWorldLayer sharedHelloWorldLayer] addChild:bulletHit];
		}
		
		//[[DeletionManager sharedDeletionManager]addObjectForReset:bodyNodeA];
		}
        
        
		
        /*glColor4f(1.0, 0.8, 0.5, 0.8); //last number is opacity
		glLineWidth(10.5f);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		ccDrawLine(shotPos, [Helper toPixels:destPoint]);
         */
        

        
	}else{
        
        b2Vec2 force = [Helper toMeters:velocity];
        force.Normalize();
        b2Vec2 realForce;
        
        if(![Options sharedOptions].isIpad)
            realForce = 500.0f * force;
        else
            realForce = 250.0f * force;
        
        float realAccuracy = (11 - currentWeapon.accuracy)*5;//this is the relative accuracy of all guns. used to be 3
        float amountToVary = CCRANDOM_MINUS1_1()*realAccuracy;
        realForce.x = realForce.x + amountToVary;
        realForce.y = realForce.y + amountToVary;

        
        Rocket * rocket = [Rocket rocketWithWorld:world position:shotPos angle:degrees groupIndex:self.bulletBodyIndex];
        [self addChild:rocket];
        rocket.damage = currentWeapon.damage;
        b2Vec2 vecPos = [Helper toMeters:shotPos];
        rocket.body->ApplyForce(realForce,vecPos);
        b2Vec2 recoilVec = b2Vec2((velocity.x *  currentWeapon.recoil)*-0.625f, (velocity.y *  currentWeapon.recoil)*-0.625f);//[Helper toMeters:pointRecoil];
        currentGunMan.body->ApplyForce(recoilVec, currentGunMan.body->GetWorldCenter());

    }
    
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
