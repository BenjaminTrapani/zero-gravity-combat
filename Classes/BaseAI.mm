//
//  BaseAI.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseAI.h"
#import "Soldier.h"
#import "EventBus.h"
#import "Options.h"
#import "JetPack.h"
#import "RaysCastCallback.h"
#import "Weapon.h"
#import "Bullet.h"
#import "DeletionManager.h"
#import "CDXAudioNode.h"
#import "PathfindingPoint.h"
#import "AStar.h"
#import "BaseLevelObject.h"
#import "MyQueryCallback.h"

#define SJ_PI_X_2 6.28318530718f
@implementation BaseAI
@synthesize movementSpeed, reactionSpeed, hearingRange, sightRange, patrolRadius, health, jetPack, weapon, blood, deathExplosion, deathSound, headHealth, headPoppedOffParticle, curBodyType, bleedOutRate, bloodColor, headshotReward, killReward;
-(id)initWithPos:(CGPoint)pos world:(b2World*)world bodyDef:(b2BodyDef*)def fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)name head:(NSString*)head{
	if ((self = [super init])) {
        pos = [Helper relativePointFromPoint:pos];
		[[EventBus sharedEventBus]addSubscriber:self toEvent:@"weaponFired"];
		[[EventBus sharedEventBus]addSubscriber:self toEvent:@"bulletHit"];
		
        doubleSpeed = NO;
        
		
		isUsingEditor = [Options sharedOptions].isUsingEditor;
		
        //fixtureDef->filter.groupIndex = powf(2.0f, fixtureDef->filter.groupIndex);
        /*if ([Options sharedOptions].isIpad) {
            //CCLOG(@"using ipad in base ai init");
            b2PolygonShape * shape = (b2PolygonShape*)fixtureDef->shape;
            shape->m_vertices[0]*=2.27f;
            shape->m_vertices[1]*=2.27f;
            shape->m_vertices[2]*=2.27f;
            shape->m_vertices[3]*=2.27f;
            
            m_vertices[0].Set(-hx, -hy);
            m_vertices[1].Set( hx, -hy);
            m_vertices[2].Set( hx,  hy);
            m_vertices[3].Set(-hx,  hy);
            
            b2Vec2 exampleVertex = shape->m_vertices[2];
            CGRect sizeRect = CGRectMake(0, 0, exampleVertex.x*PTM_RATIO, exampleVertex.y*PTM_RATIO);
            [super createBodyInWorld:world bodyDef:def fixtureDef:fixtureDef spriteFrameName:name rect:sizeRect];
        }else{
         */
            [super createBodyInWorld:world bodyDef:def fixtureDef:fixtureDef spriteFrameName:name];
		//} //make hd version of texture atlases. If sprite is already correctly sized, level object resizing won't effect it. Most things are based off of sprite sizes. Increase all of these and everything will scale up properly. 
        
				
		selfSize = CGSizeMake(self.sprite.contentSize.width, self.sprite.contentSize.height);
		BOOL shouldAddHeadLength = NO;
		if (selfSize.width>selfSize.height) {
			longestBodyLength=selfSize.width;
		}else {
			longestBodyLength=selfSize.height;
            shouldAddHeadLength = YES;
		}
		
		pathFinder = [[AStar alloc]init];
		pathFinder.delegate = self;
        [self addChild:pathFinder];
        [pathFinder release];
		pathFinder.longestEdge = longestBodyLength;
		
		
		self.body->SetTransform([Helper toMeters:pos],0);
		screenSize = [[CCDirector sharedDirector]winSize];
		
		
		
		lowerX = pos.x - patrolRadius/2;
		upperX = pos.x + patrolRadius/2;
		lowerY = pos.y - patrolRadius/2;
		upperY = pos.y + patrolRadius/2;
		
		
		if (head) {
			
			
			b2BodyDef bodyDef;
			bodyDef.type = b2_dynamicBody;
			CCSprite * tempHead = [CCSprite spriteWithSpriteFrameName:head];
			CGSize headSize = CGSizeMake(tempHead.contentSize.width, tempHead.contentSize.height);
			//CCLOG(@"head size = %f %f",headSize.width,headSize.height); gets correct head size
			CGPoint headPos = ccp(pos.x,pos.y+(selfSize.height/3.5f));
			bodyDef.position = ([Helper toMeters:headPos]);
			bodyDef.angularDamping = 0.0f;
			bodyDef.linearDamping = 0.0f;
			
			b2CircleShape shape;
			headSize.width/=2;
			headSize.height/=2;
			shape.m_radius = (headSize.width + headSize.height)/64; //fix size. get debug draw shape bit. Draw debug shape bit to find out if things are getting sized correctly. 
            if (shouldAddHeadLength) {
                if (headSize.width>headSize.height) {
                    longestBodyLength += headSize.width;
                }else{
                    longestBodyLength += headSize.height;
                }

            }
            b2FixtureDef fixtureDef2;
			fixtureDef2.shape = &shape; //cshape
			fixtureDef2.density = 1.0f;
			fixtureDef2.friction = 0.2f;
			fixtureDef2.restitution = 0.5f;
			fixtureDef2.filter.groupIndex = (*fixtureDef).filter.groupIndex;
			
			headBodyNode = [[BodyNode alloc]init];
			headBodyNode.userData = kBodyTypeHead;
			b2Body * headBody = [headBodyNode createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef2 spriteFrameName:head];
			[self addChild:headBodyNode];
			b2RevoluteJointDef jd;
			jd.enableLimit = true;
			jd.upperAngle = CC_DEGREES_TO_RADIANS(10);
			jd.lowerAngle = CC_DEGREES_TO_RADIANS(-10);
			jd.Initialize(self.body, headBody,self.body->GetWorldCenter());	
			world->CreateJoint(&jd);
			
			//headBodyNode.userData = @"AI:ISHEAD";
			[headBodyNode release]; //call release on headBodyNode to officially clean it up

		}
        BOOL acceptableDest = NO;
        RaysCastCallback callback; //see if this fixes bug with ai going straight up.
        b2Vec2 vecStart = [Helper toMeters:pos];
        int tryCount = 0;
		while (!acceptableDest) {
            tryCount ++;
            CGPoint testDest= ccp((arc4random()%(int)patrolRadius) + lowerX, (arc4random()%(int)patrolRadius) + lowerY);
            b2Vec2 testVec = [Helper toMeters:testDest];
            if(ccpDistance(testDest, pos)>0.0f){
                [[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, vecStart, testVec);
                if (callback.m_fixture==NULL) {
                    nextDest = testDest;
                    acceptableDest = YES;
                }
                if (tryCount>100) {
                    nextDest = pos;
                    acceptableDest = YES; //just set the destination to the start position so that the ai continues to look for a place to go
                }
            }
        }
		//nextDest = ccp((arc4random()%(int)patrolRadius) + lowerX, (arc4random()%(int)patrolRadius) + lowerY);
        
		aiState = 1;
		jetPack = [[JetPack alloc]init];
		
		headAttached = YES;
		dead = NO;
		performedCreatePath = NO;
		self.curBodyType = kBodyTypeBody;
		pathExists = NO;
		pathDone = NO;
		hasDealloced = NO;
		
		path = nil;
		//soldier created code
        localSoldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
        
        
        jetPack.fakeParentPos = self.position;
        jetPack.posOffset = ccp([[Options sharedOptions]makeXConstantRelative:5], [[Options sharedOptions]makeYConstantRelative:5]);
        id listener = [[HelloWorldLayer sharedHelloWorldLayer]getParticleListener];
        [listener addChild:jetPack];
        
        deathSFX = [CDXAudioNode audioNodeWithFile:deathSound soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
        
        deathSFX.earNode = localSoldier.sprite;
        [[HelloWorldLayer sharedHelloWorldLayer] addChild:deathSFX];
		
		[self schedule:@selector(Update:)];
        //[self schedule:@selector(lookForSoldier:)interval:0.5f];
	}
	return self;
}
-(void)setReactionSpeed:(float)newRS{
    NSAssert(newRS<100,@"reaction speed can't exceed 100");
    _100minusReactionSpeed = 100-newRS;
	reactionSpeed = newRS*2000;
}
-(void)setWeapon:(Weapon *)nweapon{
    weapon =nweapon;
    weapon.hasCarrier = YES;
    weapon.gunMan = self;
    globalIdtt = weapon.body->GetFixtureList()->GetFilterData().groupIndex;
}
+(id)aiWithPos:(CGPoint)pos world:(b2World*)world bodyDef:(b2BodyDef*)def fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)name head:(NSString*)head{
	return [[[self alloc]initWithPos:pos world:world bodyDef:def fixtureDef:fixtureDef spriteFrameName:name head:head]autorelease];
}
-(void)Update:(ccTime*)delta{ //occasionaly, ai will move really quickly for no reason. Fix this. Also, make sure that space guard can't shoot himself. Make slow down gas object and test blue cylinder. Make AI out of new alien picture I downloaded. Use for level2
   // return;
    if (headAttached==NO) {
		[self bleedOut];
		//CCLOG(@"head not attached");
		return;
	}
	[self lookForSoldier];

    if (isUsingEditor) {
        [self patrol];
        return; 
    }
	

	if (aiState <=_100minusReactionSpeed) {
        doubleSpeed = NO;
		[self patrol];
		return;
	}
    if (aiState>_100minusReactionSpeed) {
        doubleSpeed = YES;
		[self engage];
	}
}
#pragma mark local functions
-(void)lookForSoldier{
	//use raycasts and if they hit the player and the distance is less than the given sight times a factor then increase ai state
    //CCLOG(@"look for local soldier called"); it gets called
	RaysCastCallback callback;
    callback.ignoreIndex = globalIdtt;
	[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, self.body->GetWorldCenter(), localSoldier.body->GetWorldCenter());
	if (callback.m_fixture) {
        
	//checking for body equality won't work because only the torso is the soliders actual body. Label all parts of the soldier with a tag of some kind and check for that instead
		if (callback.m_fixture->GetFilterData().groupIndex == -8) {
           
			hasClearShot = YES;
			float distance = ccpDistance([Helper toPixels:self.body->GetWorldCenter()], [Helper toPixels:localSoldier.body->GetWorldCenter()]);
			if (distance<sightRange) {
				aiState += sightRange/distance;
                //CCLOG(@"state icremented = %f",aiState);
				//hasClearShot = YES;
				
			}
			//CCLOG(@"can see player");
			//aiState +=0.05;
		}else {
            
			hasClearShot = NO;
		}

	}
}
-(void)patrol{
	
	
	b2Vec2 bodyPos = body->GetWorldCenter();
    CGPoint pointPos = [Helper toPixels:bodyPos];
	float offsetX = nextDest.x - pointPos.x;
	float offsetY = nextDest.y - pointPos.y;
	
	CGPoint forceCG = ccp(offsetX*movementSpeed,offsetY*movementSpeed);
    if (doubleSpeed) {
        forceCG.x *= kSpeedFactor * 2;
        forceCG.y *= kSpeedFactor*2;
    }else{
        forceCG.x *= kSpeedFactor;
        forceCG.y *= kSpeedFactor;
    }
	
	
	//angle calculations for jet pack
	CGPoint v1 = pointPos;
	CGPoint v2 = v1;
	v2.x += forceCG.x;
	v2.y += forceCG.y;
	
	
	float angle = atan2f(v1.x-v2.x, v2.y-v1.y);
	if(angle < 0){
		angle		+= SJ_PI_X_2;
	}
	float degrees = CC_RADIANS_TO_DEGREES(angle);
	
	b2Vec2 force = [Helper toMeters:forceCG];
	force.Normalize();
	body->ApplyForce(force,body->GetWorldCenter());
	float distanceFromDest = ccpDistance(pointPos, nextDest);
    
    //this contact test could be costly. 
    BOOL hasInvalidContacts = NO;
    if (body->GetContactList()!=NULL) {
        for (b2ContactEdge * edge = body->GetContactList(); edge!=nil; edge = edge->next) {
            if (edge->other!=headBodyNode.body) {
                hasInvalidContacts = YES;
                //CCLOG(@"invalid body");
            }
        }
    }
    if (headBodyNode) {
        b2Body * headbody = headBodyNode.body;
        if (headbody->GetContactList()!=NULL) {
            for (b2ContactEdge * edge = headbody->GetContactList(); edge!=nil; edge = edge->next) {
                if (edge->other!=body) {
                    hasInvalidContacts = YES;
                    // CCLOG(@"invalid head");
                }
            }
        }

    }
    
    
	if (hasInvalidContacts || distanceFromDest<longestBodyLength*1.5f) {
		CGPoint selfPos = [Helper toPixels:body->GetWorldCenter()];
		selfPos.x -= patrolRadius/2;
		selfPos.y -= patrolRadius/2;
        RaysCastCallback callback;
        CGPoint testDest= ccp((arc4random()%(int)patrolRadius) + lowerX, (arc4random()%(int)patrolRadius) + lowerY);
        [[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, body->GetWorldCenter(), [Helper toMeters:testDest]);
        if (callback.m_fixture==NULL) {
            nextDest = testDest;
        }
		
		
		
	}
    
	self.jetPack.fakeParentPos = [Helper toPixels:self.body->GetWorldCenter()];
	self.jetPack.angle = degrees+270; //180
	[self.jetPack emit];
	
	
}
-(void)beSuspicious{
	//self.body->ApplyForce(b2Vec2(-self.body->GetLinearVelocity().x, -self.body->GetLinearVelocity().y),self.body->GetWorldCenter());
    
    weapon.body->SetTransform(weapon.body->GetWorldCenter(),SJ_PI_X_2/4 + angleBetweenPoints([Helper toPixels:body->GetWorldCenter()],[Helper toPixels:localSoldier.body->GetWorldCenter()]));
    
	aiState-=0.01;
	//CCLOG(@""
}
-(void)chasePlayer{
	if ([path count]==0 && hasClearShot==NO && pathExists ==YES) {
		performedCreatePath = NO;
		pathDone = NO;
		pathExists = NO;
	}
	
	if (performedCreatePath == NO) {
		
		performedCreatePath = YES;
        pathDone = NO;
		//[self performSelectorInBackground:@selector(createPath) withObject:nil];
		[pathFinder createPath:[Helper toPixels:body->GetWorldCenter()] Goal:[Helper toPixels:localSoldier.body->GetWorldCenter()]];
		/*NSMutableArray * tempPath = [pathFinder createPath:[Helper toPixels:self.body->GetWorldCenter()] Goal:[Helper toPixels:localSoldier.body->GetWorldCenter()]];
		CCLOG(@"tempPathCount = %i",[tempPath count]);
		[path release];
		path = tempPath;
		pathDone = YES;
		if ([path count]>0) {
			pathExists = YES;
			CCLOG(@"path exists");
		}else {
			pathExists = NO;
			CCLOG(@"path doesn't exist");
		}
		 
		//[self createPath];
		 */
	}
    if (performedCreatePath == YES && pathDone == NO){
        [self patrol];
    }
	if (pathDone && [path count]>0) {
        if (pathExists==YES) {
            
        
		//move along path	
		ShortestPathStep * currentPFP = [path objectAtIndex:0];
		NSAssert(currentPFP!=nil, @"currentPFP=nil");
		CGPoint nextPathPoint = currentPFP.position;
        CGPoint selfBodyPos = [Helper toPixels:body->GetWorldCenter()];
		float offsetX = nextPathPoint.x - selfBodyPos.x;
		float offsetY = nextPathPoint.y - selfBodyPos.y;
		//while (abs(offsetX>0.2) || abs(offsetY>0.2)) {
        //    offsetX /= 5;
        //    offsetY /= 5;
        //    //CCLOG(@"decreasing");
        //}
        
        
        
		CGPoint forceCG = ccp(offsetX*movementSpeed*2,offsetY*movementSpeed*2);
		forceCG.x *= kSpeedFactor;
		forceCG.y *= kSpeedFactor;
		
		//angle calculations for jet pack
		CGPoint v1 = [Helper toPixels:body->GetWorldCenter()];
		CGPoint v2 = [Helper toPixels:body->GetWorldCenter()];
		v2.x += forceCG.x;
		v2.y += forceCG.y;
		
		//float angle = atan2f(forceCG.y, forceCG.x); // in radians
		float angle = atan2f(v1.x-v2.x, v2.y-v1.y);
		if(angle < 0){
			angle		+= SJ_PI_X_2;
		}
		float degrees = CC_RADIANS_TO_DEGREES(angle);
		
		b2Vec2 force = [Helper toMeters:forceCG];
		force.Normalize();
		body->ApplyForce(force,body->GetWorldCenter());
		
		float distanceFromDest = ccpDistance([Helper toPixels:body->GetWorldCenter()], nextPathPoint);
		if (distanceFromDest<longestBodyLength) {
			[path removeObjectAtIndex:0];
        }
		//CCLOG(@"chasing player");
				
		jetPack.fakeParentPos = [Helper toPixels:body->GetWorldCenter()];
		jetPack.angle = degrees+270; //180
		[self.jetPack emit];
		
		}else{
			
		
			
			//fire at player
			//CCLOG(@"ai in the way");
			RaysCastCallback callback;
			[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, self.body->GetWorldCenter(), localSoldier.body->GetWorldCenter());
			
			if (callback.m_fixture) {
				b2Body * fixtureBody = callback.m_fixture->GetBody();
				BodyNode * curUserData = (BodyNode*)fixtureBody->GetUserData();
				if ([curUserData isKindOfClass:[BaseAI class]] || curUserData.userData == kBodyTypeHead) {
					//CCLOG(@"ai in the way");
                    aiState -= 0.1;
                    //[self patrol];
					return;
				}
				if ([curUserData isKindOfClass:[BaseLevelObject class]]) {
                    BaseLevelObject * castUserData = (BaseLevelObject*)curUserData;
					if (castUserData.destructible == NO || castUserData.takesDamageFromBullets==NO) {
                       // CCLOG(@"ai in the way");
                        aiState -= 0.1;
                        //[self patrol];
						return;
					}
				}
			}
			
			
			CGPoint selfPos = [Helper toPixels:body->GetWorldCenter()];
            CGPoint soldierPos = [Helper toPixels:localSoldier.body->GetWorldCenter()];
            float offsetX = selfPos.x - soldierPos.x;
            float offsetY = selfPos.y - soldierPos.y;
            
            /*while (abs(offsetX>0.2) || abs(offsetY>0.2)) {
             offsetX /= 5;
             offsetY /= 5;
             //CCLOG(@"decreasing");
             }
             */
            
            CGPoint forceCG = ccp(-offsetX,-offsetY);
            forceCG = ccpNormalize(forceCG);
            
            CGPoint v1 = selfPos;
            CGPoint v2 = selfPos;
            v2.x += forceCG.x;
            v2.y += forceCG.y;
            
            //selfPos.x+=(forceCG.x/50);
            //selfPos.y+=(forceCG.y/50);
            
            //float angle = atan2f(forceCG.y, forceCG.x); // in radians
            float angle = atan2f(v1.x-v2.x, v2.y-v1.y);
            if(angle < 0){
                angle		+= SJ_PI_X_2;
            }
            float degrees = CC_RADIANS_TO_DEGREES(angle);
            degrees +=90;
            
            
            
            [weapon fireBulletWithVelocity:forceCG bulletDegrees:degrees world:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:selfPos gunman:self];		
        }

		
	}

}
-(void)createPath{
	[pathFinder createPath:[Helper toPixels:self.body->GetWorldCenter()] Goal:[Helper toPixels:localSoldier.body->GetWorldCenter()]]; 
}
-(void)engage{
	//CCLOG(@"engaged");
	//float distanceFromSoldier = ccpDistance(self.sprite.position, localSoldier.sprite.position);
	if (hasClearShot == YES) {
        
        [self patrol];
		/*RaysCastCallback callback;
		[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, self.body->GetWorldCenter(), localSoldier.body->GetWorldCenter());
		
		if (callback.m_fixture) {
			b2Body * fixtureBody = callback.m_fixture->GetBody();
			BodyNode * curUserData = (BodyNode*)fixtureBody->GetUserData();
			if ([curUserData isKindOfClass:[BaseAI class]] || curUserData.userData == kBodyTypeHead) {
				//CCLOG(@"ai in the way");
				return;
			}
			if ([curUserData isKindOfClass:[BaseLevelObject class]]) {
				if (((BaseLevelObject*)curUserData).destructible == NO) {
					return;
				}
			}
		}
		*/
		
		CGPoint selfPos = [Helper toPixels:body->GetWorldCenter()];
		CGPoint soldierPos = [Helper toPixels:localSoldier.body->GetWorldCenter()];
		float offsetX = selfPos.x - soldierPos.x;
		float offsetY = selfPos.y - soldierPos.y;
		
		/*while (abs(offsetX>0.2) || abs(offsetY>0.2)) {
			offsetX /= 5;
			offsetY /= 5;
			//CCLOG(@"decreasing");
		}
         */
		
		CGPoint forceCG = ccp(-offsetX,-offsetY);
		forceCG = ccpNormalize(forceCG);
        
		CGPoint v1 = selfPos;
		CGPoint v2 = selfPos;
		v2.x += forceCG.x;
		v2.y += forceCG.y;
		
		//selfPos.x+=(forceCG.x/50);
		//selfPos.y+=(forceCG.y/50);
		
		//float angle = atan2f(forceCG.y, forceCG.x); // in radians
		float angle = atan2f(v1.x-v2.x, v2.y-v1.y);
		if(angle < 0){
			angle		+= SJ_PI_X_2;
		}
		float degrees = CC_RADIANS_TO_DEGREES(angle);
		degrees +=90;
		
		
		
		[weapon fireBulletWithVelocity:forceCG bulletDegrees:degrees world:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:selfPos gunman:self];
		
	}else {
		[self chasePlayer];
	}

	
}
-(void)die{
	if (dead) {
		return;
	}
	//[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self]; 
	
	[[[HelloWorldLayer sharedHelloWorldLayer]getGameController]addPointsToScore:killReward Location:self.sprite.position Prefix:@"kill"];
	[self unschedule:@selector(Update:)];
	//weapon.canShoot = NO;
	dead = YES;
	deathSFX.position = super.sprite.position;
	[deathSFX play];
	CCParticleSystem * deathParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:deathExplosion];
	deathParticle.autoRemoveOnFinish = YES;
	deathParticle.position = [Helper toPixels:self.body->GetWorldCenter()];
    self.weapon.hasCarrier = NO;
	//self.weapon.muzzleFlash.visible = NO;
	//self.weapon.isFiring=NO;
	//[deathSFX play];
	
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:deathParticle];
	
	if (headBodyNode) {
		headBodyNode.shouldDelete = YES;
	}
	
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"weaponFired"];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"bulletHit"];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
    
	//self.weapon.muzzleFlash.visible = NO;
	//[[DeletionManager sharedDeletionManager]addObjectForDeletion:self];
	//[pathFinder release];
	self.shouldDelete = YES;
	//[self performSelector:@selector(clean) withObject:nil afterDelay:0.2f];
	
		
}
-(void)bleedOut{
	float offsetX = nextDest.x - [Helper toPixels:self.body->GetWorldCenter()].x;
	float offsetY = nextDest.y - [Helper toPixels:self.body->GetWorldCenter()].y;
	offsetX /= screenSize.width/480;
	offsetY /= screenSize.height/320;
	CGPoint forceCG = ccp(offsetX*movementSpeed,offsetY*movementSpeed);
	forceCG.x *= kSpeedFactor*10;
	forceCG.y *= kSpeedFactor*10;
	
	//angle calculations for jet pack
	CGPoint v1 = [Helper toPixels:self.body->GetWorldCenter()];
	CGPoint v2 = [Helper toPixels:self.body->GetWorldCenter()];
	v2.x += forceCG.x;
	v2.y += forceCG.y;
	
	//float angle = atan2f(forceCG.y, forceCG.x); // in radians
	float angle = atan2f(v1.x-v2.x, v2.y-v1.y);
	if(angle < 0){
		angle		+= SJ_PI_X_2;
	}
	float degrees = CC_RADIANS_TO_DEGREES(angle);
	
	b2Vec2 force = [Helper toMeters:forceCG];
	force.Normalize();
	CGPoint forceLoc = [Helper toPixels:self.body->GetWorldCenter()];
	float varianceX = selfSize.width/2;
	float varianceY = selfSize.height/2;
	varianceX*=CCRANDOM_MINUS1_1();
	varianceY*=CCRANDOM_MINUS1_1();
	forceLoc.x +=varianceX;
	forceLoc.y +=varianceY;
	
	b2Vec2 realForceLoc = [Helper toMeters:forceLoc];
	
	self.body->ApplyForce(force,realForceLoc);
	float distanceFromDest = ccpDistance([Helper toPixels:self.body->GetWorldCenter()], nextDest);
	
	CGPoint selfPos = [Helper toPixels:self.body->GetWorldCenter()];
	
	if (distanceFromDest<longestBodyLength) {
		
		selfPos.x -= patrolRadius/2;
		selfPos.y -= patrolRadius/2;
		nextDest = ccp((arc4random()%(int)patrolRadius) + lowerX, (arc4random()%(int)patrolRadius) + lowerY);
	}
		
	self.jetPack.fakeParentPos = [Helper toPixels:self.body->GetWorldCenter()];
	self.jetPack.angle = degrees+270; //180
	[self.jetPack emit];
	
	/*CCParticleSystem * bleedOutParticle = (CCParticleSystem*)[self getChildByTag:11];
	bleedOutParticle.angle = CC_RADIANS_TO_DEGREES(super.body->GetAngle());
	CGPoint sp2 = [Helper toPixels:self.body->GetWorldCenter()];
	bleedOutParticle.position = ccp(sp2.x + selfSize.width/2,sp2.y + selfSize.height/1.5);
	 */
	self.health-=bleedOutRate;
}
-(void)headPoppedOff{
	if (headAttached==YES) {
		CCParticleSystem * squirtParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:headPoppedOffParticle];
		squirtParticle.tag = 11;
		squirtParticle.position = ccp(selfSize.width/2,selfSize.height/1.5);
		squirtParticle.rotation = -90; //-90 next
		//squirtParticle.rotation = CC_RADIANS_TO_DEGREES(super.body->GetAngle());
		//change particle. Make it more random, faster, and shorter lifespan to make rotation less obvios. Set starting rotation to 0
		//squirtParticle.positionType = kCCPositionTypeFree;
		[super.sprite addChild:squirtParticle];
		headBodyNode.shouldRemoveJoints = YES;
		[[[HelloWorldLayer sharedHelloWorldLayer]getGameController]addPointsToScore:headshotReward Location:headBodyNode.sprite.position Prefix:@"Headshot"];		
		//destroy headBodyNode joints
		//[self schedule:@selector(bleedOut:)];
		//aiState = -1000;
	}
	
	headAttached = NO;
}
-(void)clean{
	
}
#pragma mark events
-(void)onAIHit:(CGPoint)pos Damage:(float)damage{
    self.health -= damage;
	
	NSAssert(blood!=nil, @"please specify a blood file for ai");
	
	CCParticleSystem * bloodParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:blood];
	if (bloodColor.r !=0 || bloodColor.g !=0 || bloodColor.b != 0) {
		bloodParticle.startColor = ccc4FFromccc3B(bloodColor);
		bloodParticle.endColor = ccc4FFromccc3B(bloodColor);
	}
	bloodParticle.autoRemoveOnFinish = YES;
	CGPoint averagedPos;
	averagedPos.x = (pos.x+[Helper toPixels:self.body->GetWorldCenter()].x)/2;
	averagedPos.y = (pos.y+[Helper toPixels:self.body->GetWorldCenter()].y)/2;
	bloodParticle.position = pos;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:bloodParticle];
}
-(void)onAIHit:(CGPoint)pos bullet:(Bullet*)curBullet{
	//CGPoint selfPos = [Helper toPixels:self.body->GetWorldCenter()];
	//CGPoint offset = ccp(selfPos.x -pos.x,selfPos.y - pos.y);
	//pos.x = pos.x + offset.x;
	//pos.y = pos.y + offset.y;
	self.health = self.health - curBullet.damage;
	
	NSAssert(blood!=nil, @"please specify a blood file for ai");
	
	CCParticleSystem * bloodParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:blood];
	if (bloodColor.r !=0 || bloodColor.g !=0 || bloodColor.b != 0) {
		bloodParticle.startColor = ccc4FFromccc3B(bloodColor);
		bloodParticle.endColor = ccc4FFromccc3B(bloodColor);
	}
	bloodParticle.autoRemoveOnFinish = YES;
	CGPoint averagedPos;
	averagedPos.x = (pos.x+[Helper toPixels:self.body->GetWorldCenter()].x)/2;
	averagedPos.y = (pos.y+[Helper toPixels:self.body->GetWorldCenter()].y)/2;
	bloodParticle.position = pos;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:bloodParticle];
	/*if (health<=curBullet.damage) {
		[deathSFX play];
	}
	 */
	
}
-(void)onHeadShot:(CGPoint)pos bullet:(Bullet*)curBullet{
	self.headHealth-=curBullet.damage;
	//CCLOG(@"curBullet.damage = %f headHealth = %f",curBullet.damage, self.headHealth);
	//CCLOG(@"on head shot");
	
	NSAssert(blood!=nil, @"please specify a blood file for ai");
	
	CCParticleSystem * bloodParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:blood];
	if (bloodColor.r !=0 || bloodColor.g !=0 || bloodColor.b != 0) {
		bloodParticle.startColor = ccc4FFromccc3B(bloodColor);
		bloodParticle.endColor = ccc4FFromccc3B(bloodColor);
	}
	
	bloodParticle.autoRemoveOnFinish = YES;
	CGPoint averagedPos;
	averagedPos.x = (pos.x+[Helper toPixels:self.body->GetWorldCenter()].x)/2;
	averagedPos.y = (pos.y+[Helper toPixels:self.body->GetWorldCenter()].y)/2;
	bloodParticle.position = pos;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:bloodParticle];
	
	
}

