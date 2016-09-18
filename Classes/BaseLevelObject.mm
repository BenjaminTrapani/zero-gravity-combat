//
//  BaseLevelObject.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/25/11.
//  Copyright 2011 __SB Games__. All rights reserved.
//

#import "BaseLevelObject.h"
#import "CDXAudioNode.h"
#import "HelloWorldLayer.h"
#import "EventBus.h"
#import "DeletionManager.h"
#import "Soldier.h"
#import "BaseAI.h"
#import "Options.h"
@implementation BaseLevelObject
@synthesize health, destructible, destructionParticle, destructionSound, contactColor, explosive, explosionForce, explosionRange, dimensions, isSwitch, switchEvent,
takesDamageFromCollisions, switchSubscribers, showParticlesForContacts,takesDamageFromBullets, proceduralDestruction, pdParticle, pdSoundEffect, pdRate;//uniqueID;
-(id)init{
	if ((self = [super init])) {
		
		explosionForce = 0;
		explosionRange = 0;
		exploded = NO;
        takesDamageFromBullets = YES;
        super.usesSpriteBatch = YES;
        destructible = NO;
        numberOfDamages = 0;
	}
	return self;
}

-(void)setDestructionSound:(CDXAudioNode *)DestructionSound{
    destructionSound = DestructionSound;
    destructionSound.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
    [[HelloWorldLayer sharedHelloWorldLayer]addChild:destructionSound];
}
-(void)explode{
	if (destructible==YES && exploded == NO) {
        exploded = YES;
        if (isSwitch == YES) {
            NSAssert([switchSubscribers count]>0,@"no switch subscribers");
            for (BaseLevelObject * currentSubscriber in switchSubscribers) {
                [currentSubscriber performSwitchEvent:switchEvent]; 
            } 
            [switchSubscribers removeAllObjects];
        }
		
        
		destructionSound.position = super.sprite.position;
		[destructionSound play];
		NSAssert(destructionParticle!=nil,@"if a level object is destructible, it needs a destruction particle");
		destructionParticle.position = [Helper toPixels:super.body->GetWorldCenter()];
		destructionParticle.autoRemoveOnFinish = YES;
        
        if([Options sharedOptions].isIpad){
            CGSize unrelativeSize = CGSizeMake(dimensions.width*0.5f, dimensions.height*0.5f);
            destructionParticle.posVar = ccp(unrelativeSize.width,unrelativeSize.height);
        }else{
            destructionParticle.posVar = ccp(dimensions.width,dimensions.height);
        }
		destructionParticle.rotation = -1 * CC_RADIANS_TO_DEGREES(super.body->GetAngle());
		[[HelloWorldLayer sharedHelloWorldLayer]addChild:destructionParticle];
		
        [super notifyDestructionListeners];
    
        super.shouldDelete = YES;
		
		if (explosive==YES) {
			
			CGPoint selfPos = [Helper toPixels:self.body->GetWorldCenter()];
			float maxDistance = [[Options sharedOptions] makeAverageConstantRelative:explosionRange];
			int maxForce = [[Options sharedOptions]makeAverageConstantRelative:explosionForce];
			b2World * currentWorld = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
			NSAssert(currentWorld!=nil,@"currentWorld doesn't equal anything");
			for (b2Body*b = currentWorld->GetBodyList(); b!=nil; b = b->GetNext()) {
				
				
				float distance = 0;
				float strength = 0;
				float force = 0;
				float angle = 0;
				
				CGPoint curPos = [Helper toPixels:b->GetWorldCenter()];
				
				distance = ccpDistance(selfPos, curPos);
                
				if (distance>maxDistance) 
                    continue;
					
				
				
				
				strength = (distance - maxDistance)/maxDistance;
				force = strength * maxForce;
				angle = atan2f(selfPos.y - curPos.y, selfPos.x - curPos.x);
				
				
				
				b->ApplyLinearImpulse(b2Vec2(cosf(angle) * force, sinf(angle) * force), b->GetPosition());
				BodyNode * bn = (BodyNode*)b->GetUserData();
				if ([bn isKindOfClass:[Soldier class]]) {
					((Soldier*)bn).health-=abs(force*70); 
				}
				if ([bn isKindOfClass:[BaseAI class]]) {
					((BaseAI*)bn).health-=abs(force*70);
				}
				if ([bn isKindOfClass:[BaseLevelObject class]]) {
                    if (((BaseLevelObject*)bn).takesDamageFromBullets == YES) {
                        ((BaseLevelObject*)bn).health-=abs(force*70);
                    }
					
				}
			}
			
		}
		
		
		
	}
	
}
-(void)setProceduralDestruction:(BOOL)nproceduralDestruction{
    proceduralDestruction = nproceduralDestruction;
    if (nproceduralDestruction==YES) {
        self.usesSpriteBatch = NO;
        [self schedule:@selector(Update:)];
    }
}

