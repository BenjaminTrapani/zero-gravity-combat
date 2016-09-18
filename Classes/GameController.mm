//
//  GameController.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "HelloWorldLayer.h"
#import "Options.h"
#import "LevelCompleted.h"
#import "GameOver.h"
#import "Soldier.h"
@implementation GameController
@synthesize gameStartPosition, score, timeLimit;
//static GameController *instanceOfGameController;

/*
+(GameController*) sharedGameController
{
	@synchronized(self)
	{
		if (instanceOfGameController== nil)
		{
			instanceOfGameController = [GameController gc];
			
		}
		
		return instanceOfGameController;
	}
	
	// to avoid compiler warning
	return nil;
}
*/
-(id)init{
	if ((self = [super init])) {
		scoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score: %i",score] fntFile:@"FuturedBMFont.fnt"];
		scoreLabel.anchorPoint = ccp(0,0.5);
        scoreLabel.color = ccc3(0, 255, 0);
        scoreLabel.scale = 0.75f; //texture atlas broken. Not the code's fault. The exporter doesn't work well. Find another one. Try glyph designer. Cocos2d is supported. To get heiro to work, length of atlas has to equal width
		CGSize scoreSize = scoreLabel.contentSize;
        scoreSize.width *= 0.75f;
        scoreSize.height *= 0.75f;
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		scoreLabel.position = ccp(0,screenSize.height-(scoreSize.height/2));
		scoreLabel.color = ccc3(0, 250, 0);
		[self addChild:scoreLabel];
        NSNumber *thefloat = [NSNumber numberWithFloat:timeLimit];
        int inputSeconds = [thefloat intValue];
        int hours = inputSeconds / 3600;
        int minutes = (inputSeconds - hours * 3600) / 60;
        float seconds = timeLimit - hours * 3600 - minutes * 60;
        lastSeconds = (int)seconds;
		timeLeft = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i:%f left",minutes,seconds] fntFile:@"gf3.fnt"];
		timeLeft.anchorPoint = ccp(0,0.5);
		timeLeft.color = ccc3(250, 250, 0);
		timeLeft.position = ccp(0,screenSize.height-scoreSize.height*1.3);
		[self addChild:timeLeft];
        if ([Options sharedOptions].isUsingEditor==NO) {
            [self schedule:@selector(update:)];
        }
		
		intervalToIncreaseScore = 0;
	}
	return self;
}
+(id)gc{
	return [[[self alloc]init]autorelease];
}
-(void)update:(ccTime)delta{
	timeLimit-=delta;
    if (timeLimit<=0) {
        [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].health = -1;
    }
    
    NSNumber *thefloat = [NSNumber numberWithFloat:timeLimit];
    int inputSeconds = [thefloat intValue];
    int hours = inputSeconds / 3600;
    int minutes = (inputSeconds - hours * 3600) / 60;
    float seconds = timeLimit - hours * 3600 - minutes * 60;
    int intSeconds = (int)seconds;
    if (timeLimit<10) {
        [timeLeft setString:[NSString stringWithFormat:@"%i:%.2f left",minutes,seconds]];
    }else if (abs(intSeconds-lastSeconds)>0) {
        lastSeconds = intSeconds;
        [timeLeft setString:[NSString stringWithFormat:@"%i:%i left",minutes,intSeconds]];
    }
    
    
	//[timeLeft setString:[NSString stringWithFormat:@"%i:%.2f left",minutes,seconds]];
}
-(void)addPointsToScore:(int)pointsToAdd Location:(CGPoint)loc Prefix:(NSString*)prefix{
	score+=pointsToAdd;
	[scoreLabel setString:[NSString stringWithFormat:@"Score: %i",(int)score]];
	CCLabelTTF * scoreChange;
	if (pointsToAdd>0) {
		scoreChange = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ +%i",prefix,pointsToAdd] fontName:@"futured.ttf" fontSize:20];
	}else {
		scoreChange = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ -%i",prefix,pointsToAdd*-1] fontName:@"futured.ttf" fontSize:20];
	}

	scoreChange.position = loc;
	scoreChange.color = ccc3(250, 250, 0);
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:scoreChange z:102];
	CCFadeOut * fadeOut = [CCFadeOut actionWithDuration:3];
	CCCallFuncN * callFunc = [CCCallFuncN actionWithTarget:self selector:@selector(removeScoreChange:)];
	CCSequence * seq = [CCSequence actions:fadeOut,callFunc,nil];
	[scoreChange runAction:seq];
	
}
-(void)addTimeToScore:(ccTime)delta{
    timeLimit-=delta*30;
    BOOL replaceScene = NO;
    if (timeLimit<=0) {
        timeLimit = 0;
        [self unschedule:@selector(addTimeToScore:)];
        replaceScene = YES;
        
    }
    NSNumber *thefloat = [NSNumber numberWithFloat:timeLimit];
    int inputSeconds = [thefloat intValue];
    int hours = inputSeconds / 3600;
    int minutes = (inputSeconds - hours * 3600) / 60;
    float seconds = timeLimit - hours * 3600 - minutes * 60;
    [timeLeft setString:[NSString stringWithFormat:@"%i:%.2f left",minutes,seconds]];
    
    score+=intervalToIncreaseScore;
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %i",(int)score]];
    
    if (replaceScene == YES) {
        [Options sharedOptions].levelScore = (int)score;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCW transitionWithDuration:1 scene:[LevelCompleted scene]]];
    }

}
-(void)onLevelCompleted{
    //CCLOG(@"options level at end of level = %i",[Options sharedOptions].currentLevel); //this is correct. 
  //  of Options.
    intervalToIncreaseScore = (timeLimit/10)/(timeLimit/2);
    [self schedule:@selector(addTimeToScore:)];
    [self unschedule:@selector(update:)];
    //[[HelloWorldLayer sharedHelloWorldLayer]getWorld]->SetGravity(b2Vec2(0,-16));
    /*
    int timeBonus = timeLimit/10;
    [Options sharedOptions].levelScore = score + timeBonus;
    //CCLOG(@"onLevelCompleted");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionRadialCW transitionWithDuration:1 scene:[LevelCompleted scene]]];
    //[[HelloWorldLayer sharedHelloWorldLayer]doLevelComplete];
    CCLOG(@"on level completed");
     */
}
-(void)removeScoreChange:(CCNode*)sender{
	[[HelloWorldLayer sharedHelloWorldLayer]removeChild:sender cleanup:YES];
}
-(void)dealloc{
	[super dealloc];
}
@end
