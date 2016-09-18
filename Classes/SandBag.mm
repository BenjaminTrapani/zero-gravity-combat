//
//  SandBag.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SandBag.h"
#import "Options.h"
#import "BaseLevelObject.h"
#import "CDXAudioNode.h"
@implementation SandBag
-(id) initWithWorld:(b2World*)world position:(CGPoint)blockposition numberOfBags:(NSUInteger)bags radius:(NSUInteger)curRadius sizeVariance:(NSUInteger)variance
{
	if ((self = [super init])) {
        initType = 1;
        _pos = blockposition;
        _bags = bags;
        _curRadius = curRadius;
        _variance = variance;
        blockposition = [Helper relativePointFromPoint:blockposition];
		for (int c = 0; c<bags; c++) {
			b2BodyDef bodyDef;
			bodyDef.type = b2_dynamicBody;
			CGPoint curPos = CGPointMake(blockposition.x + (curRadius * CCRANDOM_MINUS1_1()), blockposition.y + (curRadius * CCRANDOM_MINUS1_1()));
			bodyDef.position = ([Helper toMeters:curPos]);
			//bodyDef.angularDamping = 0.9f;
			//bodyDef.linearDamping = 0.9f;
			
			NSString * spriteFrameName = @"sandBag.png";
			//CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
			//texture
			float realVariance = variance * CCRANDOM_MINUS1_1();
			CGSize blockDimensions = CGSizeMake([[Options sharedOptions]makeXConstantRelative:10+realVariance], [[Options sharedOptions]makeYConstantRelative:22+(realVariance*2.2)]);
			
			b2PolygonShape shape;
			shape.SetAsBox((blockDimensions.width / PTM_RATIO)/2, (blockDimensions.height / PTM_RATIO)/2);
			b2FixtureDef fixtureDef;
			
			fixtureDef.shape = &shape; //cshape
			fixtureDef.density = 1.0f;
			fixtureDef.friction = 0.2f;
			fixtureDef.restitution = 0.5f;
			
			CGRect bagRect = CGRectMake(curPos.x,curPos.y,blockDimensions.width/2+variance, blockDimensions.height/2+variance);
			
			BaseLevelObject * creator = [[BaseLevelObject alloc]init];
			creator.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"sandBagParticle.plist"];
			creator.health = 200;
			creator.destructible = YES;
			creator.destructionSound = [CDXAudioNode audioNodeWithFile:@"woodBreakSFX.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];;
			creator.contactColor = ccc3(222,184,135);
			creator.usesSpriteBatch = YES;
			[creator createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:bagRect];
			[self addChild:creator];
			/*b2RevoluteJointDef jd;
			jd.enableLimit = true;
			jd.upperAngle = 0;
			jd.lowerAngle = 0;
			jd.Initialize(curBag, bodyToAttach, [Helper toMeters:pointToAttach]);
			world->CreateJoint(&jd);
			*/[creator release];
			
			//add the option to organize bags in some way. Figure out a way to link all the bags as one to another body.
		
		}
		//[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
	}
	return self;
}

