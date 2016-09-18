//
//  Rocket.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Rocket.h"
#import "CDXAudioNode.h"
#import "Options.h"
#import "BaseAI.h"
#import "BaseLevelObject.h"
#import "Soldier.h"
@implementation Rocket

@synthesize damage;

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos angle:(float)initAngle groupIndex:(int)index
{
	if ((self = [super init])) {
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 1.0f;
		bodyDef.linearDamping = 0.0f;
		bodyDef.bullet = TRUE;
        bodyDef.fixedRotation = TRUE;
		float32 radianAngle = CC_DEGREES_TO_RADIANS(initAngle);
		bodyDef.angle = radianAngle;
		
		
		NSString * spriteFrameName = @"rocket.png";
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		CGSize bulletSize = tempSprite.contentSizeInPixels;		
        
		
		b2PolygonShape shape;
		
		shape.SetAsBox(bulletSize.width / PTM_RATIO/2, bulletSize.height / PTM_RATIO/2);
		
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; 
		fixtureDef.density = 0.7f; //1.0f
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.1f;
		fixtureDef.filter.groupIndex = index; //prevents gunman from shooting themselves.
		fixtureDef.filter.categoryBits = CATEGORY_BULLET;
		fixtureDef.filter.maskBits = MASK_BULLET;
		//CCLOG(@"bodyDef angle = %f32",bodyDef.angle);
		
        //super.userData = kBodyTypeRocket;
        nextOpenSlot = [[Options sharedOptions]findNextOpenSoundSlot];
        CDXAudioNode * node = [CDXAudioNode audioNodeWithFile:@"RocketFlame.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        node.playMode = kAudioNodeLoop;
        node.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        
        /*explosionSound = [CDXAudioNode audioNodeWithFile:@"BarrelExplosion.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        explosionSound.autoRemoveOnFinish = YES;
        explosionSound.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
         
        
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:explosionSound];*/
        
        
        
        timeToLive = kRocketLifeTime;
        
        super.health = 8;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosion.plist"]; //make particles horizontal. edit variances to match fixture size
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"BarrelExplosion.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(205, 133, 63);
		super.explosive = YES;
		super.explosionForce = 4;
		super.explosionRange = 100;
        super.usesSpriteBatch = NO;
        [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
        
        [super.sprite addChild:node];
        [node play];
        
        
        trail = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"rocketFlameParticle.plist"];
        trail.rotation = initAngle;
        trail.positionType = kCCPositionTypeFree;
        trail.position = ccp(0,bulletSize.height/2);
        [super.sprite addChild:trail];
        
		super.dimensions = super.sprite.contentSize;
		super.takesDamageFromCollisions = YES;

        
        
        [self schedule:@selector(Update:)];
        //rockets tend to slow down physics simulation because they cause many bodies to awaken. The irregular framerate under normal playing conditions is also the fault of the physics simulation. 
	}
	return self;
}
-(void)Update:(ccTime)delta{
    timeToLive-=delta;
    trail.rotation = CC_RADIANS_TO_DEGREES(body->GetAngle());
    if (timeToLive<=0.0f) {
        [self unschedule:@selector(Update:)];
        super.health = -1.0f;
    }
}
-(void)setAngle:(float)angle{
	float32 radianAngle = CC_DEGREES_TO_RADIANS(angle);
	super.body->SetTransform(b2Vec2(0,0),radianAngle);
	
}
/*-(void)explode{
    explosionSound.position = [Helper toPixels:super.body->GetWorldCenter()];
    [explosionSound play];
    CGPoint selfPos = [Helper toPixels:self.body->GetWorldCenter()];
    float maxDistance = [[Options sharedOptions]makeAverageConstantRelative:kRocketExplosionRange];
    int maxForce = [[Options sharedOptions]makeAverageConstantRelative:kRocketExplosionForce];
    b2World * currentWorld = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
    //NSAssert(currentWorld!=nil,@"currentWorld doesn't equal anything");
    super.shouldDelete = YES;
    //return;
    for (b2Body*b = currentWorld->GetBodyList(); b!=nil; b = b->GetNext()) {
        //CCLOG(@"looping through objects in rocket explode");
       // if (b->GetType()==b2_staticBody) 
       //     continue;
        
        
        float distance = 0.0f; //changed all these to floats instead of assigning to int (0). Performance remains resonable and doesn't jitter on map 1. Map 2 does. Get rid of large static bodies and overlapping static bodies to fix the problem.
        float strength = 0.0f;
        float force = 0.0f;
        float angle = 0.0f;
        
        CGPoint curPos = [Helper toPixels:b->GetWorldCenter()];
        
        distance = ccpDistance(selfPos, curPos);
        if (distance>maxDistance) {
            continue;
            //distance = maxDistance - 0.01;
        }
        
        //strength = (maxDistance - distance) / maxDistance;
        strength = (distance - maxDistance)/maxDistance;
        force = strength * maxForce;
        angle = atan2f(selfPos.y - curPos.y, selfPos.x - curPos.x);
        //b2Vec2 forceVec = [Helper toMeters:force];
        //b2Vec2 forceVect = b2Vec2(cosf(angle) * force, sinf(angle) * force);
        //CCLOG(@"strength = %f force = %f angle = %f distance = %f",strength,angle,force, distance);
        b->ApplyLinearImpulse(b2Vec2(cosf(angle) * force, sinf(angle) * force), b->GetPosition()); //uncomment this and solve jitter
       // b->ApplyForce(b2Vec2(cosf(angle) * force, sinf(angle) * force * 1000), b->GetPosition());
        BodyNode * bn = (BodyNode*)b->GetUserData();
        if ([bn isKindOfClass:[Soldier class]]) {
            ((Soldier*)bn).health-=abs(force*(damage * kRocketDamageToSoldier)); //used to be 50
        }
        if ([bn isKindOfClass:[BaseAI class]]) {
            ((BaseAI*)bn).health-=abs(force*(damage * kRocketDamageFactor));
        }
        if ([bn isKindOfClass:[BaseLevelObject class]]) {
            if (((BaseLevelObject*)bn).takesDamageFromBullets == YES) {
                ((BaseLevelObject*)bn).health-=abs(force*(damage * kRocketDamageFactor));
            }
            
        }
    }

}*/
+(id)rocketWithWorld:(b2World*)world position:(CGPoint)bulletPosition angle:(float)inputAngle groupIndex:(int)index{
	return [[[self alloc]initWithWorld:world position:bulletPosition angle:inputAngle groupIndex:index]autorelease];
}

- (void) dealloc
{
    //CCLOG(@"rocket deallocated");
    //[[HelloWorldLayer sharedHelloWorldLayer]removeChild:explosionSound cleanup:YES];
	// in case you have something to dealloc, do it in this method
	//[[Options sharedOptions]removeSoundAtIndex:nextOpenSlot]; 
	[super dealloc];
}

@end
