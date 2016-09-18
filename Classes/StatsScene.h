//
//  StatsScene.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ZGCGKHelper.h"
@interface StatsScene : CCLayer <GameKitHelperProtocol>{
    ZGCGKHelper * helper;
    CGSize screenSize;
}
+(CCScene*)scene;
@end