-(void)Update:(ccTime)delta{
    self.health-=numberOfDamages * pdRate * delta;
}

-(void)takeDamage:(float)damage rotation:(float)rot atPosition:(CGPoint)pos{
    if (proceduralDestruction) {
        
        CCParticleSystem * damageParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:pdParticle];
        damageParticle.rotation = -rot + 180;
        damageParticle.position = pos;
        damageParticle.positionType = kCCPositionTypeFree;
        [sprite addChild:damageParticle];
        CDXAudioNode * damageEffect = [CDXAudioNode audioNodeWithFile:pdSoundEffect soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        damageEffect.playMode = kAudioNodeLoop;
        damageEffect.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        damageEffect.position = damageParticle.position;
        [sprite addChild:damageEffect];
        [damageEffect play];
        numberOfDamages ++;
        if (takesDamageFromBullets == NO)
            return;
        self.health-=damage;
    }else{
        CCParticleSystem * contactParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
        contactParticle.startColor = ccc4FFromccc3B(contactColor);
        contactParticle.endColor = ccc4FFromccc3B(contactColor);
        contactParticle.autoRemoveOnFinish = YES;
        contactParticle.position = pos;
        [self addChild:contactParticle];
        
        if (takesDamageFromBullets == NO)
            return;
        
        self.health-=damage;
    }
	
}


-(void)takeDamageFromBullet:(Bullet*)bullet{
    if (proceduralDestruction) {
        
        CCParticleSystem * damageParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:pdParticle];
        damageParticle.rotation = -CC_RADIANS_TO_DEGREES(bullet.body->GetAngle()) + 180;
        damageParticle.position = [sprite convertToNodeSpace:ccpMidpoint([Helper toPixels:bullet.body->GetWorldCenter()], [Helper toPixels:body->GetWorldCenter()])];
        damageParticle.positionType = kCCPositionTypeFree;
        [sprite addChild:damageParticle];
        CDXAudioNode * damageEffect = [CDXAudioNode audioNodeWithFile:pdSoundEffect soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        damageEffect.playMode = kAudioNodeLoop;
        damageEffect.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        damageEffect.position = damageParticle.position;
        [sprite addChild:damageEffect];
        [damageEffect play];
        numberOfDamages ++;
        if (takesDamageFromBullets == NO) 
            return;
        self.health-=bullet.damage;
    }else{
        CCParticleSystem * contactParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bulletHitParticle.plist"];
        contactParticle.startColor = ccc4FFromccc3B(contactColor);
        contactParticle.endColor = ccc4FFromccc3B(contactColor);
        contactParticle.autoRemoveOnFinish = YES;
        contactParticle.position = [Helper toPixels:bullet.body->GetWorldCenter()];
        [self addChild:contactParticle];
        
        if (takesDamageFromBullets == NO) 
            return;
    
        self.health-=bullet.damage;
        }
	
}

-(void)setHealth:(float)newHealth{
	health = newHealth;
	
	if (health<=0) {
		
		[self explode];
	}
}
-(BaseLevelObject*)copy{
	//overide this
}
-(void)performSwitchEvent:(SwitchEvent)event{
    //overide this if your base level object responds to a switch event differently then implemented here.
    if (event == switchEventDestroy) {
        self.health = -1;
    }
   
}
-(void)dealloc{
    if(switchSubscribers)
        [switchSubscribers release];
    [super dealloc];
}
@end
