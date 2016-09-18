//
//  LoadingScene.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"
#import "HelloWorldLayer.h"
#import "Helper.h"
#import "Options.h"
#import "MainMenu.h"

@implementation LoadingScene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadingScene*layer = [LoadingScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}
-(void)asyncAnim{
    while (!loaded) {
        loading.rotation+=1;
    }
}
-(id)init{
    if ((self = [super init])) {
        //[ZGCGKHelper sharedGameKitHelper].delegate = self;
        hasAuthenticated = NO;
        
                
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        CCSprite * loadingImage = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"sp%i.png",1+arc4random()%LoadingImageCount]];
        loadingImage.position = ccp(screenSize.width/2,screenSize.height/2);
        //CGSize relSize = [Helper relativeSizeFromSize:CGSizeMake(480, 320)];
        //loadingImage=[Helper scaleSprite:loadingImage toDimensions:relSize];
        [self addChild:loadingImage];
        
        loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"futured.ttf" fontSize:25];
        loading.position = ccp(loading.contentSize.width,loading.contentSize.height);
        [self addChild:loading];
        
        loaded = NO;
        //[self performSelectorInBackground:@selector(asyncAnim) withObject:nil];
        waitTime = 0.0f;
        [self schedule:@selector(update:)];
        
        ZGCGKHelper * helper = [ZGCGKHelper sharedGameKitHelper];
        helper.delegate = self;
        [helper authenticateLocalPlayer];

           
        

        
        
    }
    return self;
}
-(void)update:(ccTime)delta{
    
    
    waitTime += delta;
    if ([Options sharedOptions]->isLoading==NO) {
        if (waitTime>2.0f) {
            [self unschedule:@selector(update:)];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer node]]];
            
        }
    }else if(hasAuthenticated){
        if (waitTime>2.0f) {
            [self unschedule:@selector(update:)];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
        }
    }
    
}
-(void) onLocalPlayerAuthenticationChanged{
    CCLOG(@"ac");
    hasAuthenticated = YES;
    
}
-(void) onAchievementsLoaded:(NSDictionary*)achievements{
    CCLOG(@"al");
    
}

-(void)dealloc{
    CCLOG(@"loading scene deallocated");
    [ZGCGKHelper sharedGameKitHelper].delegate = nil;
    loaded = YES;
    [super dealloc];
}
    


@end
