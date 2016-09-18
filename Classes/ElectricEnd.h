//
//  ElectricEnd.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLevelObject.h"
@interface ElectricEnd : BaseLevelObject {
	float _range;
	BOOL enabled;
}
@property(nonatomic,readwrite) BOOL enabled;
+(id)electricEndWithWorld:(b2World*)world Position:(CGPoint)pos Radius:(float)radius Range:(float)range Enabled:(BOOL)curEnabled FileName:(NSString*)fileName;
@end
