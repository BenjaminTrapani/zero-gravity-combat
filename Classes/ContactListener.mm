//
//  ContactListener.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"
#import "Bullet.h"
#import "DeletionManager.h"
#import "EventBus.h"
#import "GreenBlob.h"
#import "BaseLevelObject.h"
#import "ElectricArc.h"
#import "Soldier.h"
#import "Rocket.h"
#include "Singleton.h"
void ContactListener::BeginContact(b2Contact* contact)
{
	b2Body * bodyA = contact->GetFixtureA()->GetBody();
	b2Body * bodyB = contact->GetFixtureB()->GetBody();
	BodyNode * bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode * bodyNodeB = (BodyNode*)bodyB->GetUserData();
    
    b2WorldManifold * worldManifold = new b2WorldManifold();
    contact->GetWorldManifold(worldManifold);
    b2Vec2 contactPoint = worldManifold->points[0];//contact->GetManifold()->points[0].localPoint;
    delete worldManifold;
    
    if (bodyNodeA.userData == kBodyTypeRocket) {
        CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"];
        system.autoRemoveOnFinish = YES;
        system.position = [Helper toPixels:contactPoint];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:system];
        if ([bodyNodeB isKindOfClass:[Soldier class]]) {
            ((Soldier*)bodyNodeB).health-=kRocketDamageToSoldier*((Rocket*)bodyNodeA).damage; //used to be 50
        }
        if ([bodyNodeB isKindOfClass:[BaseAI class]]) {
            ((BaseAI*)bodyNodeB).health-=kRocketDamageFactor*((Rocket*)bodyNodeA).damage;
        }
        if ([bodyNodeB isKindOfClass:[BaseLevelObject class]]) {
            if (((BaseLevelObject*)bodyNodeB).takesDamageFromBullets == YES) {
                ((BaseLevelObject*)bodyNodeB).health-=kRocketDamageFactor;
            }
            
        }
        [(Rocket*)bodyNodeA explode];
       // bodyNodeA.shouldExplode = YES;
    }
    if (bodyNodeB.userData == kBodyTypeRocket) {
        CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"];
        system.autoRemoveOnFinish = YES;
        system.position = [Helper toPixels:contactPoint];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:system];
        
        if ([bodyNodeA isKindOfClass:[Soldier class]]) {
            ((Soldier*)bodyNodeA).health-=kRocketDamageToSoldier*((Rocket*)bodyNodeB).damage*2; //used to be 50
        }
        if ([bodyNodeA isKindOfClass:[BaseAI class]]) {
            ((BaseAI*)bodyNodeA).health-=kRocketDamageFactor*((Rocket*)bodyNodeB).damage*2;
        }
        if ([bodyNodeA isKindOfClass:[BaseLevelObject class]]) {
            if (((BaseLevelObject*)bodyNodeA).takesDamageFromBullets == YES) {
                ((BaseLevelObject*)bodyNodeA).health-=kRocketDamageFactor;
            }
            
        }

        
        [(Rocket*)bodyNodeB explode]; //try exploding the rocket outside of b2world step function
       // bodyNodeB.shouldExplode = YES;
    }
    
    
    if (bodyNodeA.userData == kBodyTypeElectricArc) {
        if ([[bodyNodeB parent] isKindOfClass:[Soldier class]] || [bodyNodeB isKindOfClass:[Soldier class]]) {
			[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].health-=kElectricArcDamage;
			
		}else if ([bodyNodeB isKindOfClass:[BaseAI class]]) { 
            ((BaseAI*)bodyNodeB).health-=kElectricArcDamage;
			
		}else if ([bodyNodeB isKindOfClass:[BaseLevelObject class]]) {
			((BaseLevelObject*)bodyNodeB).health-=kElectricArcDamage;
        }
    }
    
    if (bodyNodeB.userData == kBodyTypeElectricArc) {
        if ([[bodyNodeA parent] isKindOfClass:[Soldier class]] || [bodyNodeA isKindOfClass:[Soldier class]]) {
			[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].health-=kElectricArcDamage;
			
		}else if ([bodyNodeA isKindOfClass:[BaseAI class]]) { 
            ((BaseAI*)bodyNodeA).health-=kElectricArcDamage;
			
		}else if ([bodyNodeA isKindOfClass:[BaseLevelObject class]]) {
			((BaseLevelObject*)bodyNodeA).health-=kElectricArcDamage;
        }
    }
    
    
    BOOL isBullet = NO;
	if ([bodyNodeA isKindOfClass:[Bullet class]]) {
		isBullet = YES;
		bodyNodeA = (Bullet*)bodyNodeA;
		
		bodyNodeA.sprite.visible = NO;
		
		if (bodyNodeB.userData == kBodyTypeHead) {
			[[bodyNodeB parent] onHeadShot:[Helper toPixels:bodyNodeA.body->GetWorldCenter()] bullet:bodyNodeA];
			return;
		}
		
		if ([[bodyNodeB parent] isKindOfClass:[Soldier class]]) {
			[[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier]takeDamageFromBullet:bodyNodeA];
			
		}else if ([bodyNodeB isKindOfClass:[BaseAI class]]) { 
				[bodyNodeB onAIHit:[Helper toPixels:bodyNodeA.body->GetWorldCenter()] bullet:bodyNodeA];
			
		}else if ([bodyNodeB isKindOfClass:[BaseLevelObject class]]) {
			[bodyNodeB takeDamageFromBullet:bodyNodeA];
		}else {
			
			CCParticleSystem * bulletHit = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
			bulletHit.autoRemoveOnFinish = YES;
			bulletHit.position = [Helper toPixels:bodyNodeB.body->GetWorldCenter()];
			[[HelloWorldLayer sharedHelloWorldLayer] addChild:bulletHit];
		}
		
		//[[DeletionManager sharedDeletionManager]addObjectForReset:bodyNodeA];
		
		[[EventBus sharedEventBus]doBulletHit:bodyNodeA position:[Helper toPixels:bodyNodeA.body->GetWorldCenter()]];
		
	}
	if ([bodyNodeB isKindOfClass:[Bullet class]]) {
		isBullet = YES;
		bodyNodeB = (Bullet*)bodyNodeB;
		
		bodyNodeB.sprite.visible = NO;
		
		if (bodyNodeA.userData == kBodyTypeHead) {
			[[bodyNodeA parent] onHeadShot:[Helper toPixels:bodyNodeB.body->GetWorldCenter()] bullet:bodyNodeB];
			return;
		}
		
		if ([[bodyNodeA parent] isKindOfClass:[Soldier class]]) {
			[[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier]takeDamageFromBullet:bodyNodeB]; 
			
		}else if ([bodyNodeA isKindOfClass:[BaseAI class]]) { //something about this isn't working. It is defaulting to bulletHitParticle. Find way to get wheather or not it is part of the ai class. Try using super.
				[bodyNodeA onAIHit:[Helper toPixels:bodyNodeB.body->GetWorldCenter()] bullet:bodyNodeB];
			
		}else if ([bodyNodeA isKindOfClass:[BaseLevelObject class]]){
			[bodyNodeA takeDamageFromBullet:bodyNodeB];
		}else{
			CCParticleSystem * bulletHit = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
			bulletHit.autoRemoveOnFinish = YES;
			bulletHit.position = [Helper toPixels:bodyNodeB.body->GetWorldCenter()];
			[[HelloWorldLayer sharedHelloWorldLayer] addChild:bulletHit];
		}
		
		/*if (((BaseLevelObject*)bodyNodeA).showParticlesForContacts == YES || ((BaseLevelObject*)bodyNodeB).showParticlesForContacts == YES){
            CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
            system.color =
        }
		*/
		//[[DeletionManager sharedDeletionManager]addObjectForReset:bodyNodeB];
		
		[[EventBus sharedEventBus]doBulletHit:bodyNodeB position:[Helper toPixels:bodyNodeB.body->GetWorldCenter()]];
		
	}
    if (isBullet == NO) {
        
        
        if ([bodyNodeA isKindOfClass:[BaseLevelObject class]]) {
            if (((BaseLevelObject*)bodyNodeA).showParticlesForContacts == YES) {
                CCParticleSystem * contactParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
                contactParticle.startColor = ccc4FFromccc3B(((BaseLevelObject*)bodyNodeA).contactColor);
                contactParticle.endColor = ccc4FFromccc3B(((BaseLevelObject*)bodyNodeA).contactColor);
                contactParticle.autoRemoveOnFinish = YES;
                CGPoint addPoint = [Helper toPixels:contactPoint];
                //addPoint = [bodyNodeB.sprite convertToWorldSpace:addPoint];
                //CCLOG(@"addPoint.x = %f addPoint.y = %f",addPoint.x,addPoint.y);
                contactParticle.position = addPoint;
                [[HelloWorldLayer sharedHelloWorldLayer]addChild:contactParticle];
               // CCLOG(@"a");
                
            }
        }
        
        if ([bodyNodeB isKindOfClass:[BaseLevelObject class]]) {
            if (((BaseLevelObject*)bodyNodeB).showParticlesForContacts == YES) {
                CCParticleSystem * contactParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
                contactParticle.startColor = ccc4FFromccc3B(((BaseLevelObject*)bodyNodeB).contactColor);
                contactParticle.endColor = ccc4FFromccc3B(((BaseLevelObject*)bodyNodeB).contactColor);
                contactParticle.autoRemoveOnFinish = YES;
                CGPoint addPoint = [Helper toPixels:contactPoint];
                //addPoint = [bodyNodeA.sprite convertToWorldSpace:addPoint];
                //CCLOG(@"addPoint.x = %f addPoint.y = %f",addPoint.x,addPoint.y);
                contactParticle.position = addPoint;
                [[HelloWorldLayer sharedHelloWorldLayer]addChild:contactParticle];
               // CCLOG(@"B"); weirdly placed thing occurs no matter which level object is called
                
            }
        }
    }

}

