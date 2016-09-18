//
//  MainMenu.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "SimpleAudioEngine.h"
#import "Armory.h"
#import "Options.h"
#import "HelloWorldLayer.h"
#import "LevelSelect.h"
#import "StatsScene.h"
#import "Helper.h"
#import "Credits.h"
@implementation MainMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu*layer = [MainMenu node];
	
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
        [Options sharedOptions]->isLoading = NO;
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		CCParticleSystem * backingSystem = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"mainMenuParticle.plist"];
        backingSystem.position = [Helper screenCenter];
		[self addChild:backingSystem];
		CCSprite * title = [CCSprite spriteWithSpriteFrameName:@"Title.png"];
		CGSize titleSize = title.contentSizeInPixels;
		title.position = ccp(screenSize.width/2, screenSize.height-titleSize.height*1.4);
		[self addChild:title];
		
		/*CDSoundEngine*engine = [CDAudioManager sharedManager].soundEngine;
		buttonClick = [CDXAudioNode audioNodeWithFile:@"ButtonClick.wav" soundEngine:engine sourceId:[Options sharedOptions].runningSoundCount];
		[Options sharedOptions].runningSoundCount++;
		buttonClick.earNode = self;
		[self addChild:buttonClick];
		*/
		//backings for buttons
		CCSprite * itemBacking = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
		CCSprite * selectedItemBacking = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
		CCSprite * ib2 = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
		CCSprite * sib2 = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
		CCSprite * ib3 = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
		CCSprite * sib3 = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
        CCSprite * ib4 = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
		CCSprite * sib4 = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
		CGSize backingSize = itemBacking.contentSizeInPixels;
		//play item
		CCMenuItem * play = [CCMenuItemSprite itemFromNormalSprite:itemBacking selectedSprite:selectedItemBacking target:self selector:@selector(doPlay)];
		CCLabelTTF * playWords = [CCLabelTTF labelWithString:@"play" fontName:@"futured" fontSize:20];
		playWords.position = ccp(backingSize.width/2,backingSize.height/2);
		[play addChild:playWords];
		
		//Armory
		CCMenuItem * armory = [CCMenuItemSprite itemFromNormalSprite:ib2 selectedSprite:sib2 target:self selector:@selector(doArmory)];
		CCLabelTTF * armoryWords = [CCLabelTTF labelWithString:@"armory" fontName:@"futured" fontSize:20];
		armoryWords.position = ccp(backingSize.width/2,backingSize.height/2);
		[armory addChild:armoryWords];
		
		//stats
		CCMenuItem * stats = [CCMenuItemSprite itemFromNormalSprite:ib3 selectedSprite:sib3 target:self selector:@selector(doStats)];
		CCLabelTTF * statsWords = [CCLabelTTF labelWithString:@"stats" fontName:@"futured" fontSize:20];
		statsWords.position = ccp(backingSize.width/2, backingSize.height/2);
		[stats addChild:statsWords];
		//edit mode
        CCMenuItem * Editor = [CCMenuItemSprite itemFromNormalSprite:ib4 selectedSprite:sib4 target:self selector:@selector(doEdit)];
		CCLabelTTF * editorWords = [CCLabelTTF labelWithString:@"Credits" fontName:@"futured" fontSize:20];
		editorWords.position = ccp(backingSize.width/2, backingSize.height/2);
		[Editor addChild:editorWords];
		
		//mute button
		CCSprite * umSprite = [CCSprite spriteWithSpriteFrameName:@"soundButton.png"];
		CCSprite * sumSprite = [CCSprite spriteWithSpriteFrameName:@"soundButton.png"];
		sumSprite.opacity = 100;
		CCSprite * mSprite = [CCSprite spriteWithSpriteFrameName:@"muteButton.png"];
		CCSprite * smSprite = [CCSprite spriteWithSpriteFrameName:@"muteButton.png"];
		smSprite.opacity = 100;
		unmuted = [CCMenuItemSprite itemFromNormalSprite:umSprite selectedSprite:sumSprite target:self selector:@selector(switchSound:)];
        muted = [CCMenuItemSprite itemFromNormalSprite:mSprite selectedSprite:smSprite target:self selector:@selector(switchSound:)];
		BOOL soundSetting = [[Options sharedOptions]getSoundEnabled];
		if (soundSetting == NO) {
			unmuted.visible = NO;
			muted.visible = YES;
			
		}
		if (soundSetting == YES) {
			unmuted.visible = YES;
			muted.visible = NO;
		}
		//actual menu
		CCMenu * menu = [CCMenu menuWithItems:play,armory,stats,Editor,nil];
		[menu alignItemsVertically];
		menu.position = ccp(screenSize.width/2,screenSize.height/3);
		[self addChild:menu];
		
		CCMenu * muteMenu = [CCMenu menuWithItems:unmuted, muted,nil];
		CCSprite * tempSprite = [CCSprite spriteWithSpriteFrameName:@"muteButton.png"];
		CGSize tempSpriteSize = tempSprite.contentSizeInPixels;
		muteMenu.position = ccp(tempSpriteSize.width/2, tempSpriteSize.height/2);
		[self addChild:muteMenu];
		
        [ZGCGKHelper sharedGameKitHelper].delegate = self;
		//buttonClick = [CDXAudioNode audioNodeWithFile:@"goodClick.wav" soundEngine:[CDAudioManager sharedManager].soundEngine sourceId:0];
		//[self addChild:buttonClick];
        
		//NSLog(@"Testing helper converting point. X = %f   Y = %f",
	}
	return self;
}
-(void)onLocalPlayerAuthenticationChanged{
    
}
-(void)onScoresSubmitted:(bool)success{
    
}
-(void)onLeaderboardViewDismissed{
    
}
-(void) onAchievementsLoaded:(NSDictionary*)achievements{
    
}
-(void)doEdit{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    /*
    [Options sharedOptions].isUsingEditor = YES;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[LevelSelect node]]];
     */
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Credits node]]];
}
-(void)doPlay{
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	//[buttonClick play];
	//[self performSelector:@selector(switchToPlay) withObject:@"ManMenu" afterDelay:0.5f];
	//sound doesn't play because it is a child of the layer and gets removed before it can play.
	//[buttonClick play];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer scene]]];
    [Options sharedOptions].isUsingEditor = NO;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[LevelSelect node]]];
	
}
-(void)switchToPlay{
	
}
-(void)doArmory{
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    //add loading screen as buffer in between scene swap. Actually, don't bother. Armory uses 5 mb ram while game scene uses 20 or so. Fix memory leaks. 
	//[buttonClick play];
	//[buttonClick play];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Armory node]]];
	
}
-(void)doStats{
    //[[ZGCGKHelper sharedGameKitHelper]showLeaderboard];
	//[buttonClick play];
	//[buttonClick play];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[StatsScene node]]];
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
}
-(void)switchSound:(id)sender{
	if (sender == unmuted) {
		muted.visible = YES;
		unmuted.visible = NO;
		[[Options sharedOptions]setSoundEnabled:NO];
	}
	if (sender == muted) {
		muted.visible = NO;
		unmuted.visible = YES;
		[[Options sharedOptions]setSoundEnabled:YES];
        
	}
	
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
