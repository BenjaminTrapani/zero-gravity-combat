//
//  StatsScene.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsScene.h"
#import "MainMenu.h"
#import "RankDisplay.h"
#import "SimpleAudioEngine.h"

@implementation StatsScene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatsScene*layer = [StatsScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

-(id)init{
    if ((self = [super init])) {
        screenSize = [[CCDirector sharedDirector]winSize];
        
        CCSprite * backing = [CCSprite spriteWithSpriteFrameName:@"sp3.png"];
        backing.position = ccp(screenSize.width/2,screenSize.height/2);
		[self addChild:backing];
        
        helper = [ZGCGKHelper sharedGameKitHelper];
        helper.delegate = self;
		/*CDSoundEngine*engine = [CDAudioManager sharedManager].soundEngine;
         buttonClick = [CDXAudioNode audioNodeWithFile:@"ButtonClick.wav" soundEngine:engine sourceId:[Options sharedOptions].runningSoundCount];
         [Options sharedOptions].runningSoundCount++;
         buttonClick.earNode = self;
         [self addChild:buttonClick];
         */
		//backings for buttons
		CCSprite * itemBacking = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
		CCSprite * selectedItemBacking = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
    
		CGSize backingSize = itemBacking.contentSizeInPixels;
		//play item
		CCMenuItem * showLeaderboards = [CCMenuItemSprite itemFromNormalSprite:itemBacking selectedSprite:selectedItemBacking target:self selector:@selector(showLeaderboard)];
		CCLabelTTF * leaderboardWords = [CCLabelTTF labelWithString:@"Leaderboards" fontName:@"futured" fontSize:20];
		leaderboardWords.position = ccp(backingSize.width/2,backingSize.height/2);
        showLeaderboards.position = ccp(screenSize.width/2,screenSize.height/2);
		[showLeaderboards addChild:leaderboardWords];
        
        CCSprite * backButtonSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        CCSprite * sbackButtonSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        sbackButtonSprite.opacity = 100;
		CCMenuItemSprite * backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSprite selectedSprite:sbackButtonSprite target:self selector:@selector(goBack)];
        backButton.position = ccp(backButtonSprite.contentSize.width/2,backButtonSprite.contentSize.height/2);
        CCLabelTTF * backWords = [CCLabelTTF labelWithString:@"Back" fontName:@"futured.ttf" fontSize:30];
        backWords.color = ccc3(0, 250, 0);
        backWords.position = ccp(backWords.contentSize.width/1.2,backWords.contentSize.height/2);
        [backButton addChild:backWords];
        CCMenu * theButtons = [CCMenu menuWithItems:backButton, showLeaderboards, nil];
        theButtons.position = ccp(0,0);
        [self addChild:theButtons];
        
        RankDisplay * rd = [RankDisplay rankDisplay];
        rd.position = ccp(screenSize.width/2,screenSize.height-rd.contentSize.height/2);
        [self addChild:rd];
        //fix leaderboard. I suspect that the view not appearing has something to do with how I screwed up the root view controller. Fix that and levelcompleted display, test on ipad, and you're good.

    }
    return self;
}
-(void)showLeaderboard{
    [helper showLeaderboard];
}
-(void)onLeaderboardViewDismissed{
    
}
-(void)onScoresSubmitted:(bool)success{
    
}
-(void)goBack{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
}

@end
