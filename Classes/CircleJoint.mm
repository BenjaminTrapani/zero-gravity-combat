//
//  CircleJoint.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CircleJoint.h"
#import "Options.h"

@implementation CircleJoint
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius levelObject1:(BaseLevelObject*)Obj1 levelObject2:(BaseLevelObject*)Obj2{
	if ((self = [super init])) {
		_pos = pos;
        _radius = radius;
        _Obj1 = Obj1;
        _Obj2 = Obj2;
		pos = [Helper relativePointFromPoint:pos];
		radius = [[Options sharedOptions]makeAverageConstantRelative:radius];
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.1f;
		bodyDef.linearDamping = 0.1f;
		
		
		NSString * spriteFrameName = @"circleJointImage.png";
		
		//b2PolygonShape shape;
		b2CircleShape shape;
		
		shape.m_radius = radius/PTM_RATIO;
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.1f;
		fixtureDef.restitution = 0.5f;
		
		
		super.health = _radius*_radius/5;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"standardBlockDeath.plist"]; 
		super.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(0, 0, 250);
		super.dimensions = CGSizeMake(radius*2, radius*2); //doesn't really matter because this object won't copy.
		CGRect sizeRect = CGRectMake(0, 0, radius, radius);
		b2Body*center = [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
		b2RevoluteJointDef jd;
		jd.enableLimit = FALSE;
		jd.Initialize(center,Obj1.body,center->GetWorldCenter());
		world->CreateJoint(&jd);
		jd.Initialize(center,Obj2.body,center->GetWorldCenter());
		world->CreateJoint(&jd);
		//super.sprite.visible = NO;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * radius = [NSNumber numberWithFloat:_radius];
    NSString * obj1ID = _Obj1.uniqueID;
    NSString * obj2ID = _Obj2.uniqueID;
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:radius forKey:@"radius"];
    [aCoder encodeObject:obj1ID forKey:@"obj1ID"];
    [aCoder encodeObject:obj2ID forKey:@"obj2ID"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval = [aDecoder decodeObjectForKey:@"pval"];
    NSNumber * radius = [aDecoder decodeObjectForKey:@"radius"];
    NSString * obj1ID = [aDecoder decodeObjectForKey:@"obj1ID"];
    NSString * obj2ID = [aDecoder decodeObjectForKey:@"obj2ID"];
    //CCLOG(@"obj1ID = %@",obj1ID);
    //CCLOG(@"obj2ID = %@",obj2ID);
    BaseLevelObject * object1 = nil;
    BaseLevelObject * object2 = nil;
    CCArray * levelChildren = [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]children];
    for (CCNode * child in levelChildren){
        //CCLOG(@"nbodyID = %i",nbody->getBodyID());
        
        if ([child isKindOfClass:[BaseLevelObject class]]) {
            //CCLOG(@"child.uniqueID = %@",((BaseLevelObject*)child).uniqueID);
            if([((BaseLevelObject*)child).uniqueID isEqualToString:obj1ID]){
                object1 = (BaseLevelObject*)child;
            }
            if([((BaseLevelObject*)child).uniqueID isEqualToString:obj2ID]){
                object2 = (BaseLevelObject*)child;
            }

        }
    }
    //find a guid generator and make a property inside baseLevelObject. Set this property to the guid result and save the property in encodeWithCoder. On loading, set the object's property to the loaded property. In the load method for the dependant objects, loop through the children of the level until you find an object with the correct id and set it as the parameter.
    NSAssert(object1!=nil,@"Circle Joint failed to load connecting body 1");
    NSAssert(object2!=nil,@"Circle Joint failed to load connecting body 1");
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue] Radius:radius.floatValue levelObject1:object1 levelObject2:object2];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)jointWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius levelObject1:(BaseLevelObject*)Obj1 levelObject2:(BaseLevelObject*)Obj2{
	return [[[self alloc]initWithWorld:world Position:pos Radius:radius levelObject1:Obj1 levelObject2:Obj2]autorelease];
}

@end