void ContactListener::EndContact(b2Contact* contact)
{
	b2Body * bodyA = contact->GetFixtureA()->GetBody();
	b2Body * bodyB = contact->GetFixtureB()->GetBody();
	BodyNode * bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode * bodyNodeB = (BodyNode*)bodyB->GetUserData();
	
    b2WorldManifold * worldManifold = new b2WorldManifold();
    contact->GetWorldManifold(worldManifold);
    b2Vec2 contactPoint = worldManifold->points[0];//contact->GetManifold()->points[0].localPoint;
    delete worldManifold;
    
	/*if (bodyNodeA.userData == kBodyTypeRocket) {
        CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"];
        system.autoRemoveOnFinish = YES;
        system.position = [Helper toPixels:contactPoint];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:system];
        [(Rocket*)bodyNodeA explode];
    }
    if (bodyNodeB.userData == kBodyTypeRocket) {
        CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"];
        system.autoRemoveOnFinish = YES;
        system.position = [Helper toPixels:contactPoint];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:system];
        [(Rocket*)bodyNodeB explode];
    }
	*/
	
	if ([bodyNodeA isKindOfClass:[Bullet class]]) {
		
		//[[DeletionManager sharedDeletionManager]addObjectForReset:bodyNodeA];
		//[[DeletionManager sharedDeletionManager]addObjectForDeletion:bodyNodeA];
		bodyNodeA.shouldReset = YES;
        //bodyNodeA.shouldDelete = YES;
		
	}
	if ([bodyNodeB isKindOfClass:[Bullet class]]) {
		
		//[[DeletionManager sharedDeletionManager]addObjectForReset:bodyNodeB];
		//[[DeletionManager sharedDeletionManager]addObjectForDeletion:bodyNodeB];
		bodyNodeB.shouldReset = YES;
       // bodyNodeB.shouldDelete = YES;
	}

				
		
	

	
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse){
	
	b2Body * bodyA = contact->GetFixtureA()->GetBody();
	b2Body * bodyB = contact->GetFixtureB()->GetBody();
	BodyNode * bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode * bodyNodeB = (BodyNode*)bodyB->GetUserData();
	if ([bodyNodeA isKindOfClass:[BaseLevelObject class]] && ((BaseLevelObject*)bodyNodeA).takesDamageFromCollisions == YES) {
		int32 count = contact->GetManifold()->pointCount;
		float32 maxImpulse = 0.0f;
		for (int32 i = 0; i < count; ++i) {
			maxImpulse = b2Max(maxImpulse, impulse->normalImpulses[i]);
		}
		
		/*if(maxImpulse > 0.02f) {
			maxImpulse = maxImpulse * 8.0f;
			if(maxImpulse > 0.3f){
				maxImpulse = 0.3f;
			}
			
			
		}
		*/
        float multConstent = 0.0f;
        if(Singleton::sharedInstance()->isIpad)
            multConstent = 5.0f;
        else
            multConstent = 10.0f;
        
		if (maxImpulse*multConstent>((BaseLevelObject*)bodyNodeA).health) {
            ((BaseLevelObject*)bodyNodeA).health-=maxImpulse*multConstent;
        }

		//CCLOG(@"maxImpulse: %f", maxImpulse);
		 
	}
	
	if ([bodyNodeB isKindOfClass:[BaseLevelObject class]] && ((BaseLevelObject*)bodyNodeB).takesDamageFromCollisions == YES) {
		int32 count = contact->GetManifold()->pointCount;
		float32 maxImpulse = 0.0f;
		for (int32 i = 0; i < count; ++i) {
			maxImpulse = b2Max(maxImpulse, impulse->normalImpulses[i]);
		}
		
		/*if(maxImpulse > 0.02f) {
			maxImpulse = maxImpulse * 8.0f;
			if(maxImpulse > 0.3f){
				maxImpulse = 0.3f;
			}
			
			
		}
		 */
        float multConstent = 0.0f;
        if(Singleton::sharedInstance()->isIpad)
            multConstent = 5.0f;
        else
            multConstent = 10.0f;
        

		if (maxImpulse*multConstent>((BaseLevelObject*)bodyNodeB).health) {
            ((BaseLevelObject*)bodyNodeB).health-=maxImpulse*multConstent;
        }

		
		//CCLOG(@"maxImpulse: %f", maxImpulse);
	}

	
}