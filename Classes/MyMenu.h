//
//  MyMenu.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyMenu : CCMenu {
	BOOL isContinuous;
}
@property (nonatomic,readwrite) BOOL isContinuous;
//this menu supports continues calling on an item and checks rects in a smarter way then old ccmenu, allowing it to be moved around.
@end