-(void)onHeadShot:(CGPoint)pos Damage:(float)damage{
    self.headHealth-=damage;
	//CCLOG(@"curBullet.damage = %f headHealth = %f",curBullet.damage, self.headHealth);
	//CCLOG(@"on head shot");
	
	NSAssert(blood!=nil, @"please specify a blood file for ai");
	
	CCParticleSystem * bloodParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:blood];
	if (bloodColor.r !=0 || bloodColor.g !=0 || bloodColor.b != 0) {
		bloodParticle.startColor = ccc4FFromccc3B(bloodColor);
		bloodParticle.endColor = ccc4FFromccc3B(bloodColor);
	}
	
	bloodParticle.autoRemoveOnFinish = YES;
	CGPoint averagedPos;
	averagedPos.x = (pos.x+[Helper toPixels:self.body->GetWorldCenter()].x)/2;
	averagedPos.y = (pos.y+[Helper toPixels:self.body->GetWorldCenter()].y)/2;
	bloodParticle.position = pos;
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:bloodParticle];

}

-(void)setHealth:(float)newHealth{
	health = newHealth;
	if (health<=0) {
		[self die];
	}
}
-(void)setHeadHealth:(float)newHH{
	headHealth = newHH;
	if (headHealth<=0) {
		[self headPoppedOff];
		//CCLOG(@"head health hit zero");
	}
	
}
-(void)onWeaponFired:(CGPoint)velocity bulletDegrees:(CGFloat)degrees{
    
	CGPoint soldierPos = [Helper toPixels:localSoldier.body->GetWorldCenter()];
	float distanceFromShot = ccpDistance(soldierPos, [Helper toPixels:self.body->GetWorldCenter()]);
    RaysCastCallback callback;
	[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, self.body->GetWorldCenter(), localSoldier.body->GetWorldCenter());
	if (callback.m_fixture) {
        if (aiState>1 && aiState<=5) {
            aiState += hearingRange/distanceFromShot/2;
        }else {
            aiState += hearingRange/distanceFromShot/4;
        }

    }else{
	//distanceFromShot *= screenSize.width/480;
	//distanceFromShot = distanceFromShot ;
        if (aiState>1 && aiState<=5) {
            aiState += hearingRange/distanceFromShot * 2;
        }else {
            aiState += hearingRange/distanceFromShot;
        }

	}
}
-(void)rotateGunToAngle:(float)angle{
	weapon.body->SetTransform(weapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((weapon.recoil * CCRANDOM_0_1())*2)+angle));
}
-(void)rotateGunToAngle:(float)angle shaking:(BOOL)shaking{
	//CCLOG(@"angle in ai set gun angle = %f",angle); 
	if ([[HelloWorldLayer sharedHelloWorldLayer]getWorld]->IsLocked()) {
		return;
	}
	if (shaking) {
		weapon.body->SetTransform(weapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(((weapon.recoil * CCRANDOM_0_1())*2)+angle));
	}else {
		weapon.body->SetTransform(weapon.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(angle));
	}

}
-(void)onBulletHit:(id)bullet position:(CGPoint)pos{
   
    
	float distanceFromShot = ccpDistance(pos, [Helper toPixels:self.body->GetWorldCenter()]);
	//distanceFromHit *=screenSize.width/480;
	
    RaysCastCallback callback;
	[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, self.body->GetWorldCenter(), [Helper toMeters:pos]);
	if (callback.m_fixture) 
    {
        if (aiState>1 && aiState<=5) {
            aiState += hearingRange/distanceFromShot/2;
            aiState += sightRange/distanceFromShot/4;
        }else {
            aiState += hearingRange/distanceFromShot*2;
            aiState += sightRange/distanceFromShot;
            
        }	

    }else{

    
        if (aiState>1 && aiState<=5) {
            aiState += hearingRange/distanceFromShot* 2;
            aiState += sightRange/distanceFromShot * 2;
        }else {
            aiState += hearingRange/distanceFromShot;
            aiState += sightRange/distanceFromShot;

        }	
	}
	
}

