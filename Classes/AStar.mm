//
//  AStar.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "AStar.h"
#import "ccMacros.h"
#import "CGPointExtension.h"

@implementation ShortestPathStep

@synthesize position;
@synthesize gScore;
@synthesize hScore;
@synthesize parent;

- (id)initWithPosition:(CGPoint)pos
{
	if ((self = [super init])) {
		position = pos;
		gScore = 0;
		hScore = 0;
		parent = nil;
		
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@  pos=[%.0f;%.0f]  g=%d  h=%d  f=%d", [super description], self.position.x, self.position.y, self.gScore, self.hScore, [self fScore]];
}

- (BOOL)isEqual:(ShortestPathStep *)other
{
	return CGPointEqualToPoint(self.position, other.position);
}

- (int)fScore
{
	return self.gScore + self.hScore;
}

@end

@implementation AStar
@synthesize delegate,openList,closedList,longestEdge,allowDiagonals,disabled;

-(id)init{
	if ((self = [super init])) {
		//closedList = [[NSMutableArray alloc]initWithCapacity:100];
		//openList = [[NSMutableArray alloc]initWithCapacity:100];
		disabled = NO;
	}
	return self;
}
-(void)dealloc{
	//[[NSRunLoop currentRunLoop]cancelPerformSelectorsWithTarget:self];
	[closedList dealloc];
	closedList = nil;
	[openList dealloc];
	openList = nil;
	//[delegate release];
	[super dealloc];
}
-(void)createPath:(CGPoint)start Goal:(CGPoint)goal{
	NSAssert(start.x!=goal.x && start.y!=goal.y,@"start and goal can't be the same in astar");
    //int closedCount = [closedList count];
    //int openCount = [openList count];
    /*for (int i = 0; closedCount; i++) {
        ShortestPathStep * curStep = (ShortestPathStep*)[closedList objectAtIndex:i];
        [openList
        [curStep dealloc];
    }
    for (int i = 0; openCount; i++) {
        ShortestPathStep * curStep = (ShortestPathStep*)[openList objectAtIndex:i];
        [curStep dealloc];
    }*/
	
    NSAssert(closedList == nil,@"closedList doesnt equal nil");
    NSAssert(openList == nil,@"openList doesnt equal nil");
    closedList = [[NSMutableArray alloc]initWithCapacity:100];
    openList = [[NSMutableArray alloc]initWithCapacity:100];
    //[openList removeAllObjects];
    //[openList removeAllObjects];
	curGoal = goal;
	// Start by adding the from position to the open list
    ShortestPathStep * firstStep = [[ShortestPathStep alloc]initWithPosition:start];
	[self insertInOpenSteps:firstStep];
    [firstStep release];
    [self unschedule:@selector(stepPath:)];
    [self schedule:@selector(stepPath:) interval:0.5f];
    CCLOG(@"creat path called");
}

-(void)stepPath:(ccTime)delta{
    //CCLOG(@"a star stepping path");
    ShortestPathStep *currentStep;
    BOOL pathFound = NO;
	//do {
		if (disabled) {
			return;
		}
		// Get the lowest F cost step
		// Because the list is ordered, the first step is always the one with the lowest F cost
		currentStep = [openList objectAtIndex:0];
    //if (currentStep == nil) {
     //   CCLOG(@"currentStep = nil");
   // }
		//CCLOG(@"currentStep.x = %f CurrentStep.y = %f",currentStep.position.x, currentStep.position.y);
		// Add the current step to the closed set
		[closedList addObject:currentStep];
		
		// Remove it from the open list
		// Note that if we wanted to first removing from the open list, care should be taken to the memory
        
        [openList removeObjectAtIndex:0];
        
    
		
		// If the currentStep is the desired tile coordinate, we are done!
		if (ccpDistance(currentStep.position, curGoal)<longestEdge) { //doesn't have to equal it exactly
            
            pathFound = YES;
            ShortestPathStep *tmpStep = currentStep;
            CCLOG(@"PATH FOUND :");
            NSMutableArray * result = [[NSMutableArray array]retain];
            do {
                //NSLog(@"%@", tmpStep);
                [result insertObject:tmpStep atIndex:0];
                //NSAssert(CGPointEqualToPoint(tmpStep.position, tmpStep.parent.position)==NO,@"can't have two points with the same position");
                //[tmpStep release];
                tmpStep = tmpStep.parent; // Go backward
            } while (tmpStep != nil); // Until there is not more parent
            [openList release];
            [closedList release];

            openList = nil; // Set to nil to release unused memory
            closedList = nil; // Set to nil to release unused memory
                        [delegate onPathDone:result];
            [self unschedule:@selector(stepPath:)];
            //return result;
            //break;
            
			
		}
		
		// Get the adjacent tiles coord of the current step
		NSArray *adjSteps = [self walkableAdjacentTilesCoordForTileCoord:currentStep];
		for (NSValue *v in adjSteps) {
			ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
			
			// Check if the step isn't already in the closed set 
			if ([closedList containsObject:step]) {
				[step release]; // Must releasing it to not leaking memory ;-)
				continue; // Ignore it
			}		
			
			// Compute the cost from the current step to that step
			int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
			
			// Check if the step is already in the open list
			NSUInteger index = [openList indexOfObject:step];
			
			if (index == NSNotFound) { // Not on the open list, so add it
				
				// Set the current step as the parent
				step.parent = currentStep;
				
				// The G score is equal to the parent G score + the cost to move from the parent to it
				step.gScore = currentStep.gScore + moveCost;
				
				// Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
				step.hScore = [self computeHScoreFromCoord:step.position toCoord:curGoal];
				
				// Adding it with the function which is preserving the list ordered by F score
				[self insertInOpenSteps:step];
				
				// Done, now release the step
				[step release];
			}
			else { // Already in the open list
				
				[step release]; // Release the freshly created one
				step = [openList objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
				
				// Check to see if the G score for that step is lower if we use the current step to get there
				if ((currentStep.gScore + moveCost) < step.gScore) {
					
					// The G score is equal to the parent G score + the cost to move from the parent to it
					step.gScore = currentStep.gScore + moveCost;
					
					// Because the G Score has changed, the F score may have changed too
					// So to keep the open list ordered we have to remove the step, and re-insert it with
					// the insert function which is preserving the list ordered by F score
					
					// We have to retain it before removing it from the list
					[step retain];
					
					// Now we can removing it from the list without be afraid that it can be released
					[openList removeObjectAtIndex:index];
					
					// Re-insert it with the function which is preserving the list ordered by F score
					[self insertInOpenSteps:step];
					
					// Now we can release it because the oredered list retain it
					[step release];
				}
			}
		}
		
	//} while ([openList count] > 0);
	if ([openList count]== 0) {
        
    
        if (!pathFound) { // No path found
            //[[SimpleAudioEngine sharedEngine] playEffect:@"hitWall.wav"];
            [self unschedule:@selector(stepPath:)];
            CCLOG(@"ASTAR:PATHNOTFOUND:((((((((:(:(:(:(:((::(:((:(:(:(:((:(");
            /*ShortestPathStep *tmpStep =currentStep;
		
             NSMutableArray * result = [[NSMutableArray array]retain];
             do {
             //NSLog(@"%@", tmpStep);
             [result insertObject:tmpStep atIndex:0];
             tmpStep = tmpStep.parent; // Go backward
             } while (tmpStep != nil); // Until there is not more parent
             */
            openList = nil; // Set to nil to release unused memory
            closedList = nil; // Set to nil to release unused memory
		
            [delegate onPathNotFound];
        
        }
    }
	//return nil;

}

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(ShortestPathStep*)stileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8];
	
	CGPoint tileCoord = stileCoord.position;
    NSAssert(stileCoord!=nil,@"cant ask for adjacent tiles with a nil starting step");
	CGPoint cast1 = ccp(tileCoord.x-longestEdge,tileCoord.y);
	CGPoint cast2 = ccp(tileCoord.x-longestEdge/2,tileCoord.y-longestEdge/2);
	CGPoint cast3 = ccp(tileCoord.x,tileCoord.y-longestEdge);
	CGPoint cast4 = ccp(tileCoord.x+longestEdge/2,tileCoord.y-longestEdge/2);
	CGPoint cast5 = ccp(tileCoord.x+longestEdge,tileCoord.y);
	CGPoint cast6 = ccp(tileCoord.x+longestEdge/2,tileCoord.y+longestEdge/2);
	CGPoint cast7 = ccp(tileCoord.x,tileCoord.y+longestEdge);
	CGPoint cast8 = ccp(tileCoord.x-longestEdge/2,tileCoord.y+longestEdge/2);
	if ([self isValidPoint:cast1 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast1]];
	}
	if ([self isValidPoint:cast2 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast2]];
	}	

	if ([self isValidPoint:cast3 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast3]];
	}	

	if ([self isValidPoint:cast4 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast4]];
	}	

	if ([self isValidPoint:cast5 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast5]];
	}	

	if ([self isValidPoint:cast6 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast6]];
	}	

	if ([self isValidPoint:cast7 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast7]];
	}	

	if ([self isValidPoint:cast8 parent:stileCoord]) {
		[tmp addObject:[NSValue valueWithCGPoint:cast8]];
	}	
	
	return [NSArray arrayWithArray:tmp];
}

-(BOOL)isValidPoint:(CGPoint)p parent:(ShortestPathStep*)parent{
	if ([delegate checkBounds:p]==YES && [delegate isWall:p parent:parent]==NO) {
		return YES;
	}
	return NO;
}
- (void)insertInOpenSteps:(ShortestPathStep *)step
{
	int stepFScore = [step fScore]; // Compute the step's F score
	int count = [openList count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[openList objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
			// Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[openList insertObject:step atIndex:i];
}

// Compute the H score from a position to another (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
	return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y);
}

// Compute the cost of moving from a step to an adjacent one
- (float)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	if (ccpDistance(fromStep.position, toStep.position)>longestEdge) {
		return 1.41;
	}
	return 1;
}
@end

