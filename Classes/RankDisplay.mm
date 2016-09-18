//
//  RankDisplay.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RankDisplay.h"
#import "Options.h"
#import "GPBar.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
#import "MainMenu.h"
@implementation RankDisplay
+(id)rankDisplay{
    return [[[self alloc]init]autorelease];
}

-(id)init{
    if ((self = [super init])) {
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        Options * o = [Options sharedOptions];
        //backing
        CCSprite * backing = [CCSprite spriteWithSpriteFrameName:@"RankDisplayBacking.png"];
        CGSize backingSize = backing.contentSize;
        [self addChild:backing];
        
        //rank progress bar
        
        progressBar = [GPBar barWithBarFrame:@"progressBar.png" insetFrame:@"progressInset.png" maskFrame:@"maskProgressBar.png"];
        CGSize barSize = progressBar.barSprite.contentSize;
        lengthToPercentRatio = barSize.width/100;
        //[self calculateRequiredPointsToRankUp];
        int realProgress = [o getPercentProgressForRankUp];
        CCLOG(@"real progress = %i",realProgress);
        progressBar.progress = realProgress;
        progressBar.position = ccp(-screenSize.width/2,-screenSize.height/2);
        [self addChild:progressBar z:0 tag:1];
        float labelScale = 0.7f;
        //rank progress label
        rankProgressLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i/%i",o.totalXP,o.totalXP + [o getPointsRequiredForRankUp]] fntFile:@"gf3.fnt"];
        rankProgressLabel.scale = labelScale;
        [self addChild:rankProgressLabel z:0 tag:2];
        
        //total xp level
        totalXP = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Total XP: %i",o.totalXP] fntFile:@"FuturedBMFont.fnt"];//[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total XP: %i",o.totalXP] fontName:@"futured.ttf" fontSize:20];
        totalXP.position = ccp(-backingSize.width/2+totalXP.contentSize.width*labelScale,backingSize.height/2-totalXP.contentSize.height*labelScale);
        totalXP.color = ccc3(1, 1, 1);
        totalXP.scale= labelScale;
        [self addChild:totalXP z:0 tag:3];
        
        //xp needed for rank up
        xpNeededForRankUp = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"XP Needed to Rank Up: %i",[o getPointsRequiredForRankUp]] fntFile:@"FuturedBMFont.fnt"];
        
        
        
        xpNeededForRankUp.position = ccp(backingSize.width/2-xpNeededForRankUp.contentSize.width*labelScale,-backingSize.height/2+xpNeededForRankUp.contentSize.height*labelScale);
        xpNeededForRankUp.color = ccc3(1, 1, 1);
        xpNeededForRankUp.scale= labelScale;
        [self addChild:xpNeededForRankUp z:0 tag:4];
        
        //current rank
        currRank = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i",o.currentRank] fntFile:@"FuturedBMFont.fnt"];
        currRank.position = ccp(backingSize.width/2-currRank.contentSize.width*labelScale,backingSize.height/2-currRank.contentSize.height*labelScale);
        currRank.color = ccc3(1, 1, 1);
        currRank.scale = labelScale;
        [self addChild:currRank z:0 tag:5];
        
        [self setContentSize:backingSize];
        
        

    }
    return self;
}

-(void)startRefreshing{
    //progressBar.barSprite.color = ccc3(250, 0, 0);
    CCParticleSystem * system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"progressBarAnimation2.plist"];
    system.position = ccp((progressBar.progress * lengthToPercentRatio)-200,0);
    [self addChild:system z:0 tag:7];
}

-(void)refresh{
    Options * o = [Options sharedOptions];
    progressBar.progress = [o getPercentProgressForRankUp];
    CCParticleSystem * system = (CCParticleSystem*)[self getChildByTag:7];
    system.position = ccp((progressBar.progress * lengthToPercentRatio)-[o makeAverageConstantRelative:200],0);
    [rankProgressLabel setString:[NSString stringWithFormat:@"%i/%i",o.totalXP,o.totalXP + [o getPointsRequiredForRankUp]]];
    [totalXP setString:[NSString stringWithFormat:@"Total XP: %i",o.totalXP]];
    [xpNeededForRankUp setString:[NSString stringWithFormat:@"XP Needed to Rank Up: %i",[o getPointsRequiredForRankUp]]];
    [currRank setString:[NSString stringWithFormat:@"Rank: %i",o.currentRank]];
}    
-(void)doneRefreshing{
    [self removeChildByTag:7 cleanup:YES];
    //progressBar.barSprite.color = ccc3(255, 255, 255);

}
-(void)dealloc{
    [super dealloc];
}
@end
