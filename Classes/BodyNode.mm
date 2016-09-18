//
//  BodyNode.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
#import "Options.h"
#import "GameController.h"

@implementation BodyNode



@synthesize body;
@synthesize sprite;
@synthesize shouldDelete;
@synthesize userData;
@synthesize shouldRemoveJoints;
@synthesize shouldReset;
@synthesize usesSpriteBatch;
@synthesize uniqueID; 
@synthesize destructionListener;
-(id)init{
        if ((self = [super init])) {
            userData = kBodyTypeBody;
        
            if([Options sharedOptions].isUsingEditor)
                self.uniqueID = [Helper generateUUID];
        
            listenerArray = [[NSMutableArray alloc]initWithCapacity:3];
            destructionListenersNotified = NO;
        }
	return self;
}

-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	
	[self removeSprite];
	[self removeBody];
	self.shouldDelete = NO;
	self.shouldRemoveJoints = NO;
	if (spriteFrameName) {
		sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		if (self.usesSpriteBatch == YES) {
            [[Options sharedOptions]incrementTag];
            NSMutableArray * array = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatches];
            CCSpriteBatchNode * batch1 = (CCSpriteBatchNode*)[array objectAtIndex:0];
            CCSpriteBatchNode * batch2 = (CCSpriteBatchNode*)[array objectAtIndex:1];
            BOOL success = YES;
            
            if(![batch1 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]]){
                success = [batch2 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]];
            }
            NSAssert(success==YES,@"didn't successfully add sprite to sprite sheet. Texture id of sprite didn't match either sprite batches");
        }else{
            [[HelloWorldLayer sharedHelloWorldLayer]addChild:sprite];
        }

	}

	body = world->CreateBody(bodyDef);
	
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}else {
		CCLOG(@"fixture def = nil FIIIIIIIXXXXXXDX THISSSSSSSSS");
	}

	return body;
}

-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName scale:(float)newScale
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
	

	[self removeSprite];
	[self removeBody];
	self.shouldDelete = NO;
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	sprite.scale = newScale;
	//[batch addChild:sprite];
	if (self.usesSpriteBatch == YES) {
        [[Options sharedOptions]incrementTag];
        NSMutableArray * array = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatches];
        CCSpriteBatchNode * batch1 = (CCSpriteBatchNode*)[array objectAtIndex:0];
        CCSpriteBatchNode * batch2 = (CCSpriteBatchNode*)[array objectAtIndex:1];
        BOOL success = YES;
        if(![batch1 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]]){
            success = [batch2 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]];
        }
        NSAssert(success,@"didn't successfully add sprite to sprite sheet. Texture id of sprite didn't match either sprite batches");
    }else{
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:sprite];
    }
	
	
	body = world->CreateBody(bodyDef);
	
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}else {
		CCLOG(@"fixture def = nil FIIIIIIIXXXXXXDX THISSSSSSSSS");
	}
	
	return body;
}


-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName rect:(CGRect)rect
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
		[self removeSprite];
	[self removeBody];
	self.shouldDelete = NO;
	
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	
	CGSize rectSize = rect.size;
	sprite = [Helper scaleSprite:sprite toDimensions:rectSize];
	 
	if (self.usesSpriteBatch == YES) {
        [[Options sharedOptions]incrementTag];
        NSMutableArray * array = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatches];
        CCSpriteBatchNode * batch1 = (CCSpriteBatchNode*)[array objectAtIndex:0];
        CCSpriteBatchNode * batch2 = (CCSpriteBatchNode*)[array objectAtIndex:1];
        BOOL success = YES;
        if ([[Options sharedOptions]nextTag]==122 || [[Options sharedOptions]nextTag]==123) {
            CCLOG(@"failure drawing sprite with file: %@",spriteFrameName);
        }
        if(![batch1 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]]){
            success = [batch2 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]];
        }
        NSAssert(success,@"didn't successfully add sprite to sprite sheet. Texture id of sprite didn't match either sprite batches");
    }else{
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:sprite];
    }

	
	body = world->CreateBody(bodyDef);
	
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}
	return body;
}


-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName rect:(CGRect)rect rotation:(float)rotation
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
	

	[self removeSprite];
	[self removeBody];
	self.shouldDelete = NO;
	
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	CGSize rectSize = rect.size;
	
	sprite = [Helper scaleSprite:sprite toDimensions:rectSize];
	
	if (self.usesSpriteBatch == YES) {
        [[Options sharedOptions]incrementTag];
        NSMutableArray * array = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatches];
        CCSpriteBatchNode * batch1 = (CCSpriteBatchNode*)[array objectAtIndex:0];
        CCSpriteBatchNode * batch2 = (CCSpriteBatchNode*)[array objectAtIndex:1];
        BOOL success = YES;
        if(![batch1 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]]){
            success = [batch2 addChild:sprite z:0 tag:[[Options sharedOptions]nextTag]];
        }
        NSAssert(success,@"didn't successfully add sprite to sprite sheet. Texture id of sprite didn't match either sprite batches");
    }else{
        [[HelloWorldLayer sharedHelloWorldLayer]addChild:sprite];
    }

	
	body = world->CreateBody(bodyDef);
	
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}
	return body;
}

-(void) createNewSprite:(NSString*)name{
	CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
	[sprite setDisplayFrame:frame];
}

-(void) removeSprite
{
	if (sprite!=nil) {
        if (!usesSpriteBatch) {
            [[HelloWorldLayer sharedHelloWorldLayer]removeChild:sprite cleanup:YES];
        }else{
            NSMutableArray * array = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatches];
            for (CCSpriteBatchNode * batchNode in array) {
                [batchNode removeChild:sprite cleanup:YES];
            }
        }
		
		sprite = nil;
	}
}

-(void) removeBody
{
	if (body != NULL && body->GetWorld()->GetBodyCount()>0)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}
-(void)setUniqueID:(NSString *)nuniqueID{
    if (nuniqueID == uniqueID) {
        return;
    }
    uniqueID = nuniqueID;
}
-(void)setDestructionListener:(id)ndestructionListener{
    destructionListener = ndestructionListener;
    [listenerArray addObject:destructionListener];
}
-(void)removeDestructionListener:(id)aListener{
    [listenerArray removeObject:aListener];
}
-(void)removeAllDestructionListeners{
    [listenerArray removeAllObjects];
}
-(void)notifyDestructionListeners{
    
        NSArray * curArray = (NSArray*)listenerArray;
        if (!destructionListenersNotified && curArray) {
            if ([[HelloWorldLayer sharedHelloWorldLayer]getGameController].timeLimit!=0) {
                for (int i = 0; i<[curArray count]; i++) {
                    id subscriber = [curArray objectAtIndex:i];
                    [subscriber onObjectDestroyed:self];
                    [listenerArray removeObject:subscriber];
                }
                destructionListenersNotified = YES;
            }
    
        }
    

}
-(void) dealloc
{
	CCLOG(@"bodynode released");
    //[destructionListener onObjectDestroyed:self];
    [self notifyDestructionListeners];
    [listenerArray release];
	[self removeSprite];
	[self removeBody];
    
    //[uniqueID release];
    
    
	[super dealloc];
}

@end


