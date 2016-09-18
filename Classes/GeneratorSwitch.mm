//
//  GeneratorSwitch.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneratorSwitch.h"


@implementation GeneratorSwitch

-(id)initWithWorld:(b2World*)world position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)cdimensions Objects:(NSMutableArray*)objs Event:(SwitchEvent)event{
    if ((self = [super init])) {
        _pos = pos;
        _rotation = rotation;
        _dimensions = cdimensions;
        CCLOG(@"generator switch init dimensions = %f %f",cdimensions.width,cdimensions.height);
        //NSAssert([objs count]>0,@"empty array of subscribers sent to generator switch for init");
        pos = [Helper relativePointFromPoint:pos];
        b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		bodyDef.position = ([Helper toMeters:pos]);
		bodyDef.angularDamping = 0.9f;
		bodyDef.linearDamping = 0.9f;
		bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
		NSString * spriteFrameName = @"Generator.png";
		//CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		cdimensions = [Helper relativeSizeFromSize:cdimensions];
		CCLOG(@"generator switch relative dimensions = %f %f",cdimensions.width,cdimensions.height);
		//b2PolygonShape shape;
		b2PolygonShape shape;
		
		shape.SetAsBox(cdimensions.width / PTM_RATIO, cdimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 5.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect sizeRect = CGRectMake(0, 0, cdimensions.width, cdimensions.height);
		
		super.health = 0.1f * _dimensions.width*_dimensions.height;
		super.destructible = YES;
		super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"GeneratorShortCircuit.plist"]; 		
        super.destructionSound = [CDXAudioNode audioNodeWithFile:@"standardDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		super.contactColor = ccc3(100, 100, 100);
		super.explosive = YES;
		super.explosionForce = 1;
		super.explosionRange = 100;
		super.dimensions = cdimensions;
		super.takesDamageFromCollisions = NO;
        super.isSwitch = YES;
        super.switchSubscribers = objs;
        super.switchEvent = event;
                
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect];
        
        for(BaseLevelObject * curObj in objs) {
            curObj.destructionListener = self;
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetPosition()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    NSValue * dims = [NSValue valueWithCGSize:_dimensions];
    NSMutableArray * NswitchSubscribers = super.switchSubscribers;
    int switchEventType = super.switchEvent; 
    /*for (BaseLevelObject * subscriber in NswitchSubscribers) {
        NSNumber * curID = [NSNumber numberWithInt:subscriber.body->getBodyID()]; //this is getting skewed because sand bags aren't getting created. Fix those first.
        [ids addObject:curID];
    }
    */
    NSMutableArray * stringArray = [NSMutableArray array];
    int objectCount = [NswitchSubscribers count];
    for (int i = 0; i<objectCount; i++) {
        BodyNode * curSubscriber = (BodyNode*)[NswitchSubscribers objectAtIndex:i];
        NSString * curID = curSubscriber.uniqueID;
        //CCLOG(@"curID in generator switch = %@",curID);
        [stringArray addObject:curID];
    }
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:dims forKey:@"dims"];
    [aCoder encodeObject:stringArray forKey:@"ids"];
    [aCoder encodeInt:switchEventType forKey:@"switchEventType"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * pval = [aDecoder decodeObjectForKey:@"pval"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    NSValue * dims = [aDecoder decodeObjectForKey:@"dims"];
    NSMutableArray * ids = [aDecoder decodeObjectForKey:@"ids"];
    int switchEventType = [aDecoder decodeIntForKey:@"switchEventType"];

    NSMutableArray * subscribers = [NSMutableArray array];
    
    CCArray * levelChildren = [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]children];
    for (CCNode * child in levelChildren){
        for (NSString * string in ids) {
            //CCLOG(@"object id in generator switch = %@",string);
           // CCLOG(@"child id in generator switch = %@",((BodyNode*)child).uniqueID);
            if ([string isEqualToString:((BodyNode*)child).uniqueID]) {
                [subscribers addObject:child];
            }
        }
    }
   // CCLOG(@"switch event int = %i",switchEventType);
   // NSAssert([subscribers count]>0,@"subscribers count =0 in generator switch initWithCoder");
    
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pval CGPointValue] Rotation:rotation.floatValue Dimensions:[dims CGSizeValue] Objects:subscribers Event:(SwitchEvent)switchEventType]; 
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
-(void)onObjectDestroyed:(BodyNode*)obj{
    CCLOG(@"onObject destroyed called in generator switch");
    if (self.health>0) {
        [super.switchSubscribers removeObject:obj]; 
        
    }
   
}
                                            
+(id)generatorSwitchWithWorld:(b2World*)world position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)dimensions Objects:(NSMutableArray*)objs Event:(SwitchEvent)event{
    return [[[self alloc]initWithWorld:world position:pos Rotation:rotation Dimensions:dimensions Objects:objs Event:event]autorelease];
}
@end
