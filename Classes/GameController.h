//
//  GameController.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameController : CCNode {
	CGPoint gameStartPosition;
	float score;
	CCLabelBMFont * scoreLabel;
	CCLabelBMFont * timeLeft;
	float timeLimit;
	float intervalToIncreaseScore;
    int lastSeconds;
}

+(id)gc;
-(void)addPointsToScore:(int)pointsToAdd Location:(CGPoint)loc Prefix:(NSString*)prefix;
-(void)removeScoreChange:(CCNode*)sender;
-(void)onLevelCompleted;
@property(nonatomic,readwrite)CGPoint gameStartPosition; //not used
@property(nonatomic,readwrite)float score;
@property(nonatomic,readwrite)float timeLimit;
@end
