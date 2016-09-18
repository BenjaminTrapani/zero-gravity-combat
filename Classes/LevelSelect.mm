//
//  LevelSelect.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 3/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelect.h"
#import "MyMenuItem.h"
#import "Options.h"
#import "MyMenuItem.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "LoadingScene.h"
@implementation LevelSelect
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelect*layer = [LevelSelect node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		CCParticleSystem * backingSystem = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"mainMenuParticle.plist"];
        backingSystem.position = ccp(screenSize.width/2,screenSize.height/2);
		[self addChild:backingSystem];
        
        int currentLevel = 0;
        
        for (int i = 1; i <= 4; i++) {
            CCSprite * sectionBacking = [CCSprite spriteWithSpriteFrameName:@"LevelSelectBacking.png"];
            CGSize sectionBackingSize = sectionBacking.contentSize;
            int positiveOrNegative = 0;
            if (i%2 == 0) {
                positiveOrNegative = 1;
            }else {
                positiveOrNegative = -1;
            }
            int heightDecrease = 1;
            if (i>2) {
                heightDecrease = 2;
            }
            sectionBacking.position = ccp(screenSize.width/2 + (sectionBackingSize.width/2*positiveOrNegative), screenSize.height - (sectionBackingSize.height * heightDecrease));
            [self addChild:sectionBacking];
            
            CCMenu * currentMenu = [CCMenu menuWithItems:nil];
            //currentMenu.anchorPoint = ccp(0.0f,0.0f);
            currentMenu.position = ccp(0,0);
            [sectionBacking addChild:currentMenu];
            
            for (int c = 1; c<=4; c++) {
                currentLevel += 1;
                CCSprite * ulevelSquare = [CCSprite spriteWithSpriteFrameName:@"levelSelectSquare.png"];
                CCSprite * slevelSquare = [CCSprite spriteWithSpriteFrameName:@"levelSelectSquare.png"];
                slevelSquare.opacity = 100;
                CGSize levelSquareSize = ulevelSquare.contentSize;
               // levelSquare.position = ccp((levelSquareSize.width*((float)c)),sectionBackingSize.height/2);
                MyMenuItem * levelSquare = [MyMenuItem itemFromNormalSprite:ulevelSquare selectedSprite:slevelSquare target:self selector:@selector(levelClicked:)];
                levelSquare.position = ccp((levelSquareSize.width*((float)c)),sectionBackingSize.height/2);
                levelSquare.customData = [NSNumber numberWithInt:currentLevel];
                [currentMenu addChild:levelSquare];
                //add unlocked or locked here and the level number above level select square.
                CCLabelTTF * levelNumber = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",currentLevel] fontName:@"futured.ttf" fontSize:20];
                levelNumber.color = ccc3(250, 250, 0);
               // levelNumber.position = ccp(levelSquareSize.width/2,levelSquareSize.height/2 + levelNumber.contentSize.height/2);
                levelNumber.position = ccp(levelSquareSize.width/2,levelSquareSize.height + levelNumber.contentSize.height/2);
                [levelSquare addChild:levelNumber];
                
                CCSprite * unlockIndicator;
                int unlockValue = [[Options sharedOptions]getUnlockStatusForLevel:currentLevel];
                if (unlockValue == kLevelLocked) {
                    unlockIndicator = [CCSprite spriteWithSpriteFrameName:@"padlock2.png"];
                    unlockIndicator.position = ccp(levelSquareSize.width/2,levelSquareSize.height/2);
                     [levelSquare addChild:unlockIndicator];
                }
                if (unlockValue == kLevelUnlocked) {
                    unlockIndicator = nil;
                }
                if (unlockValue == kLevelCompleted) {
                    unlockIndicator = [CCSprite spriteWithSpriteFrameName:@"checkMark.png"];
                    unlockIndicator.position = ccp(levelSquareSize.width/2,levelSquareSize.height/2);
                     [levelSquare addChild:unlockIndicator];
                    //add stars
                }
                
                for (int b = 1; b<=3; b++) {
                    CCSprite * starBack = [CCSprite spriteWithSpriteFrameName:@"fivepointstarback.png"];
                    starBack.scale = 0.15;
                    if (b!=1) {
                       starBack.position = ccp(starBack.contentSize.width/9 * b,-starBack.contentSize.height/12); 
                    }else {
                        starBack.position = ccp(starBack.contentSize.width/9,-starBack.contentSize.height/12);
                    }
                    
                    [levelSquare addChild:starBack];
                    if (unlockValue == kLevelCompleted) {
                        //CCLOG(@"currentLevel = %i",currentLevel);
                        //CCLOG(@"highestStarsForLevel = %i", [[Options sharedOptions]getHighestStarsForLevel:currentLevel]);
                        if ([[Options sharedOptions]getHighestStarsForLevel:currentLevel]>=b) {
                            //if (i==4) {
                             //   CCLOG(@"attempted to add star in fourth section");
                            //}
                           // CCLOG(@"attempted to add star");//this code gets called
                            CCSprite * colorStar = [CCSprite spriteWithSpriteFrameName:@"fivepointstar.png"];
                            colorStar.scale = 0.15;
                            colorStar.position = starBack.position;
                            [levelSquare addChild:colorStar];

                        }
                    }
                    
                }
            }
            
        }
        CCSprite * backButtonSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        CCSprite * sbackButtonSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        sbackButtonSprite.opacity = 100;
		CCMenuItemSprite * backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSprite selectedSprite:sbackButtonSprite target:self selector:@selector(goBack)];
        backButton.position = ccp(backButtonSprite.contentSize.width/2,backButtonSprite.contentSize.height/2);
        CCLabelTTF * backWords = [CCLabelTTF labelWithString:@"Back" fontName:@"futured.ttf" fontSize:30];
        backWords.color = ccc3(0, 250, 0);
        backWords.position = ccp(backWords.contentSize.width/1.2,backWords.contentSize.height/2);
        [backButton addChild:backWords];
        CCMenu * theButtons = [CCMenu menuWithItems:backButton, nil];
        theButtons.position = ccp(0,0);
        [self addChild:theButtons];
        
    }
	return self;
}
-(void)goBack{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
}
-(void)levelClicked:(MyMenuItem*)sender{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
    int sentLevel = ((NSNumber*)sender.customData).intValue;
    if ([[Options sharedOptions]getUnlockStatusForLevel:sentLevel]==kLevelLocked){ 
        return;
    }
    CCLOG(@"on level %i clicked", sentLevel);
    [Options sharedOptions].currentLevel = sentLevel;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[LoadingScene node]]];
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
