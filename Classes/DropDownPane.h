//
//  DropDownPane.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DropDownPane : CCNode {
   
}
-(id)initWithText:(NSString *) text fontSize:(float)size;
-(void)moveOut;
+(id)dropDownPaneWithText:(NSString*)text fontSize:(float)size;
-(void)removeThis;
@end
