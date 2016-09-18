//
//  Credits.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Credits.h"
#import "Helper.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
@implementation Credits
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Credits*layer = [Credits node];
	
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
        CCParticleSystem * backingSystem = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"mainMenuParticle.plist"];
        backingSystem.position = [Helper screenCenter];
		[self addChild:backingSystem];

        CCSprite * backSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        CCSprite * sbackSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        
        sbackSprite.opacity = 100;
        
        CCMenuItem * back = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:sbackSprite target:self selector:@selector(exitCredits)];
        CCLabelTTF * backWords = [CCLabelTTF labelWithString:@"Back" fontName:@"futured.ttf" fontSize:30];
        backWords.color = ccc3(0, 0, 255);
        
        CGSize backSpriteSize = backSprite.contentSizeInPixels;
        
        
        backWords.position = ccp(backSpriteSize.width/2, backSpriteSize.height/2);
        
        [back addChild:backWords];
        
        
        
        CCMenu * menu = [CCMenu menuWithItems:back, nil];
        menu.position = ccp(backSpriteSize.width/2,backSpriteSize.height/2);
        [self addChild:menu];
        
		CCLabelTTF * snottyboi = [CCLabelTTF labelWithString:@"Gun Shooting Sound Effect.........snottyboi (soundbible.com)" fontName:@"Marker Felt" fontSize:20];
		snottyboi.position = ccp(screenSize.width/2, screenSize.height/1.2f);
		[self addChild:snottyboi];
		CCLabelTTF *mikeKoenig = [CCLabelTTF labelWithString:@"Other Sound Effects.........Mike Koenig (soundbible.com)" fontName:@"Marker Felt" fontSize:20];
		mikeKoenig.position = ccp(screenSize.width/2, screenSize.height / 1.5f);
		[self addChild:mikeKoenig];
        CCLabelTTF *music = [CCLabelTTF labelWithString:@"(Five Armies) Kevin MacLeod (incompetech.com)" fontName:@"Marker Felt" fontSize:20];
		music.position = ccp(screenSize.width/2, screenSize.height / 1.9f);
		[self addChild:music];
        CCLabelTTF *music2 = [CCLabelTTF labelWithString:@"(The Path of the Goblin King) Kevin MacLeod (incompetech.com)" fontName:@"Marker Felt" fontSize:20];
		music2.position = ccp(screenSize.width/2, screenSize.height / 2.4f);
		[self addChild:music2];
        CCLabelTTF *music3 = [CCLabelTTF labelWithString:@"(Exotic Battle) Kevin MacLeod (incompetech.com)" fontName:@"Marker Felt" fontSize:20];
		music3.position = ccp(screenSize.width/2, screenSize.height / 3.0f);
		[self addChild:music3];
        CCLabelTTF *music4 = [CCLabelTTF labelWithString:@"(Exciting Trailer) Kevin MacLeod (incompetech.com)" fontName:@"Marker Felt" fontSize:20];
		music4.position = ccp(screenSize.width/2, screenSize.height / 5.0f);
		[self addChild:music4];
        CCLabelTTF *music5 = [CCLabelTTF labelWithString:@"(Mechanolith) Kevin MacLeod (incompetech.com)" fontName:@"Marker Felt" fontSize:20];
		music5.position = ccp(screenSize.width/2, screenSize.height / 8.0f);
		[self addChild:music5];

		
		
			}
	return self;
}
-(void)exitCredits{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene] withColor:ccc3(5, 5, 5)]];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
