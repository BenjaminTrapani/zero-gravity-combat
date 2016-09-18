//
//  BodyNode.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GLES-Render.h"
#import "Box2D.h"
#import "Helper.h"
#import "Constants.h"
#import "HelloWorldLayer.h"
#import "ObjectProperty.h"
@interface BodyNode : CCNode {
	b2Body * body;
	CCSprite * sprite;
    
    BodyType userData;
    NSString * uniqueID;
    id destructionListener;
    NSMutableArray * listenerArray;
    BOOL destructionListenersNotified;
    BOOL usesSpriteBatch;
    //flags
    @public
	BOOL shouldDelete;
	BOOL shouldRemoveJoints;
    BOOL shouldReset;
    
    
	
}
@property (readonly, nonatomic) b2Body * body;
@property (readonly, nonatomic) CCSprite * sprite;
@property (nonatomic, readwrite) BOOL shouldDelete;
@property (nonatomic, assign) BodyType userData;
@property (nonatomic, readwrite) BOOL shouldRemoveJoints;
@property (nonatomic, readwrite) BOOL shouldReset;
@property (nonatomic, readwrite) BOOL usesSpriteBatch; //set this before calling createBody if you want to use a sprite batch
@property (nonatomic,assign) NSString * uniqueID;
@property (nonatomic, assign) id destructionListener;
-(void)notifyDestructionListeners;
-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef
			   fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)fileName;

-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName rect:(CGRect)rect;
-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName scale:(float)newScale;
-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName rect:(CGRect)rect rotation:(float)rotation;
-(void) removeSprite;
-(void)removeAllDestructionListeners;
-(void) createNewSprite:(NSString*)name;
-(void) removeBody;
-(void)rotateGunToAngle:(float)angle;
-(void)rotateGunToAngle:(float)angle shaking:(BOOL)shaking;
-(void)removeDestructionListener:(id)aListener;
@end

