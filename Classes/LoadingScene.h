//
//  LoadingScene.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ZGCGKHelper.h"
#define LoadingImageCount 3
@interface LoadingScene : CCScene <GameKitHelperProtocol>{
    CCLabelTTF * loading;
    BOOL loaded;
    float waitTime;
    BOOL hasAuthenticated;
    
}
+(CCScene*)scene;
-(void)asyncAnim;
-(void)update:(ccTime)delta;
@end
