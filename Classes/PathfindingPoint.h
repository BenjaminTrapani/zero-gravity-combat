//
//  PathfindingPoint.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PathfindingPoint : NSObject {
	CGPoint point;
	float f;
	float g;
	float h;
	PathfindingPoint * parent;
	BOOL shouldIgnore;
}
@property(nonatomic,readwrite)CGPoint point;
@property(nonatomic,readwrite)float f;
@property(nonatomic,readwrite)float g;
@property(nonatomic,readwrite)float h;
@property(nonatomic,assign)PathfindingPoint * parent;
@property(nonatomic,readwrite)BOOL shouldIgnore;
+(id)PP;
@end
