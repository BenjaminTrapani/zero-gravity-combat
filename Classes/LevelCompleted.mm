//
//  LevelCompleted.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompleted.h"
#import "Options.h"
#import "RankDisplay.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "HelloWorldLayer.h"
#import "LoadingScene.h"
#import "Helper.h"
@implementation LevelCompleted
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelCompleted*layer = [LevelCompleted node];
	
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
        //CCLOG(@"Options level at beginning of init = %i",[Options sharedOptions].currentLevel); maintains correct level throughout init
        isIpad = [Options sharedOptions].isIpad;
        
        screenSize = [[CCDirector sharedDirector]winSize];
        CCSprite * backing = [CCSprite spriteWithFile:@"texture.png"];
        backing.position = ccp(screenSize.width/2,screenSize.height/2);
        //backing.contentSize = [backing texture].contentSize;
        CGSize backingSizedToFit = screenSize;
        backingSizedToFit.width/=2;
        backingSizedToFit.height/=2;
        
        backing = [Helper scaleSprite:backing toDimensions:backingSizedToFit];
        [self addChild:backing];
        
        
        
        glow = [CCSprite spriteWithFile:@"glow.png"];
       // glow.contentSize = [glow texture].contentSize;
        glow.position = backing.position;
        glow.opacity = 0.0f;
        glow = [Helper scaleSprite:glow toDimensions:backingSizedToFit];
        
        
        [self addChild:glow];
        specular = [CCSprite spriteWithFile:@"specular.png"];
        //specular.contentSize = [specular texture].contentSize;
        specular.position = backing.position;
        specular.opacity = 0.0f;
        specular = [Helper scaleSprite:specular toDimensions:backingSizedToFit];
        
        [self addChild:specular];
        opacityModifier = 0.0f;
        [self schedule:@selector(lightPulse:)];
        //make pulsing light sci fi door. All needed textures are open in photoshop and arranged correctly. Modify opacities.
        
        levelScore = [Options sharedOptions].levelScore;
        [self schedule:@selector(animateRankUp:) interval:1.0/30.0];
        //[Options sharedOptions].totalXP+= levelScore;
        [ZGCGKHelper sharedGameKitHelper].delegate = self;
        if (levelScore == [[Options sharedOptions]getHighScoreForCurrentLevel]) {
            [[ZGCGKHelper sharedGameKitHelper]submitScores:levelScore category:[NSString stringWithFormat:@"l%i",[Options sharedOptions].currentLevel]];
        }
        
		CCLabelTTF * finalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i",levelScore] fontName:@"FADETOGR.TTF" fontSize:30];
        finalScore.color = ccGREEN;
        CCNode * everythingOn = [CCNode node];
        finalScore.position = ccp(screenSize.width/2,screenSize.height-finalScore.contentSize.height/2);
        [everythingOn addChild:finalScore];
        CCLabelTTF * highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i",[[Options sharedOptions]getHighScoreForCurrentLevel]] fontName:@"futured.ttf" fontSize:15];
        highScore.position = ccp(screenSize.width/2,screenSize.height-finalScore.contentSize.height-highScore.contentSize.height);
        [everythingOn addChild:highScore];
        NSMutableArray * array = [Options sharedOptions].rangesForCurrentLevel;
        starOrder = [[NSMutableArray alloc]initWithCapacity:2];
        int starCount = 1;
        for (int i = 0; i<3; i++) {
            CCSprite * starBacking = [CCSprite spriteWithSpriteFrameName:@"fivepointstarback.png"];
            starBacking.position = ccp(screenSize.width/7 + starBacking.contentSize.width*(i+1),screenSize.height/1.5f);
            [everythingOn addChild:starBacking];
            
            
            if (i<1) {
                CCSprite * colorStar = [CCSprite spriteWithSpriteFrameName:@"fivepointstar.png"];
                //colorStar.position = starBacking.position;
                
                colorStar.position = starBacking.position;
                colorStar.opacity = 0;
                colorStar.scale = 0.1f;
                CCScaleBy * scale = [CCScaleBy actionWithDuration:1 scale:10];
                CCFadeIn * fade = [CCFadeIn actionWithDuration:1];
                CCSpawn * spawn = [CCSpawn actions:fade,scale, nil];
                CCCallFuncN * calfunc = [CCCallFuncN actionWithTarget:self selector:@selector(animateNextStar:)];
                CCSequence * seq = [CCSequence actions:spawn,calfunc, nil];
                [everythingOn addChild:colorStar];
                //[colorStar retain];
                [colorStar runAction:seq];

                
                
            }
             else  {
                    NSNumber *numAtIndex = (NSNumber*)[array objectAtIndex:i-1]; 
                 if (levelScore>=numAtIndex.intValue) {
                     //add the colorful star at the same position as the starBack
                     CCSprite * colorStar = [CCSprite spriteWithSpriteFrameName:@"fivepointstar.png"];
                     colorStar.position = starBacking.position;
                     colorStar.scale = 0.1f;
                     colorStar.opacity = 0;
                    [everythingOn addChild:colorStar];
                     [starOrder addObject:colorStar];
                     starCount ++;
                 }else{
                     CCLabelTTF * scoreRequired = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Need %i",numAtIndex.intValue] fontName:@"futured.ttf" fontSize:20];
                     scoreRequired.color = ccRED;
                     scoreRequired.position = starBacking.position;
                     [everythingOn addChild:scoreRequired];
                }
            }   
        }
        
        rd = [RankDisplay rankDisplay];
        rd.position = ccp(screenSize.width/2,screenSize.height/4);
        [everythingOn addChild:rd];
        [rd startRefreshing];
        [self addChild:everythingOn];
        Options * o = [Options sharedOptions];
        [o updateHighestStars:starCount ForLevel:[Options sharedOptions].currentLevel];
        [o setLevelUnlockStatus:kLevelCompleted ForLevel:[Options sharedOptions].currentLevel];
        if ([o getUnlockStatusForLevel:o.currentLevel+1]!=kLevelCompleted) {
            [[Options sharedOptions]setLevelUnlockStatus:kLevelUnlocked ForLevel:[Options sharedOptions].currentLevel+1];
        }
        
        //add ranking system and display here. Make rank display view a seperate class.
        
        //buttons
        
        
        incrementedLevel = [Options sharedOptions].currentLevel +1;
        
        		        //CCLOG(@"Options level at end of init = %i",[Options sharedOptions].currentLevel);
        
	}
	return self;
}

