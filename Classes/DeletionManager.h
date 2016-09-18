//
//  DeletionManager.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BodyNode.h"
@interface DeletionManager : NSObject {
	NSMutableArray * objectsToDelete;
	NSMutableArray * objectsToReset;
	int deleteIndex;
	int resetIndex;
}
+(DeletionManager*)sharedDeletionManager;
-(void)addObjectForDeletion:(id)object;
-(void)addObjectForReset:(id)object;
-(BOOL)deleteObjects;
-(BOOL)resetObjects;
-(void)clearDeletes;
@end
