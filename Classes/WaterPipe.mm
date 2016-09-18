//
//  WaterPipe.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterPipe.h"
#import "Options.h"
#import "CDXAudioNode.h"
#import "Soldier.h"
@implementation WaterPipe
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Mirrored:(BOOL)mirrored{
    if ((self = [super init])) {
        _isMirrored = mirrored;
        super.destructible = NO;
        CCSprite * temp = [CCSprite spriteWithSpriteFrameName:@"waterPipe.png"];
        super.dimensions = [temp contentSize];
        super.contactColor = ccc3(70, 70, 70);
        super.usesSpriteBatch = NO;
        pos = [Helper relativePointFromPoint:pos];
        b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        
        NSString * spriteFrameName = @"waterPipe.png";
		//bodyDef.angularDamping = 0.1f;
		//bodyDef.linearDamping = 0.1f;
		
		b2PolygonShape shape;
		
		shape.SetAsBox(super.dimensions.width/PTM_RATIO, super.dimensions.height/PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		//fixtureDef.density = 2.0f;
		//fixtureDef.friction = 0.1f;
		fixtureDef.restitution = 0.5f;
		
        CGRect sizeRect = CGRectMake(0, 0, super.dimensions.width, super.dimensions.height);
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:sizeRect]; 
        CCParticleSystem * waterFlow = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"WaterFromPipe.plist"];
        waterFlow.rotation = -rotation+180;
        if (mirrored) {
            float xOffset = [[Options sharedOptions]makeXConstantRelative:5];
            waterFlow.position = ccp(xOffset, [[Options sharedOptions]makeYConstantRelative:0]);
            super.sprite.flipX = YES;
        }else{
        float xOffset = [[Options sharedOptions]makeXConstantRelative:45];
        waterFlow.position = ccp(xOffset, [[Options sharedOptions]makeYConstantRelative:0]);
        }
        [super.sprite addChild:waterFlow z:-1];
        
        CDXAudioNode * audioNode = [CDXAudioNode audioNodeWithFile:@"waterPouring.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
        audioNode.earNode = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].sprite;
        audioNode.position = waterFlow.position;
        [super.sprite addChild:audioNode];
        audioNode.playMode = kAudioNodeLoop;
        [audioNode play];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue *pval = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    [aCoder encodeBool:_isMirrored forKey:@"isMirrored"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pval = [aDecoder decodeObjectForKey:@"pval"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    BOOL isMirrored = [aDecoder decodeBoolForKey:@"isMirrored"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue] Rotation:rotation.floatValue Mirrored:isMirrored];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
    
}
+(id)waterPipeWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Mirrored:(BOOL)mirrored{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Mirrored:mirrored]autorelease];
}
@end
