//
//  MainMenu.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDXAudioNode.h"
#import "ZGCGKHelper.h"
@interface MainMenu : CCLayer <GameKitHelperProtocol>{
	CCMenuItem * unmuted; 
	CCMenuItem * muted;
	//CDXAudioNode * buttonClick;
}
+(id)scene;
-(void)doPlay;
-(void)doArmory;
-(void)doStats;
-(void)switchSound:(id)sender;

@end
