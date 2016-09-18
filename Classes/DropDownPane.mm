//
//  DropDownPane.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 11/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DropDownPane.h"
#import "Options.h"
#import "MyMenu.h"
@implementation DropDownPane

-(id)initWithText:(NSString *) text fontSize:(float)size{
    if ((self = [super init])){
        CCSprite * backing;
        if([Options sharedOptions].isIpad){
            backing = [CCSprite spriteWithFile:@"DropDown2hd.png"];
        }else{
            backing = [CCSprite spriteWithFile:@"DropDown2.png"];
        }
        backing.scaleX = 0.5f;
        CGSize backingSize = backing.contentSize;
        backingSize.width*=backing.scaleX;
        backingSize.height*=backing.scaleY;
        [self addChild:backing];
        CCLabelTTF * instructions = [CCLabelTTF labelWithString:text dimensions:backingSize alignment:UITextAlignmentLeft fontName:@"futured.ttf" fontSize:size];
        instructions.scale = 0.9f;
        [self addChild:instructions];
        [super setContentSize:backing.contentSize];
        
        
        CCSprite * backSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        CCSprite * sbackSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
        
        sbackSprite.opacity = 100;
        
        CCMenuItem * doneItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:sbackSprite target:self selector:@selector(moveOut)];
        CCLabelTTF * backWords = [CCLabelTTF labelWithString:@"Done" fontName:@"futured.ttf" fontSize:30];
        backWords.color = ccc3(0, 255, 0);
        
        CGSize backSpriteSize = backSprite.contentSizeInPixels;
        
        backWords.position = ccp(backSpriteSize.width/2, backSpriteSize.height/2);
        
        [doneItem addChild:backWords];
        
        
		//swapItem.position = ccp(-backingSize.width/2, -swapSize.height/2 - backingSize.height/2);
		MyMenu * menu = [MyMenu menuWithItems:doneItem,nil]; //Test this. I modified some things in the menu to allow it to be moved around without getting screwed up.
        menu.isContinuous = NO;
		menu.position = ccp(backingSize.width/2 - backSpriteSize.width/2, -backSpriteSize.height/2 - backingSize.height/2);
        [self addChild:menu];
    }
    return self;
}
-(void)moveOut{
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    CCEaseIn * easeIn = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2.5,screenSize.height+(super.contentSize.height/2))] rate:2];
    CCCallFuncN * callFunc = [CCCallFuncN actionWithTarget:self selector:@selector(removeThis)];
    CCSequence * seq = [CCSequence actions:easeIn, callFunc, nil];
    [self runAction:seq];
}
-(void)removeThis{
    [self removeFromParentAndCleanup:YES];
}
+(id)dropDownPaneWithText:(NSString*)text fontSize:(float)size{
    return [[[self alloc]initWithText:text fontSize:size]autorelease];
}

@end
