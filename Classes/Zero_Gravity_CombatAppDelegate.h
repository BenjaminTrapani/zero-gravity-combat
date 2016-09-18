//
//  Zero_Gravity_CombatAppDelegate.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGCGKHelper.h"

@class RootViewController;

@interface Zero_Gravity_CombatAppDelegate : NSObject <UIApplicationDelegate, GameKitHelperProtocol> {
	UIWindow			*window;
	RootViewController	*viewController;
	
}

@property (nonatomic, retain) UIWindow *window;

@end