-(void)lightPulse:(ccTime)delta{
    float specOp = glow.opacity;
    float deltaSixty = (float)delta*60.0f;

    if (specOp<127.5f) {
        if (opacityModifier<1.0f) opacityModifier+=deltaSixty; //*8
    }else{
        if(opacityModifier>-1.0f)opacityModifier-=deltaSixty;
    }
 
    //CCLOG(@"opacityModifier = %f",opacityModifier);
    
    specular.opacity+=(opacityModifier/deltaSixty*5);
    
    glow.opacity+=opacityModifier;
}

-(void)onScoresSubmitted:(bool)success{
    
}
-(void)addContinueButtons{
    CCSprite * itemBacking = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
    CCSprite * selectedItemBacking = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
    CCSprite * ib2 = [CCSprite spriteWithSpriteFrameName:@"buttonBack.png"];
    CCSprite * sib2 = [CCSprite spriteWithSpriteFrameName:@"selectedButtonBack.png"];
    CGSize ibackingSize = itemBacking.contentSizeInPixels;

    if (incrementedLevel<=16) {
        
                
        CCMenuItem * nextLevel = [CCMenuItemSprite itemFromNormalSprite:itemBacking selectedSprite:selectedItemBacking target:self selector:@selector(nextLevel)];
        CCLabelTTF * playWords = [CCLabelTTF labelWithString:@"Next Level" fontName:@"futured" fontSize:20];
        playWords.position = ccp(ibackingSize.width/2,ibackingSize.height/2);
        [nextLevel addChild:playWords];
        
        CCMenuItem * quitToMain = [CCMenuItemSprite itemFromNormalSprite:ib2 selectedSprite:sib2 target:self selector:@selector(quitToMainMenu)];
        CCLabelTTF * quitWords = [CCLabelTTF labelWithString:@"Quit" fontName:@"futured.ttf" fontSize:20];
        quitWords.position = ccp(ibackingSize.width/2,ibackingSize.height/2);
        [quitToMain addChild:quitWords];
        
        CCMenu * buttonMenu = [CCMenu menuWithItems:nextLevel, quitToMain, nil];
        buttonMenu.position = ccp(screenSize.width/2,ibackingSize.height/2);
        [buttonMenu alignItemsHorizontally];
        [self addChild:buttonMenu];
        
    }else{
        CCMenuItem * quitToMain = [CCMenuItemSprite itemFromNormalSprite:ib2 selectedSprite:sib2 target:self selector:@selector(quitToMainMenu)];
        CCLabelTTF * quitWords = [CCLabelTTF labelWithString:@"Quit" fontName:@"futured.ttf" fontSize:20];
        quitWords.position = ccp(ibackingSize.width/2,ibackingSize.height/2);
        [quitToMain addChild:quitWords];
        
        CCMenu * buttonMenu = [CCMenu menuWithItems:quitToMain, nil];
        buttonMenu.position = ccp(screenSize.width/2,ibackingSize.height/2);
        [buttonMenu alignItemsHorizontally];
        [self addChild:buttonMenu];
        
    }

}
-(void)animateRankUp:(ccTime)delta{
    //int realInterval = intervalToAdd * delta;
    //CCLOG(@"real interval = %i",realInterval);
    [Options sharedOptions].totalXP += 1;
    [rd refresh];
    levelScore -= 1;
    if (levelScore<=0) {
        [self unschedule:@selector(animateRankUp:)];
        [rd doneRefreshing];
        [self addContinueButtons];
        ZGCGKHelper * helper = [ZGCGKHelper sharedGameKitHelper];
        [helper submitScores:[Options sharedOptions].totalXP  category:@"ttlxp"];
    }
}
-(void)animateNextStar:(CCNode*)sender{
    
    CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"StarParticle.plist"];
    system.position = sender.position;
    [self addChild:system];
    
    
    if ([starOrder count]>0) {
        CCNode * nextStar = (CCNode*)[starOrder objectAtIndex:0];
        CCScaleBy * scale = [CCScaleBy actionWithDuration:2 scale:10];
        CCFadeIn * fade = [CCFadeIn actionWithDuration:2];
        CCSpawn * spawn = [CCSpawn actions:fade,scale, nil];
        CCCallFuncN * calfunc = [CCCallFuncN actionWithTarget:self selector:@selector(animateNextStar:)];
        CCSequence * seq = [CCSequence actions:spawn,calfunc, nil];
        [nextStar runAction:seq];
        [starOrder removeObjectAtIndex:0];
    }
    
}

-(void)nextLevel{
   // Options * o = [Options sharedOptions]; //this is fine, doesn't double init.
    [Options sharedOptions].currentLevel = incrementedLevel; 
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"]; 
	//[buttonClick play];
	//[self performSelector:@selector(switchToPlay) withObject:@"ManMenu" afterDelay:0.5f];
	//sound doesn't play because it is a child of the layer and gets removed before it can play.
	//[buttonClick play];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[LoadingScene scene]]];
}
-(void)quitToMainMenu{
    [[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	//[buttonClick play];
	//[self performSelector:@selector(switchToPlay) withObject:@"ManMenu" afterDelay:0.5f];
	//sound doesn't play because it is a child of the layer and gets removed before it can play.
	//[buttonClick play];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu scene]]];
}


-(void)dealloc{
    [starOrder release];
    [super dealloc];
}
@end
