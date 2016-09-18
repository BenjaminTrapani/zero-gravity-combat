//
//  ObjectFactory.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
class ObjectFactory {
public:
    Class levelObjectClassForInt(int c);
    Class baseAIClassForInt(int c);
    static ObjectFactory * sharedObjectFactory();
};
/*@interface ObjectFactory : NSObject {
    
}
+(ObjectFactory*)sharedObjectFactory;

@end
void createObjectWithIDandProperties(NSString * ID,NSArray * properties);
*/