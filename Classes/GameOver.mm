//
//  GameOver.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"
#import "MainMenu.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "LoadingScene.h"
@implementation GameOver
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOver*layer = [GameOver node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		CCSprite * backing = [CCSprite spriteWithSpriteFrameName:@"levelCompleteBacking.png"];
        backing.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:backing];
		
		/*CCParticleSystem * flameBetweenDoors = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"duelFlames.plist"];
		//flameBetweenDoors.position = ccp(screenSize.width/2,0);
		[self addChild:flameBetweenDoors];
		*/
        
		//CCSprite * menuBacking = [CCSprite spriteWithSpriteFrameName:@"texturedBacking.png"];
		//menuBacking.position = ccp(screenSize.width/2,screenSize.height/2);
		//[self addChild:menuBacking];
		
		CCSprite * rNotSelected = [CCSprite spriteWithSpriteFrameName:@"greenButton.png"];
		CCSprite * rSelected = [CCSprite spriteWithSpriteFrameName:@"greenButton.png"];
		CCSprite * qNotSelected = [CCSprite spriteWithSpriteFrameName:@"RedButton.png"];
		CCSprite * qSelected = [CCSprite spriteWithSpriteFrameName:@"RedButton.png"];
		rSelected.opacity = 100;
		qSelected.opacity = 100;
		CCLabelTTF * replayLabel = [CCLabelTTF labelWithString:@"Replay" fontName:@"futured.ttf" fontSize:25];
		CCLabelTTF * quitLabel = [CCLabelTTF labelWithString:@"Quit" fontName:@"futured.ttf" fontSize:25];
		CCLabelTTF * rls = [CCLabelTTF labelWithString:@"Replay" fontName:@"futured.ttf" fontSize:25];
		CCLabelTTF * qls = [CCLabelTTF labelWithString:@"Quit" fontName:@"futured.ttf" fontSize:25];
		rls.opacity = 100;
		qls.opacity = 100;
		replayLabel.position = ccp([replayLabel texture].contentSize.width*1.1,[replayLabel texture].contentSize.height*0.7);
		quitLabel.position = ccp([quitLabel texture].contentSize.width*1.7,[quitLabel texture].contentSize.height*0.7);
		rls.position = ccp([rls texture].contentSize.width*1.1,[rls texture].contentSize.height*0.7);
		qls.position = ccp([qls texture].contentSize.width*1.7,[qls texture].contentSize.height*0.7);
		
		[rNotSelected addChild:replayLabel];
		[rSelected addChild:rls];
		[qNotSelected addChild:quitLabel];
		[qSelected addChild:qls];
		
		CCMenuItem * replay = [CCMenuItemSprite itemFromNormalSprite:rNotSelected selectedSprite:rSelected target:self selector:@selector(replay)];
		CCMenuItem * quit = [CCMenuItemSprite itemFromNormalSprite:qNotSelected selectedSprite:qSelected target:self selector:@selector(quit)];
		CCLabelTTF * deathLabel = [CCLabelTTF labelWithString:@"You Died" fontName:@"Blood.ttf" fontSize:40];
		deathLabel.color = ccc3(255, 0, 0);
		CCMenu * deathMenu = [CCMenu menuWithItems:replay,quit,nil];
		[deathMenu alignItemsVertically];
		deathMenu.position = ccp(screenSize.width/2,screenSize.height);
		[self addChild:deathMenu];
		[self addChild:deathLabel];
		CCMoveTo * move = [CCMoveTo actionWithDuration:1 position:ccp(screenSize.width/2,screenSize.height/2)];
		CCEaseIn * bounce = [CCEaseIn actionWithAction:move rate:3];
		CCMoveTo * move2 = [CCMoveTo actionWithDuration:1 position:ccp(screenSize.width/2,screenSize.height/2 + screenSize.height/5)];
		CCEaseIn * bounce2 = [CCEaseIn actionWithAction:move2 rate:3];
		[deathMenu runAction:bounce];
		deathLabel.position = ccp(deathMenu.position.x, deathMenu.position.y*1.5);
		[deathLabel runAction:bounce2];
		
		//click = [CDXAudioNode audioNodeWithFile:@"goodClick.wav" soundEngine:[CDAudioManager sharedManager].soundEngine sourceId:0];
		
		//[self addChild:click];
				
	}
	return self;
}

-(void)replay{
	//[click play];
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[LoadingScene scene] withColor:ccc3(0, 0, 0)]];
}
-(void)quit{
	//[click play];
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu scene] withColor:ccc3(0, 0, 0)]];
}
-(void)rp{
	
}
-(void)qt{
	
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
