//
//  MyMenuItem.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyMenuItem : CCMenuItemSprite {
	id customData;
}
@property (nonatomic,retain)id customData;
@end
