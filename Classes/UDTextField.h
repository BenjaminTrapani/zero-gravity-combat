//
//  UDTextField.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UDTextField : UITextField {
    id userData;
}
@property (nonatomic,retain) id userData;
@end
