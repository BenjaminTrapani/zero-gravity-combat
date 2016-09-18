//
//  ElectricDoor.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElectricDoor.h"
#import "Options.h"
#import "SciFiBar.h"
#import "RotatingWheel.h"
#import "IronBar.h"
#import "IronBar.h"
#import "DoorSwitch.h"
#import "RaysCastCallback.h"
@implementation ElectricDoor
-(id)initWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius Width:(float)width switchPos:(CGPoint)sPos{
    if ((self = [super init])) {
        _pos1 = ccp(pos1.x,pos1.y);
        _pos2 = ccp(pos2.x,pos2.y);
        _sPos = ccp(sPos.x,sPos.y);
        _radius = radius;
        _width = width;
        
                
                
        pos1 = [Helper relativePointFromPoint:pos1];
        pos2 = [Helper relativePointFromPoint:pos2];
        float leftSideAngle = angleBetweenPoints(pos1, pos2);
        leftSideAngle+= CC_DEGREES_TO_RADIANS(270);
        float rightSideAngle = leftSideAngle + CC_DEGREES_TO_RADIANS(180);
        
        
        
        float relRadius = [[Options sharedOptions]makeAverageConstantRelative:radius];
        float relWidth = [[Options sharedOptions]makeAverageConstantRelative:width];
		CGSize blockDimensions; //= CGSizeMake(ccpDistance(_pos1, _pos2)/4, width);
        
        //if([Options sharedOptions].isIpad)
        //    blockDimensions = CGSizeMake(ccpDistance(_pos1, _pos2)/5, width);
        //else
            blockDimensions = CGSizeMake(ccpDistance(_pos1, _pos2)/4, width);
        
        CGPoint overallMidpoint = ccpMidpoint(pos1, pos2);
        
        SciFiBar* rightSideSlider = [SciFiBar sciFiBarWithWorld:world Position:ccpMidpoint(overallMidpoint, pos1) Rotation:CC_RADIANS_TO_DEGREES(rightSideAngle) Dimensions:blockDimensions];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:rightSideSlider];
        SciFiBar * leftSideSlider = [SciFiBar sciFiBarWithWorld:world Position:ccpMidpoint(overallMidpoint, pos2) Rotation:CC_RADIANS_TO_DEGREES(leftSideAngle) Dimensions:blockDimensions];
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:leftSideSlider];

        leftSideSlider.sprite.position = [Helper toPixels:leftSideSlider.body->GetWorldCenter()];
        rightSideSlider.sprite.position = [Helper toPixels:rightSideSlider.body->GetWorldCenter()];
        leftSideSlider.sprite.rotation = -(CC_RADIANS_TO_DEGREES(leftSideSlider.body->GetAngle()));
        rightSideSlider.sprite.rotation = -(CC_RADIANS_TO_DEGREES(leftSideSlider.body->GetAngle()));
        //sliders line up correctly without other interference
        //float negPadding = [[Options sharedOptions]makeAverageConstantRelative:0.1];
        CGPoint upperWheelPoint;
        CGPoint lowerWheelPoint;
        if([Options sharedOptions].isIpad){
            blockDimensions = [Helper relativeSizeFromSize:blockDimensions];
            float tRelRadius = relRadius * 2.4f;
            upperWheelPoint = ccp(overallMidpoint.x-blockDimensions.width*2+tRelRadius,overallMidpoint.y+tRelRadius + (relWidth)); //- negPadding);
            lowerWheelPoint = ccp(overallMidpoint.x-blockDimensions.width*2+tRelRadius,overallMidpoint.y-tRelRadius - (relWidth)); //+ negPadding);

        }else{
            upperWheelPoint = ccp(overallMidpoint.x-blockDimensions.width*2+relRadius,overallMidpoint.y+relRadius + (relWidth)); //- negPadding);
            lowerWheelPoint = ccp(overallMidpoint.x-blockDimensions.width*2+relRadius,overallMidpoint.y-relRadius - (relWidth)); //+ negPadding);
        }
        CGPoint leftWheelPos1 = upperWheelPoint;
        CGPoint leftWheelPos2= lowerWheelPoint;
        CGPoint rightWheelPos1= upperWheelPoint;
        CGPoint rightWheelPos2= lowerWheelPoint;
        
        leftWheelPos1 = [Helper rotatePoint:leftWheelPos1 aroundPoint:overallMidpoint Radians:leftSideAngle];
        leftWheelPos2 = [Helper rotatePoint:leftWheelPos2 aroundPoint:overallMidpoint Radians:leftSideAngle];
        rightWheelPos1 = [Helper rotatePoint:rightWheelPos1 aroundPoint:overallMidpoint Radians:rightSideAngle];
        rightWheelPos2 = [Helper rotatePoint:rightWheelPos2 aroundPoint:overallMidpoint Radians:rightSideAngle];

        float rotSpeed = 10.0f;
        
        leftWheel1 = [RotatingWheel rotatingWheelWithWorld:world Position:leftWheelPos1 Radius:relRadius enabled:NO Velocity:-rotSpeed];
        leftWheel2 = [RotatingWheel rotatingWheelWithWorld:world Position:leftWheelPos2 Radius:relRadius enabled:NO Velocity:rotSpeed];
        rightWheel1 = [RotatingWheel rotatingWheelWithWorld:world Position:rightWheelPos1 Radius:relRadius enabled:NO Velocity:-rotSpeed];
        rightWheel2 = [RotatingWheel rotatingWheelWithWorld:world Position:rightWheelPos2 Radius:relRadius enabled:NO Velocity:rotSpeed];
        HelloWorldLayer * gameLayer = [HelloWorldLayer sharedHelloWorldLayer];
        [gameLayer addChild:leftWheel1];
        [gameLayer addChild:leftWheel2];
        [gameLayer addChild:rightWheel1];
        [gameLayer addChild:rightWheel2];
        
        float barWidth = 5;
        CGPoint leftPos = ccp(overallMidpoint.x - blockDimensions.width*2-barWidth,overallMidpoint.y);
        CGPoint rightPos = ccp(overallMidpoint.x- blockDimensions.width*2-barWidth,overallMidpoint.y);
        leftPos = [Helper rotatePoint:leftPos aroundPoint:overallMidpoint Radians:leftSideAngle];
        rightPos = [Helper rotatePoint:rightPos aroundPoint:overallMidpoint Radians:rightSideAngle];
        leftBar = [IronBar ironBarWithWorld:world Position:leftPos Length:barWidth Width:relWidth+(relRadius*2) Rotation:CC_RADIANS_TO_DEGREES(leftSideAngle)];
        rightBar = [IronBar ironBarWithWorld:world Position:rightPos Length:barWidth Width:relWidth+(relRadius*2) Rotation:CC_RADIANS_TO_DEGREES(rightSideAngle)];
        [gameLayer addChild:leftBar];
        [gameLayer addChild:rightBar];
        
        NSMutableArray * eventSubscribers = [NSMutableArray array];
        [eventSubscribers addObject:self];
        curSwitch = [DoorSwitch doorSwitchWithWorld:world position:sPos Rotation:CC_RADIANS_TO_DEGREES(leftSideAngle) Dimensions:CGSizeMake(20, 20) Objects:eventSubscribers Event:switchEventActivateMotor];
        [gameLayer addChild:curSwitch];
        
        leftSideStopped = NO;
        rightSideStopped = NO;
               
    }
    return self;
}
-(void)onEnter{
    [self schedule:@selector(ElectricDoorUpdate:)];
    [super onEnter];
}
-(void)ElectricDoorUpdate:(ccTime)delta{
    if (!leftSideStopped) {
    if (leftWheel1.body->GetContactList()==NULL || leftWheel2.body->GetContactList()==NULL) {
        [leftWheel1 stopRotating];
        [leftWheel2 stopRotating];
        leftSideStopped = YES;
    }
    }
    if (!rightSideStopped) {
    if (rightWheel1.body->GetContactList()==NULL || rightWheel2.body->GetContactList()==NULL) {
        [rightWheel1 stopRotating];
        [rightWheel2 stopRotating];
        rightSideStopped = YES;
    }
    }
}
-(void)performSwitchEvent:(SwitchEvent)event{ //fix crash loading level 4. Don't bother debugging, just replace level 4 with level 4 save in reasource file. Move the rest of the saved levels into resource folder incase something similar to this happens again.
    
    if (event == switchEventActivateMotor) {
        leftBar.shouldDelete = YES;
        rightBar.shouldDelete = YES;
        [leftWheel1 startRotating];
        [leftWheel2 startRotating];
        [rightWheel1 startRotating];
        [rightWheel2 startRotating];
    }
    [self removeDestructionListener:curSwitch];
    //[curSwitch removeDestructionListener:self];
    //this doesn't do anything in normal mode but in editor mode, this is the only way to delete this object. Always save these before testing them out and if you don't like it, save it again afterwards.
    if  ([[Options sharedOptions]isUsingEditor]==YES){
        [self removeFromParentAndCleanup:YES]; 
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSValue * pval1 = [NSValue valueWithCGPoint:_pos1];
    NSValue * pval2 = [NSValue valueWithCGPoint:_pos2];
    [aCoder encodeObject:pval1 forKey:@"pval1"];
    [aCoder encodeObject:pval2 forKey:@"pval2"];
    [aCoder encodeObject:super.uniqueID forKey:@"uid"];
    [aCoder encodeFloat:_radius forKey:@"_radius"];
    [aCoder encodeFloat:_width forKey:@"_width"];
    [aCoder encodeCGPoint:[Helper toPixels:curSwitch.body->GetWorldCenter()] forKey:@"_sPos"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    //return nil;
    NSValue *pval1 = [aDecoder decodeObjectForKey:@"pval1"];
    NSValue *pval2 = [aDecoder decodeObjectForKey:@"pval2"];
    float curRadius = [aDecoder decodeFloatForKey:@"_radius"];
    float curWidth = [aDecoder decodeFloatForKey:@"_width"];
    CGPoint sPos = [aDecoder decodeCGPointForKey:@"_sPos"];
    [self initWithWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] Position1:[pval1 CGPointValue] Position2:[pval2 CGPointValue] Radius:curRadius Width:curWidth switchPos:sPos];
    super.uniqueID = [aDecoder decodeObjectForKey:@"uid"];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:self];
    return self;
    
}


+(id)electricDoorWithWorld:(b2World*)world Position1:(CGPoint)pos1 Position2:(CGPoint)pos2 Radius:(float)radius Width:(float)width switchPos:(CGPoint)sPos{
    return [[[self alloc]initWithWorld:world Position1:pos1 Position2:pos2 Radius:radius Width:width switchPos:sPos]autorelease];
}
@end