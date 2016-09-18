//
//  DeletionManager.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeletionManager.h"


@implementation DeletionManager
static DeletionManager * instanceOfDM;

+(id) alloc
{
	@synchronized(self)
	{
		NSAssert(instanceOfDM == nil, @"Attempted to allocate a second instance of the singleton: DeletionManager");
		instanceOfDM = [[super alloc] retain];
		return instanceOfDM;
	}
	return nil;
}

+(DeletionManager*) sharedDeletionManager
{
	@synchronized(self)
	{
		if (instanceOfDM== nil)
		{
			[[DeletionManager alloc] init];
		}
		
		return instanceOfDM;
	}
	
	// to avoid compiler warning
	return nil;
}
-(id) init
{
	if ((self =[super init])) {
		objectsToDelete = [[NSMutableArray alloc]initWithCapacity:100];
		objectsToReset = [[NSMutableArray alloc]initWithCapacity:100];
	}
	
	
	return self;
}

-(void)addObjectForDeletion:(id)object{
	//[object retain];
	[objectsToDelete addObject:object];
	
	//CCLOG(@"object added to delete pool");
}
-(void)addObjectForReset:(id)object{
	//[object retain];
	[objectsToReset addObject:object];
	
}
-(BOOL)deleteObjects{
	//delete stuff
	int otdCount = [objectsToDelete count];
	
	if (otdCount == 0) {
		return YES;
	}
	deleteIndex ++;
	if (deleteIndex>otdCount-1) {
		deleteIndex = 0;
	}
	id object = [objectsToDelete objectAtIndex:deleteIndex];
	if (!object) {
		return NO;
	}
	id parent = [object parent];
	[parent removeChild:object cleanup:YES]; //step into this
	[object removeSprite];
	[object removeBody];
	//
	[objectsToDelete removeObjectAtIndex:deleteIndex]; 
	return NO;
	//[object dealloc];
		}
-(BOOL)resetObjects{
	int otrCount = [objectsToReset count];
	if (otrCount==0){
		return YES;
	}
	//reset stuff
	
	
	
	resetIndex ++;
	if (resetIndex>otrCount-1) {
		resetIndex = 0;
	}
	BodyNode* resetObject = (BodyNode*)[objectsToReset objectAtIndex:resetIndex];
	resetObject.body->SetActive(NO);
	resetObject.sprite.visible = NO;
	CGPoint newPos = CGPointMake(-200, -200);
	b2Vec2 vecPos = [Helper toMeters:newPos];
	resetObject.body->SetTransform(vecPos,0);
	[objectsToReset removeObjectAtIndex:resetIndex];
	//CCLOG(@"otdCount = %i",otdCount);
	//if (otdCount>0) {
	//for (int i = 0; i<otdCount; i++) {
	//id object = [objectsToDelete objectAtIndex:i];
	//id parent = [object parent];
	//[parent removeChild:object cleanup:YES]; //step into this
	//[object removeSprite];
	//[object removeBody];
	//[objectsToDelete removeObjectAtIndex:i]; //this automatically deallocs the object. Step further into removeChild
	////[object dealloc];
	
	return NO;
	//}
	
	
}
-(void)clearDeletes{
	CCLOG(@"clearDeletes called");
	[objectsToReset removeAllObjects];
	[objectsToDelete removeAllObjects];
	/*BOOL empty = NO;
	while (empty == NO) {
		empty = [self deleteObjects];
		CCLOG(@"emptying");
	}
	empty = NO;
	while (empty == NO) {
		empty = [self resetObjects];
	}*/
}
-(void) dealloc
{
	CCLOG(@"deletionManager dealloced");
	instanceOfDM = nil;
	[objectsToDelete release];
	[objectsToReset release];
	[super dealloc];
}

@end
