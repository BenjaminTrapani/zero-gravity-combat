//
//  ObjectProperty.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectProperty : NSObject {
    NSString * name;
    id value;
}
+(id)propertyWithName:(NSString*)name Value:(id)val;
@property (nonatomic,assign) NSString * name;
@property (nonatomic,assign) id value;
@end