-(id)initWithWorld:(b2World*)world position:(CGPoint)pos rows:(int)rows columns:(int)columns sizeVariance:(float)variance body:(BodyNode*)bodyToAttach point:(CGPoint)pointToAttach{
    
	if ((self = [super init])) {
        initType = 2;
        _pos = pos;
        _rows = rows;
        _columns = columns;
        _variance = variance;
        _bodyToAttach = bodyToAttach;
        _pointToAttach = pointToAttach;
        pos = [Helper relativePointFromPoint:pos];
        int totalObjects = rows*columns;
		int curRow = -1; 
		int curColumn = 0;
		CGPoint startPos = pos;
        bodyToAttach.destructionListener = self;
		for (int c = 0; c<totalObjects; c++) {
			
			curRow++;
			if (curRow>=columns) {
				curColumn++;
				curRow = 0;
			}
			
			
			//CCLOG(@"creating bags");
			b2BodyDef bodyDef;
			bodyDef.type = b2_dynamicBody;//b2_staticBody;
			//creat bodies from right to left, top to bottom.
			float realVariance = variance * CCRANDOM_MINUS1_1();
			CGSize blockDimensions = CGSizeMake([[Options sharedOptions]makeXConstantRelative:10+realVariance], [[Options sharedOptions]makeYConstantRelative:22+(realVariance*2.2)]);
			CGPoint curPos = ccp(startPos.x + (blockDimensions.width*curRow), startPos.y - (blockDimensions.height*curColumn));
			bodyDef.position = ([Helper toMeters:curPos]);
			//bodyDef.angularDamping = 0.9f;
			//bodyDef.linearDamping = 0.9f;
			
			NSString * spriteFrameName = @"sandBag.png";
			//CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
			//texture
			
			
			b2PolygonShape shape;
			shape.SetAsBox((blockDimensions.width / PTM_RATIO)/2, (blockDimensions.height / PTM_RATIO)/2);
			b2FixtureDef fixtureDef;
			
			fixtureDef.shape = &shape; //cshape
			fixtureDef.density = 1.0f;
			fixtureDef.friction = 0.6f;
			fixtureDef.restitution = 0.2f;
			
			CGRect bagRect = CGRectMake(curPos.x,curPos.y,blockDimensions.width/2, blockDimensions.height/2);
			
			BaseLevelObject * creator = [[BaseLevelObject alloc]init];
			creator.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"sandBagParticle.plist"];
			creator.health = 200;
			creator.destructible = YES;
			creator.destructionSound = [CDXAudioNode audioNodeWithFile:@"woodBreakSFX.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];;
			creator.contactColor = ccc3(222,184,135);
			creator.usesSpriteBatch = YES;
			b2Body * curBag = [creator createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:bagRect];
			[self addChild:creator];
			b2RevoluteJointDef jd;
			jd.enableLimit = true;
			jd.upperAngle = 0;
			jd.lowerAngle = 0;
			jd.Initialize(curBag, bodyToAttach.body, [Helper toMeters:pointToAttach]);
			world->CreateJoint(&jd);
			[creator release];
			
			
						
			
		}
		/*for (int c = 0; c<bags; c++) {
			CCLOG(@"creating bags");
			b2BodyDef bodyDef;
			bodyDef.type = b2_dynamicBody;//b2_staticBody;
			//creat bodies from right to left, top to bottom.
			float realVariance = variance * CCRANDOM_MINUS1_1();
			CGSize blockDimensions = CGSizeMake([[Options sharedOptions]makeXConstantRelative:10+realVariance], [[Options sharedOptions]makeYConstantRelative:22+(realVariance*2.2)]);
			currentRow++;
			if (currentRow>rows) {
				currentRow = 0;
				currentColumn++;
				if (currentColumn>columns) {
					break;
				}
			}
			CGPoint curPos = CGPointMake(startPos.x+(blockDimensions.width*currentColumn),startPos.y - (blockDimensions.height*currentRow));
			bodyDef.position = ([Helper toMeters:curPos]);
			//bodyDef.angularDamping = 0.9f;
			//bodyDef.linearDamping = 0.9f;
			
			NSString * spriteFrameName = @"sandBag.png";
			//CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
			//texture
			
			
			b2PolygonShape shape;
			shape.SetAsBox((blockDimensions.width / PTM_RATIO)/2, (blockDimensions.height / PTM_RATIO)/2);
			b2FixtureDef fixtureDef;
			
			fixtureDef.shape = &shape; //cshape
			fixtureDef.density = 1.0f;
			fixtureDef.friction = 0.6f;
			fixtureDef.restitution = 0.2f;
			
			CGRect bagRect = CGRectMake(curPos.x,curPos.y,blockDimensions.width/2, blockDimensions.height/2);
			
			BaseLevelObject * creator = [[BaseLevelObject alloc]init];
			creator.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"sandBagParticle.plist"];
			creator.health = 200;
			creator.destructible = YES;
			creator.destructionSound = [CDXAudioNode audioNodeWithFile:@"woodBreakSFX.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];;
			creator.contactColor = ccc3(222,184,135);
			
			b2Body * curBag = [creator createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:bagRect];
			[self addChild:creator];
			b2RevoluteJointDef jd;
			jd.enableLimit = true;
			jd.upperAngle = 0;
			jd.lowerAngle = 0;
			jd.Initialize(curBag, bodyToAttach, [Helper toMeters:pointToAttach]);
			world->CreateJoint(&jd);
			[creator release];
			 
			//add the option to organize bags in some way. Figure out a way to link all the bags as one to another body.
			
		}
		 */
		//[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
	}
	return self;
	
}
-(void)onObjectDestroyed:(BodyNode*)obj{
    
    if ([Options sharedOptions].isUsingEditor==YES) {
        CCArray * children = [self children];
        for (BodyNode * child in children) {
            child.shouldDelete = YES;
        }
        [self removeFromParentAndCleanup:YES];
    }
    
}
-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup{
   // CCLOG(@"remove child called for sandbag");
    if ([Options sharedOptions].isUsingEditor) {
        //CCLOG(@"children count = %i",[[self children]count]);
        if ([[self children]count]<=1) {
            [self removeFromParentAndCleanup:YES];
            CCLOG(@"sandbag removed");
        }
    }
    [super removeChild:node cleanup:cleanup];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSNumber * ninitType = [NSNumber numberWithInt:initType];
    [aCoder encodeObject:ninitType forKey:@"ninitType"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    CCArray * children = [self children];
    float totalX;
    float totalY;
    int objectCount = [children count];
    for (CCNode * child in children) {
        CGPoint childPos = child.position;
        totalX += childPos.x;
        totalY+= childPos.y;
    }
    totalX/=objectCount;
    totalY/=objectCount;
    _pos = CGPointMake(totalX, totalY);
    if (initType==1) {
        NSValue * cgPointValue = [NSValue valueWithCGPoint:_pos];
        NSNumber * bags = [NSNumber numberWithInt:_bags];
        NSNumber * curRadius = [NSNumber numberWithInt:_curRadius];
        NSNumber * variance = [NSNumber numberWithFloat:_variance];
        [aCoder encodeObject:cgPointValue forKey:@"cgPointValue"];
        [aCoder encodeObject:bags forKey:@"bags"];
        [aCoder encodeObject:curRadius forKey:@"curRadius"];
        [aCoder encodeObject:variance forKey:@"variance"];
    }
    if (initType==2) {
        NSValue * cgPointValue = [NSValue valueWithCGPoint:_pos];
        NSNumber * rows = [NSNumber numberWithInt:_rows];
        NSNumber * columns = [NSNumber numberWithInt:_columns];
        NSNumber * variance = [NSNumber numberWithFloat:_variance];
        //NSNumber * bodyID = [NSNumber numberWithInt:_bodyToAttach->getBodyID()];
        NSValue * pointToAttachVal = [NSValue valueWithCGPoint:_pointToAttach];
        [aCoder encodeObject:cgPointValue forKey:@"cgPointValue"];
        [aCoder encodeObject:rows forKey:@"rows"];
        [aCoder encodeObject:columns forKey:@"columns"];
        [aCoder encodeObject:variance forKey:@"variance"];
        [aCoder encodeObject:[NSString stringWithFormat:@"%@",_bodyToAttach.uniqueID] forKey:@"bodyID"];
        [aCoder encodeObject:pointToAttachVal forKey:@"pointToAttachVal"];
        
    }
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    return nil;
    NSValue * cgPointValue = [aDecoder decodeObjectForKey:@"cgPointValue"];
    NSNumber * rows = [aDecoder decodeObjectForKey:@"rows"];
    NSNumber * columns = [aDecoder decodeObjectForKey:@"columns"];
    NSNumber * variance = [aDecoder decodeObjectForKey:@"variance"];
    NSString * bodyID = [aDecoder decodeObjectForKey:@"bodyID"];
    NSValue * pointToAttachVal = [aDecoder decodeObjectForKey:@"pointToAttachVal"];
    NSNumber * bags = [aDecoder decodeObjectForKey:@"bags"];
    NSNumber * curRadius = [aDecoder decodeObjectForKey:@"curRadius"];
    NSNumber * numInitType = [aDecoder decodeObjectForKey:@"ninitType"];
    int curInitType = numInitType.intValue;
    b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
    BodyNode * initBody = nil;
    
    
    
    //CCLOG(@"initType = %i",curInitType);
    if (curInitType==1) {
    
        [self initWithWorld:world position:[cgPointValue CGPointValue] numberOfBags:bags.intValue radius:curRadius.intValue sizeVariance:variance.floatValue];
    }
    if (curInitType==2) {
        
        CCArray * levelChildren = [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]children];
        //CCLOG(@"saved id = %@",bodyID) ;
        
        for (CCNode * child in levelChildren){
            //CCLOG(@"nbodyID = %i",nbody->getBodyID());
            CCLOG(@"unique ID = %@",((BodyNode*)child).uniqueID);
            
            if([((BodyNode*)child).uniqueID isEqualToString:bodyID]){
                initBody = (BodyNode*)child;
            }
            
            
        }
        
        
        NSAssert(initBody!=NULL,@"bodyToAttach in sandbag not found");

        
        [self initWithWorld:world position:[cgPointValue CGPointValue] rows:rows.intValue columns:columns.intValue sizeVariance:variance.floatValue body:initBody point:[pointToAttachVal CGPointValue]];
    }
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
+(id)sandbagWithWorld:(b2World*)world position:(CGPoint)blockposition numberOfBags:(NSUInteger)bags radius:(NSUInteger)curRadius sizeVariance:(NSUInteger)variance
{
	return [[[self alloc] initWithWorld:world position:blockposition numberOfBags:bags radius:curRadius sizeVariance:variance]autorelease];
}
+(id)sandbagWithWorld:(b2World *)world position:(CGPoint)blockposition rows:(int)rows columns:(int)columns sizeVariance:(float)variance body:(BodyNode*)bodyToAttach point:(CGPoint)pointToAttach{
	return [[[self alloc] initWithWorld:world position:blockposition rows:rows columns:columns sizeVariance:variance body:bodyToAttach point:pointToAttach]autorelease];
}

-(void) dealloc
{
    
	[super dealloc];
}

@end
