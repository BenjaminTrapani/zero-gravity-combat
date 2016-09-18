//
//
//  AStar.m
//
//  Created by Gabriel Hora (@gabriel_hora) on 27/01/11.
//  You can copy, change or whatever, just remeber to leave the credits
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface ShortestPathStep : NSObject
{
	CGPoint position;
	int gScore;
	int hScore;
	ShortestPathStep *parent;
   
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, assign) ShortestPathStep *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;

@end
//==============================================================================

@protocol AStarDelegate
// simple delegate to identify wall blocks
- (BOOL) isWall:(CGPoint)point parent:(ShortestPathStep*)parent;
- (BOOL) checkBounds:(CGPoint)point;
- (void) onPathDone:(NSMutableArray*)tempPath;
- (void) onPathNotFound;
@end


@interface AStar : CCNode {
	
	id <AStarDelegate> delegate;
	NSMutableArray *openList;
	NSMutableArray *closedList;
	BOOL allowDiagonals;
	float longestEdge;
	BOOL disabled;
    CGPoint curGoal;
   
}



@property (nonatomic, assign) id <AStarDelegate> delegate;
@property (nonatomic, assign) NSMutableArray *openList;
@property (nonatomic, assign) NSMutableArray *closedList;
@property (nonatomic, assign) float longestEdge;
@property (nonatomic, assign) BOOL disabled;
@property BOOL allowDiagonals;

- (void) createPath:(CGPoint)start Goal:(CGPoint)goal;
- (NSMutableArray *)walkableAdjacentTilesCoordForTileCoord:(ShortestPathStep*)tileCoord;
- (void)insertInOpenSteps:(ShortestPathStep *)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
- (float)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep;
-(BOOL)isValidPoint:(CGPoint)p parent:(ShortestPathStep*)parent;
@end

