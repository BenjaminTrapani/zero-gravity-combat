//
//  Exit.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Exit.h"
#import "Soldier.h"
#import "Options.h"
#import "Glass.h"
#import "Options.h"
@implementation Exit

-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos{
    if ((self = [super init])) {
		CGSize blockDimensions = CGSizeMake(30, 5);
        blockSize = blockDimensions;
		blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
		pos = [Helper relativePointFromPoint:pos];
		_pos = pos;
				
		CGPoint bottomPos = ccp(pos.x, pos.y -[[Options sharedOptions] makeYConstantRelative:50]);
		CGPoint upperPos = ccp(pos.x, pos.y + [[Options sharedOptions] makeYConstantRelative:50]);
		
		//Glass*leftGlass = [Glass glassWithWorld:world Position:ccp(pos.x-blockDimensions.width/2-4,pos.y) Dimensions:CGSizeMake(2, 40) Rotation:;
		//Glass*rightGlass = [Glass glassWithWorld:world Position:ccp(pos.x+blockDimensions.width/2+4,pos.y) Dimensions:CGSizeMake(2, 40) Rotation:0];
		//[self addChild:leftGlass];
		//[self addChild:rightGlass];
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:upperPos]);
		//bodyDef.angularDamping = 0.9f;
		//bodyDef.linearDamping = 0.9f;
		
		NSString * spriteFrameName = @"entranceBlock.png";
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"entranceBlock.png"];
		b2PolygonShape shape;
		shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect creationRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
		
		
        
		BaseLevelObject * upperBar = [[BaseLevelObject alloc] init];
		BaseLevelObject * lowerBar = [[BaseLevelObject alloc] init];
		upperBar.destructible = NO;
		lowerBar.destructible = NO;
		upperBar.contactColor = ccc3(0, 250, 0);
		lowerBar.contactColor = ccc3(0, 250, 0);
		[upperBar createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];
		bodyDef.position = [Helper toMeters:bottomPos];
		[lowerBar createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];
		[self addChild:upperBar];
		[self addChild:lowerBar];
		[upperBar release];
		[lowerBar release];
        [self schedule:@selector(checkSoldier:) interval:0.5f];
        
        upperX = bottomPos.x+tempSprite.contentSize.width/2;
        lowerX = bottomPos.x-tempSprite.contentSize.width/2;
        upperY = upperPos.y;
        lowerY = bottomPos.y;
	}
	return self;

}
-(void)checkSoldier:(ccTime)delta{
    CGPoint soldierPos = [Helper toPixels:[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].body->GetWorldCenter()];
    if (soldierPos.x>lowerX-blockSize.width/2 && soldierPos.x<upperX+blockSize.width/2 && soldierPos.y>lowerY && soldierPos.y<upperY) {
        CCParticleSystem * entranceParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"entranceParticle.plist"];
        entranceParticle.position = _pos;
        entranceParticle.autoRemoveOnFinish = YES;
        [self addChild:entranceParticle];
        [self unschedule:@selector(checkSoldier:)];
        [[[HelloWorldLayer sharedHelloWorldLayer]getGameController]onLevelCompleted];
        /*Glass * glassLeft = [Glass glassWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:ccp(lowerX-blockSize.width/2,(upperY +lowerY)/2) Dimensions:CGSizeMake([[Options sharedOptions]makeXConstantRelative:5],(upperY-lowerY)*0.7f) Rotation:0];
        [self addChild:glassLeft];    
        Glass * glassRight = [Glass glassWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:ccp(lowerX+blockSize.width/2,(upperY +lowerY)/2) Dimensions:CGSizeMake([[Options sharedOptions]makeXConstantRelative:5],(upperY-lowerY)*0.7f) Rotation:0];
        [self addChild:glassRight];    
         */
    }
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval = [NSValue valueWithCGPoint:_pos];
    [aCoder encodeObject:pval forKey:@"pval"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue *pval = [aDecoder decodeObjectForKey:@"pval"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pval CGPointValue]];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)exitWithWorld:(b2World*)world Position:(CGPoint)pos{
    return [[[self alloc]initWithWorld:world Position:pos]autorelease];
}
@end
