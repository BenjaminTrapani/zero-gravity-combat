//
//  LevelCompleted.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ZGCGKHelper.h"
@class RankDisplay;
@interface LevelCompleted : CCLayer <GameKitHelperProtocol>{
    NSMutableArray * starOrder;
    int incrementedLevel;
    int levelScore;
    CGSize screenSize;
    RankDisplay * rd;
    CCSprite * specular;
    CCSprite * glow;
    float opacityModifier;
    BOOL isIpad;
    
}
+(CCScene*)scene;
-(void)animateRankUp:(ccTime)delta;
-(void)addContinueButtons;
-(void)lightPulse:(ccTime)delta;
@end
