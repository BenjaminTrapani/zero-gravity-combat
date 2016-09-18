//
//  GeneratorSwitch.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"

@interface GeneratorSwitch : BaseLevelObject <NSCoding>{
    //id <GeneratorSwitchDelegate> delegate;
    CGPoint _pos;
    float _rotation;
    CGSize _dimensions;
    
}

-(void)onObjectDestroyed:(BaseLevelObject*)obj;
+(id)generatorSwitchWithWorld:(b2World*)world position:(CGPoint)pos Rotation:(float)rotation Dimensions:(CGSize)dimensions Objects:(NSMutableArray*)objs Event:(SwitchEvent)event;
@end