-(BOOL)isWall:(CGPoint)point parent:(ShortestPathStep*)curParent{
	if (hasDealloced) {
		return YES;
	}
    //if (curParent == nil) {
      //  return NO;
    //}
	RaysCastCallback callback;
   // if(curParent.position.x!=point.x&&curParent.position.y!=point.y){
    b2Vec2 p1 = [Helper toMeters:point];
    b2Vec2 p2 = [Helper toMeters:curParent.position];
    [[HelloWorldLayer sharedHelloWorldLayer]getWorld]->RayCast(&callback, p1, p2);
    //}
	if (callback.m_fixture==nil || callback.m_fixture == self.body->GetFixtureList()) {
		return NO;
	}else {
		return YES;
	}

	//return NO;
	//[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->																	   
}
-(BOOL)checkBounds:(CGPoint)point{
    if (hasDealloced || longestBodyLength==0.0f) {
        return NO;
    }
    b2Vec2 vecPoint = [Helper toMeters:point];
    b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
    
    for (float i = -0.5f; i<=0.5f; i+=0.25f) {
        for (float j = -0.5f; j<=0.5f; j+=0.25f) {
            if (i==0.0f && j==0.0f) {
                continue;
            }
            CGPoint curCast = ccp(point.x + longestBodyLength*i, point.y + longestBodyLength * j);
            b2Vec2 vecCast = [Helper toMeters:curCast];
            RaysCastCallback callback;
            world->RayCast(&callback, vecPoint, vecCast);
            
            if (callback.m_fixture!=nil) {
                if (callback.m_fixture->GetFilterData().groupIndex!=globalIdtt) {
                    return NO;
                }
                
            }

            
        }
        
    }
    return YES;
    /*CGPoint cast1 = ccp(point.x-longestBodyLength,point.y);
	CGPoint cast2 = ccp(point.x-longestBodyLength/2,point.y-longestBodyLength/2);
	CGPoint cast3 = ccp(point.x,point.y-longestBodyLength);
	CGPoint cast4 = ccp(point.x+longestBodyLength/2,point.y-longestBodyLength/2);
	CGPoint cast5 = ccp(point.x+longestBodyLength,point.y);
	CGPoint cast6 = ccp(point.x+longestBodyLength/2,point.y+longestBodyLength/2);
	CGPoint cast7 = ccp(point.x,point.y+longestBodyLength);
	CGPoint cast8 = ccp(point.x-longestBodyLength/2,point.y+longestBodyLength/2);
     */
   /* return YES;
    
	b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
	MyQueryCallback callback;
	//b2PolygonShape shape;
   // shape.SetAsBox(longestBodyLength*2,longestBodyLength*2);
   // b2Transform transform;
   // transform.Set([Helper toMeters:point], 0);
    b2AABB aabb;
	aabb.lowerBound.Set(point.x-longestBodyLength/2,point.y-longestBodyLength/2);
	aabb.upperBound.Set(point.x+longestBodyLength/2,point.y + longestBodyLength/2);
	world->QueryAABB(&callback, aabb);
  
	BOOL valid = YES;
	for (int n = 0; n < callback.foundBodies.size(); n++) {
		b2Body * curBody = callback.foundBodies[n];
		if (curBody->GetFixtureList()->GetFilterData().groupIndex != -8 && curBody->GetFixtureList()!=self.body->GetFixtureList()) {
            if (ccpDistance(point, [Helper toPixels:curBody->GetWorldCenter()])<longestBodyLength) {
                valid = NO;
            }
			
		}
	}
	return valid;
    */
}
-(void)onPathDone:(NSMutableArray*)tempPath{
	CCLOG(@"tempPathCount = %i",[tempPath count]);
	[path release];
	path = tempPath;
	pathDone = YES;
	pathExists = YES;
	//[self createPath];
	
}
- (void)onPathNotFound{
	pathDone = YES;
	pathExists = NO; //handle path not found. Currently, AI just stops. 
    [path release];
    path = [[NSMutableArray array]retain];
    [path addObject:[NSNumber numberWithInt:0]];
}
-(void)dealloc{
    if (hasDealloced==YES){
        return;
    }
	hasDealloced = YES;
	//[[NSRunLoop currentRunLoop]cancelPerformSelectorsWithTarget:self];
	[jetPack release];
	
	[path release];
    //[pathFinder release];
	//if (pathFinder) {
	//	[pathFinder release];
	//}
	
	[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"weaponFired"];
    [[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"bulletHit"];
    //[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
    
	
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"weaponFired"];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"bulletHit"];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
	[super dealloc];
}
@end
