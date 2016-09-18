//
//  GroundBlock.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GroundBlock.h"


@implementation GroundBlock
-(id)initWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize{
    if ((self = [super init])) {
        pos = [Helper relativePointFromPoint:pos];
        _aSize = CGSizeMake(aSize.width,aSize.height);
        aSize = [Helper relativeSizeFromSize:aSize];
        super.destructible = NO;
        super.contactColor = ccc3(194, 121, 89);
        super.dimensions = aSize;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = ([Helper toMeters:pos]);
        bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
        //bodyDef.angularDamping = 0.9f;
        //bodyDef.linearDamping = 0.9f;
        
        NSString * spriteFrameName = @"level2Ground.png";
        
        //CCTexture2D * texture = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:spriteFrameName]];
        //texture
        
        
        
        b2PolygonShape shape;
        shape.SetAsBox(aSize.width / PTM_RATIO, aSize.height / PTM_RATIO);
        b2FixtureDef fixtureDef;
        
        fixtureDef.shape = &shape; //cshape
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 1.0f;
        fixtureDef.restitution = 0.2f;
        CGRect creationRect = CGRectMake(0, 0, aSize.width, aSize.height);
                
        [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName rect:creationRect];

    }
    return self;
}
+(id)groundBlockWithWorld:(b2World*)world Position:(CGPoint)pos Rotation:(float)rotation Size:(CGSize)aSize{
    return [[[self alloc]initWithWorld:world Position:pos Rotation:rotation Size:aSize]autorelease];
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * sizeValue = [NSValue valueWithCGSize:_aSize];
    NSValue * pointValue = [NSValue valueWithCGPoint:[Helper toPixels:super.body->GetWorldCenter()]];
    NSNumber * rotation = [NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(super.body->GetAngle())];
    [aCoder encodeObject:sizeValue forKey:@"sizeValue"];
    [aCoder encodeObject:pointValue forKey:@"pointValue"];
    [aCoder encodeObject:rotation forKey:@"rotation"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    NSValue * sizeValue = [aDecoder decodeObjectForKey:@"sizeValue"];
    NSValue * pointValue = [aDecoder decodeObjectForKey:@"pointValue"];
    NSNumber * rotation = [aDecoder decodeObjectForKey:@"rotation"];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position:[pointValue CGPointValue] Rotation:rotation.floatValue Size:[sizeValue CGSizeValue]];
    
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
}
@end;