//
//  standardWall.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "standardWall.h"


@implementation standardWall
-(id) initWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions
{
	if ((self = [super init])) {
        initType = 1;
		[self createWallInWorld:world position:blockposition Dimensions:blockDimensions];
	}
	return self;
}
-(id) initWithWorld:(b2World *)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions rotation:(float)currotation{
	if ((self = [super init])) {
		initType = 2;
        _blockPosition = blockposition;
        _blockDimensions = blockDimensions;
        _crotation = currotation;
        
        blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
        blockposition = [Helper relativePointFromPoint:blockposition];
		b2BodyDef bodyDef;
		bodyDef.type = b2_staticBody;
		bodyDef.position = ([Helper toMeters:blockposition]);
		bodyDef.angle = CC_DEGREES_TO_RADIANS(currotation);
		//bodyDef.angularDamping = 0.9f;
		//bodyDef.linearDamping = 0.9f;
		
		NSString * spriteFrameName = @"staticTexture.png";
		
		//CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
		//texture
		
		CCLOG(@"standard wall inited");
		
		b2PolygonShape shape;
		shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 1.0f;
		fixtureDef.friction = 0.2f;
		fixtureDef.restitution = 0.5f;
		CGRect creationRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
		super.dimensions = blockDimensions;
        super.usesSpriteBatch = YES;
        super.contactColor = ccc3(150, 150, 150);
        
		[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect rotation:currotation];
	}
	return self;
}
+(id)wallWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize) blockDimensions
{
	return [[[self alloc] initWithWorld:world position:blockposition Dimensions:blockDimensions]autorelease];
}
+(id)wallWithWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions Rotation:(float)currotation{
	//CCLOG(@"%f",currotation);
	return [[[self alloc]initWithWorld:world position:blockposition Dimensions:blockDimensions rotation:currotation]autorelease];
}
-(void) dealloc
{
	[super dealloc];
}
-(void)createWallInWorld:(b2World*)world position:(CGPoint)blockposition Dimensions:(CGSize)blockDimensions{
	
    _blockPosition = blockposition;
    _blockDimensions = blockDimensions;
    
	blockposition = [Helper relativePointFromPoint:blockposition];
	blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
	bodyDef.position = ([Helper toMeters:blockposition]);
	//bodyDef.angularDamping = 0.9f;
	//bodyDef.linearDamping = 0.9f;
	
	NSString * spriteFrameName = @"staticTexture.png";
	
	//CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
	//texture
	
	
	
	b2PolygonShape shape;
	shape.SetAsBox(blockDimensions.width / PTM_RATIO, blockDimensions.height / PTM_RATIO);
	b2FixtureDef fixtureDef;
	
	fixtureDef.shape = &shape; //cshape
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.2f;
	fixtureDef.restitution = 0.5f;
	CGRect creationRect = CGRectMake(0, 0, blockDimensions.width, blockDimensions.height);
	super.dimensions = blockDimensions;
	super.usesSpriteBatch = YES;
    super.contactColor = ccc3(150, 150, 150);

	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * sizeValue = [NSValue valueWithCGSize:_blockDimensions];
    NSValue * pointValue = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    NSNumber * ninitType = [NSNumber numberWithInt:initType];
    [aCoder encodeObject:sizeValue forKey:@"sizeValue"];
    [aCoder encodeObject:pointValue forKey:@"pointValue"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:ninitType forKey:@"ninitType"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * sizeValue = [aDecoder decodeObjectForKey:@"sizeValue"];
    NSValue * pointValue = [aDecoder decodeObjectForKey:@"pointValue"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    NSNumber * ninitType = [aDecoder decodeObjectForKey:@"ninitType"];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    if (ninitType.intValue == 2) {
        [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pointValue CGPointValue] Dimensions:[sizeValue CGSizeValue] rotation:rotation.floatValue];
    }
    if (ninitType.intValue ==1) {
        [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[pointValue CGPointValue] Dimensions:[sizeValue CGSizeValue]];
    }
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    
    /*[sizeValue release];
    [pointValue release];
    [rotation release];
    [ninitType release];*/
    
    return self;
}

-(BaseLevelObject*)copy{
	BaseLevelObject * instance = [standardWall wallWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] position:[Helper toPixels:self.body->GetWorldCenter()] Dimensions:super.dimensions Rotation:CC_RADIANS_TO_DEGREES(self.body->GetAngle())];
	return instance;
}
@end
