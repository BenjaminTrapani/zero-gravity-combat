//
//  UDTextField.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UDTextField.h"


@implementation UDTextField
@synthesize userData;
-(void)dealloc{
    [userData release];
    [super dealloc];
}
@end
