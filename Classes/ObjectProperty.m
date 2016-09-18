//
//  ObjectProperty.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectProperty.h"


@implementation ObjectProperty
@synthesize  value, name;

-(id)initWithName:(NSString*)_name Value:(id)_value{
    if ((self = [super init])) {
        name= _name;
        value = _value;
    }
    return self;
}
+(id)propertyWithName:(NSString*)name Value:(id)val{
    return [[[self alloc]initWithName:name Value:val]autorelease];
}
@end
