//
//  ElectricArc.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElectricArc.h"
#import "Helper.h"
#import "Options.h"
#import "EventBus.h"
#import "Soldier.h"
#import "ElectricEnd.h"
#import "BaseAI.h"
#import "RaysCastCallback.h"
@implementation ElectricArc
-(id)initWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius{
	if ((self = [super init])) {
		/*top = [[BaseLevelObject alloc]init];
		bottom = [[BaseLevelObject alloc]init];
		pos1 = [Helper relativePointFromPoint:pos1];
		pos2 = [Helper relativePointFromPoint:pos2];
		radius = [[Options sharedOptions]makeAverageConstantRelative:radius];
		globalRadius = radius;
		*/
        
        
		_world = world;
		globalRadius = radius;
		_pos1 = pos1;
        _pos2 = pos2;
        _radius = radius;
        pos1 = [Helper relativePointFromPoint:pos1];
        pos2 = [Helper relativePointFromPoint:pos2];
        radius = [[Options sharedOptions]makeAverageConstantRelative:radius];
        
		/*
		top.health = radius*radius/2;
		top.destructible = YES;
		top.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ElectricEndDestructionParticle.plist"]; 
		top.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		top.contactColor = ccc3(0, 100, 0);
		top.dimensions = CGSizeMake(radius*2, radius*2); 
		
		bottom.health = radius*radius/2;
		bottom.destructible = YES;
		bottom.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ElectricEndDestructionParticle.plist"]; 
		bottom.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		bottom.contactColor = ccc3(0, 100, 0);
		bottom.dimensions = CGSizeMake(radius*2, radius*2); 
		//remember you are tying to create a body in between the two points to act as a bouncy reflector thing that injures player. High restitution. Filter should ignore bullets
		top = [ElectricEnd electricEndWithWorld:world Position:pos1 Radius:radius Range:70 Enabled:NO FileName:@"electricEndSmall.png"];
		bottom = [ElectricEnd electricEndWithWorld:world Position:pos2 Radius:radius Range:70 Enabled:NO FileName:@"electricEndSmall.png"];
		top.destructionListener = self;
		bottom.destructionListener = self;
        
        */
		/*b2Body*topBody=[top createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
		bodyDef.position = [Helper toMeters:pos2];
		b2Body*bottomBody=[bottom createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
		 */
        
		//b2DistanceJointDef jd;
		//jd.Initialize(top.body,bottom.body,top.body->GetWorldCenter(),bottom.body->GetWorldCenter());
		//world->CreateJoint(&jd);
		
        top = [ElectricEnd electricEndWithWorld:world Position:_pos1 Radius:_radius Range:70 Enabled:NO FileName:@"electricEndSmall.png"];
		bottom = [ElectricEnd electricEndWithWorld:world Position:_pos2 Radius:_radius Range:70 Enabled:NO FileName:@"electricEndSmall.png"];
		top.destructionListener = [self retain];
		bottom.destructionListener = [self retain];
        
		[[HelloWorldLayer sharedHelloWorldLayer]addChild:top];
		[[HelloWorldLayer sharedHelloWorldLayer]addChild:bottom];
		
		//[[HelloWorldLayer sharedHelloWorldLayer]reorderChild:top.sprite z:1];
		//[[HelloWorldLayer sharedHelloWorldLayer]reorderChild:bottom.sprite z:1];
		
				
		float angle = atan2f(pos1.x-pos2.x, pos2.y-pos1.y);
		if(angle < 0){
			angle+= SJ_PI_X_2;
		}
		CGPoint midPoint = ccpMidpoint(pos1, pos2);
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:midPoint]);
		bodyDef.angularDamping = 0.1f;
		bodyDef.linearDamping = 0.1f;
		bodyDef.angle = angle;
        
		float distance = ccpDistance(pos1, pos2);
		b2PolygonShape shape;
		//b2CircleShape shape;
        //CCLOG(@"ptm ration = %i",PTM_RATIO); correct
		shape.SetAsBox((radius/2)/PTM_RATIO, ((distance/PTM_RATIO)-((radius*8)/PTM_RATIO)));
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.1f;
		fixtureDef.restitution = 1.5f;
		fixtureDef.filter.categoryBits = CATEGORY_WEAPON;
		fixtureDef.filter.maskBits = MASK_WEAPON;
        
		BodyNode * creator = [[BodyNode alloc]init];
		b2Body * barrier = [creator createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:nil];
        creator.userData = kBodyTypeElectricArc;
        b2RevoluteJointDef jd;
        
		jd.enableLimit = FALSE;
		jd.Initialize(barrier,top.body,top.body->GetWorldCenter());
		world->CreateJoint(&jd);
		jd.Initialize(barrier,bottom.body,bottom.body->GetWorldCenter());
		world->CreateJoint(&jd);
		//[[HelloWorldLayer sharedHelloWorldLayer]addChild:creator];
        [self addChild:creator z:0 tag:1];
		[creator release];
		//CCLOG(@"creator retain count = %i",[creator retainCount]); 1
		//[top release];
		//[bottom release];
        
        buzz = [CDXAudioNode audioNodeWithFile:@"electricBuzz.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        buzz.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        buzz.playMode = kAudioNodeLoop;
        [[HelloWorldLayer sharedHelloWorldLayer] addChild:buzz];
        [buzz play];
        localSoldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
        [self schedule:@selector(Update:)];
        //[self schedule:@selector(checkIntersection:)];

	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval1 = [NSValue valueWithCGPoint:_pos1];//[Helper toPixels:top.body->GetWorldCenter()]];
    NSValue * pval2 = [NSValue valueWithCGPoint:_pos2];//[Helper toPixels:bottom.body->GetWorldCenter()]];
    NSNumber * radius = [NSNumber numberWithFloat:_radius];
    [aCoder encodeObject:pval1 forKey:@"pval1"];
    [aCoder encodeObject:pval2 forKey:@"pval2"];
    [aCoder encodeObject:radius forKey:@"radius"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval1 = [aDecoder decodeObjectForKey:@"pval1"];
    NSValue * pval2 = [aDecoder decodeObjectForKey:@"pval2"];
    NSNumber * radius = [aDecoder decodeObjectForKey:@"radius"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position1:[pval1 CGPointValue] Position2:[pval2 CGPointValue] Radius:radius.floatValue];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
-(void)onObjectDestroyed:(BodyNode*)obj{
	if (obj == top) {
		top = nil;
	}
	if (obj == bottom) {
		bottom = nil;
	}
	[[HelloWorldLayer sharedHelloWorldLayer]removeChild:buzz cleanup:YES];
   // [[HelloWorldLayer sharedHelloWorldLayer]removeChild:creator cleanup:YES];
    //[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->DestroyBody(creator.body);
    BodyNode * toDelete = (BodyNode*)[self getChildByTag:1];
    toDelete.shouldDelete = YES;
    [self release];
    
    if (top==nil && bottom==nil){
        [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]removeChild:self cleanup:YES];
    }
        //[creator release];
}
-(void)checkIntersection:(ccTime)delta{
	if (top == nil || bottom==nil) {
		return;
	}
	CGPoint topPos = [Helper toPixels:top.body->GetWorldCenter()];
	CGPoint bottomPos = [Helper toPixels:bottom.body->GetWorldCenter()];
    //if (bottomPos.x == topPos.x && bottomPos.y == topPos.y) {
    //    return;
   // }
	RaysCastCallback callback;
	callback.allIntersections = YES;
	_world->RayCast(&callback, [Helper toMeters:topPos], [Helper toMeters:bottomPos]); //too short
	for (int n = 0; n < callback.foundBodies.size(); n++) {
		//CCLOG(@"iterating through found bodies in electric arc");
        if (top == nil || bottom == nil) {
            break;
        }
		b2Body * curBody = callback.foundBodies[n];
		if (curBody->GetFixtureList()==top.body->GetFixtureList() || curBody->GetFixtureList()==bottom.body->GetFixtureList()) {
			return;
		}
		BodyNode * bn = (BodyNode*)curBody->GetUserData();
		if (curBody->GetFixtureList()->GetFilterData().groupIndex == -8) {
			localSoldier.health-=kElectricArcDamage; 
		}
		if ([bn isKindOfClass:[BaseAI class]]) {
			((BaseAI*)bn).health-=kElectricArcDamage;
		}
		if ([bn isKindOfClass:[BaseLevelObject class]]) {
			((BaseLevelObject*)bn).health-=kElectricArcDamage;
		}
		
	}
	
}
-(void)draw{
    if (top == nil || bottom==nil) {
		return;
	}
    //check to see if this is drawing, then fix all the z orders of things. Make score plusses and particle systems render on top of the sprite batch. Edit the zindex of the sprite batch first before editing everything else
    
	glEnable(GL_LINE_SMOOTH);
     //glEnable(GL_BLEND);
     glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
     
     float blue = CCRANDOM_0_1();
     float RedandGreen = CCRANDOM_0_1();
     float opacity = CCRANDOM_0_1();
     
     glColor4f(RedandGreen, RedandGreen, blue, opacity);
     
     CGPoint startPos;
     CGPoint endPos;
     
	CGPoint topPos = [Helper toPixels:top.body->GetWorldCenter()];
	CGPoint bottomPos = [Helper toPixels:bottom.body->GetWorldCenter()]; 
    
     for (int b = 0; b<7; b++) {
     float lineWidth = CCRANDOM_0_1()+0.7f;
     glLineWidth(lineWidth);
     startPos.x = (CCRANDOM_MINUS1_1()*globalRadius) + topPos.x;
     startPos.y = (CCRANDOM_MINUS1_1()*globalRadius) + topPos.y;
     endPos.x = (CCRANDOM_MINUS1_1()*globalRadius) + bottomPos.x;
     endPos.y = (CCRANDOM_MINUS1_1()*globalRadius) + bottomPos.y;
     ccDrawLine(startPos, endPos);
     }
    glDisable(GL_LINE_SMOOTH);
    CC_ENABLE_DEFAULT_GL_STATES();
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    

}
-(void)Update:(ccTime)delta{
	if (top == nil || bottom==nil) {
		return;
	}
	/*glEnable(GL_LINE_SMOOTH);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	float blue = CCRANDOM_0_1();
	float RedandGreen = CCRANDOM_0_1();
	float opacity = CCRANDOM_0_1();
	
	glColor4f(RedandGreen, RedandGreen, blue, opacity);
	
	CGPoint startPos;
	CGPoint endPos;
     */
	CGPoint topPos = [Helper toPixels:top.body->GetWorldCenter()];
	CGPoint bottomPos = [Helper toPixels:bottom.body->GetWorldCenter()];
    _pos1 = topPos;
    _pos2 = bottomPos;
    /*
	for (int b = 0; b<7; b++) {
		float lineWidth = CCRANDOM_0_1()+0.7f;
		glLineWidth(lineWidth);
		startPos.x = (CCRANDOM_MINUS1_1()*globalRadius) + topPos.x;
		startPos.y = (CCRANDOM_MINUS1_1()*globalRadius) + topPos.y;
		endPos.x = (CCRANDOM_MINUS1_1()*globalRadius) + bottomPos.x;
		endPos.y = (CCRANDOM_MINUS1_1()*globalRadius) + bottomPos.y;
		ccDrawLine(startPos, endPos);
	}
    */ 
	
	//if (topPos.x==bottomPos.x && topPos.y==bottomPos.y) {
	//	return;
	//}
	buzz.position = ccpMidpoint(topPos, bottomPos);
	/*
	RaysCastCallback callback;
	callback.allIntersections = YES;
	_world->RayCast(&callback, [Helper toMeters:topPos], [Helper toMeters:bottomPos]); //too short
	for (int n = 0; n < callback.foundBodies.size(); n++) {
		//CCLOG(@"iterating through found bodies in electric arc");
		b2Body * curBody = callback.foundBodies[n];
		if (curBody->GetFixtureList()==top.body->GetFixtureList() || curBody->GetFixtureList()==bottom.body->GetFixtureList()) {
			return;
		}
		BodyNode * bn = (BodyNode*)curBody->GetUserData();
		if (curBody->GetFixtureList()->GetFilterData().groupIndex == -8) {
			localSoldier.health-=kElectricArcDamage; 
		}
		if ([bn isKindOfClass:[BaseAI class]]) {
			((BaseAI*)bn).health-=kElectricArcDamage;
		}
		if ([bn isKindOfClass:[BaseLevelObject class]]) {
			((BaseLevelObject*)bn).health-=kElectricArcDamage;
		}
		
	}
	*/
	
	/*
	MyQueryCallback callback;
	b2AABB aabb;
	CGPoint upperBound;
	CGPoint lowerBound;
	if (topPos.y>bottomPos.y) {
		lowerBound = ccp(topPos.x-(globalRadius/2),topPos.y+(globalRadius/2));
		upperBound = ccp(bottomPos.x+(globalRadius/2),bottomPos.y-(globalRadius/2)); 
	}else {
		upperBound = ccp(topPos.x-(globalRadius/2),topPos.y+(globalRadius/2));
		lowerBound = ccp(bottomPos.x+(globalRadius/2),bottomPos.y-(globalRadius/2)); 
	}
	aabb.upperBound=[Helper toMeters:upperBound];
	aabb.lowerBound=[Helper toMeters:lowerBound];
	CGPoint upperBoundPoint = [Helper toPixels:aabb.upperBound];
	CGPoint lowerBoundPoint = [Helper toPixels:aabb.lowerBound];
	//CCLOG(@"upperBoundx =%f upperBound.y = %f lowerBound.x = %f lowerBound.y = %f",upperBoundPoint.x,upperBoundPoint.y,lowerBoundPoint.x,lowerBoundPoint.y);
	_world->QueryAABB(&callback, aabb);
	for (int n = 0; n < callback.foundBodies.size(); n++) {
		CCLOG(@"iterating through found bodies in electric arc");
		b2Body * curBody = callback.foundBodies[n];
		if (curBody->GetFixtureList()==top.body->GetFixtureList() || curBody->GetFixtureList()==bottom.body->GetFixtureList()) {
			return;
		}
		BodyNode * bn = (BodyNode*)curBody->GetUserData();
		if ([bn isKindOfClass:[Soldier class]]) {
			((Soldier*)bn).health-=kElectricArcDamage; //used to be 50
		}
		if ([bn isKindOfClass:[BaseAI class]]) {
			((BaseAI*)bn).health-=kElectricArcDamage;
		}
		if ([bn isKindOfClass:[BaseLevelObject class]]) {
			((BaseLevelObject*)bn).health-=kElectricArcDamage;
		}
		
	}
	// 
	CGPoint pos1 = top.sprite.position;
	CGPoint pos2 = bottom.sprite.position;
	float angle = atan2f(pos1.x-pos2.x, pos2.y-pos1.y);
	if(angle < 0){
		angle+= SJ_PI_X_2;
	}
	barrier->SetTransform([Helper toMeters:buzz.position],angle);
	 */
}
-(void)dealloc{
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
	[super dealloc];
}
+(id)electricArcWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius{
	return [[[self alloc]initWithWorld:world Position1:pos1 Position2:pos2 Radius:radius]autorelease];
}
@end
