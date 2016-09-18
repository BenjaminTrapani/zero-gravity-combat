//
//  Armory.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Armory.h"
#import "Options.h"
#import "Weapon.h"
#import "MyMenuItem.h"
#import "WeaponDetails.h"
#import "MainMenu.h"
#import "RankDisplay.h"
@implementation Armory
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Armory*layer = [Armory node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		selectedFlame = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"selectedFlame.plist"];
		secSelectedFlame = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"selectedFlame.plist"];
		[self addBacking];
		
		[self addProgressBars];
		
		[self addGuns];
		
		[self addButtons];
	}
	return self;
}
-(void)addBacking{
	CCSprite * primaryBacking = [CCSprite spriteWithSpriteFrameName:@"backingPrimary.png"];
	CCSprite * secondaryBacking = [CCSprite spriteWithSpriteFrameName:@"backingPrimary.png"];
    

	CGSize primaryBackingSize = primaryBacking.contentSize;
	CGSize secondaryBackingSize = secondaryBacking.contentSize;
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	primaryBacking.position = ccp(primaryBackingSize.width/2,screenSize.height - primaryBackingSize.height/2 - [[Options sharedOptions]makeYConstantRelative:50]);
	secondaryBacking.position = ccp(secondaryBackingSize.width/2,secondaryBackingSize.height/2);
	CCLabelTTF * primaryLabel = [CCLabelTTF labelWithString:@"Primary Weapon" fontName:@"futured" fontSize:20];
	CCLabelTTF * secondaryLabel = [CCLabelTTF labelWithString:@"Secondary Weapon" fontName:@"futured" fontSize:20];
	CGSize primaryLabelSize = [primaryLabel texture].contentSize;
	CGSize secondaryLabelSize = [secondaryLabel texture].contentSize;
	CCLOG(@"primarySize.width = %f primarySize.height = %f",primaryLabelSize.width,primaryLabelSize.height);
    
    if ([Options sharedOptions].isIpad) {
        primaryLabel.position = ccp(-primaryBackingSize.width/2 + primaryLabelSize.width*2.0f, primaryBackingSize.height - primaryLabelSize.height/2);
        secondaryLabel.position = ccp(-secondaryBackingSize.width/2 + secondaryLabelSize.width*1.8f, secondaryBackingSize.height - secondaryLabelSize.height/2);
    }else{
        primaryLabel.position = ccp(-primaryBackingSize.width/2 + primaryLabelSize.width*1.8, primaryBackingSize.height - primaryLabelSize.height/2);
        secondaryLabel.position = ccp(-secondaryBackingSize.width/2 + secondaryLabelSize.width*1.6, secondaryBackingSize.height - secondaryLabelSize.height/2);
    }
	[primaryBacking addChild:primaryLabel];
	[secondaryBacking addChild:secondaryLabel];
	[self addChild:primaryBacking];
	[self addChild:secondaryBacking];
	
	//gun menu stuff
	[self addChild:selectedFlame];
	[self addChild:secSelectedFlame];
	
	primaryMenu = [CCMenu menuWithItems:nil];
	primaryMenu.tag = 111;
	[self addChild:primaryMenu];
	secondaryMenu = [CCMenu menuWithItems:nil];
	secondaryMenu.tag = 222;
	[self addChild:secondaryMenu];
	
	
	
	primaryMenu.position = ccp([[Options sharedOptions]makeXConstantRelative:-50],primaryBackingSize.height/4.5);
	secondaryMenu.position = ccp(0,0);
	CCLOG(@"pm.x = %f pm.y = %f",primaryMenu.position.x,primaryMenu.position.y);
	CCLOG(@"sm.x = %f sm.y = %f",secondaryMenu.position.x,secondaryMenu.position.y);
	CCLOG(@"pb.x = %f pb.y = %f",primaryBacking.position.x,primaryBacking.position.y);
	CCLOG(@"sb.x = %f sb.y = %f",secondaryBacking.position.x,secondaryBacking.position.y);
	padding = [[Options sharedOptions]makeAverageConstantRelative:10];
	primaryx = 0;
	primaryy = primaryBacking.position.y;
	secondaryx = 0;
	secondaryy = secondaryBacking.position.y;
	primaryMax = primaryBacking.position.x + primaryBackingSize.width - [[Options sharedOptions]makeXConstantRelative:100];
	secondaryMax = secondaryBacking.position.x + secondaryBackingSize.width;
    
    RankDisplay * rd = [RankDisplay rankDisplay];
    rd.scaleX = 1.1f;
    rd.scaleY = 0.65f;
    rd.position = ccp(screenSize.width/2,screenSize.height-(rd.contentSize.height/2.3f * rd.scaleY));
    [self addChild:rd];
}
-(void)addGuns{
	
	int numGuns = 14;
	for (int c = 1; c<=numGuns; c++) {
		Weapon*weapon = [[Weapon alloc]initWithGunTag:c];
		if (c<11) {
			[self addWeaponToPrimaryMenu:weapon];
			
		}else {
			[self addWeaponToSecondaryMenu:weapon];
		}
		[weapon release];
		
	}
	
}

-(void)addProgressBars{
	CCLOG(@"progress bars added");
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	primaryDetails = [WeaponDetails details];
	primaryDetails.position = ccp(screenSize.width/1.15,screenSize.height/1.8);//1.85
	[self addChild:primaryDetails];
	secondaryDetails = [WeaponDetails details];
	secondaryDetails.position = ccp(screenSize.width/1.15,screenSize.height/8);
	[self addChild:secondaryDetails];
	CCLOG(@"finished adding");
}

-(void)addButtons{
	
	CCSprite * equipSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	CCSprite * sequipedSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	
	CCSprite * ssequipSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	CCSprite * sssequipedSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	
	CCSprite * backSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	CCSprite * sbackSprite = [CCSprite spriteWithSpriteFrameName:@"armoryButtonBack.png"];
	
	sequipedSprite.opacity = 100;
	sbackSprite.opacity = 100;
	sssequipedSprite.opacity = 100;
	
	CCMenuItem * equiped = [CCMenuItemSprite itemFromNormalSprite:equipSprite selectedSprite:sequipedSprite target:self selector:@selector(equipPrimaryWeapon)];
	CCMenuItem * equipSecondary = [CCMenuItemSprite itemFromNormalSprite:ssequipSprite selectedSprite:sssequipedSprite target:self selector:@selector(equipSecondaryWeapon)];
	CCMenuItem * back = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:sbackSprite target:self selector:@selector(exitArmory)];
	CCLabelTTF * equipWords = [CCLabelTTF labelWithString:@"Equip" fontName:@"futured.ttf" fontSize:30];
	CCLabelTTF * secEquipWords = [CCLabelTTF labelWithString:@"Equip" fontName:@"futured.ttf" fontSize:30];
	CCLabelTTF * backWords = [CCLabelTTF labelWithString:@"Back" fontName:@"futured.ttf" fontSize:30];
	equipWords.color = ccc3(0, 255, 0);
	secEquipWords.color = ccc3(0, 255, 0);
	backWords.color = ccc3(255, 0, 0);
	
	
	
	CGSize backSpriteSize = backSprite.contentSizeInPixels;
	
	equipWords.position = ccp(backSpriteSize.width/2, backSpriteSize.height/2);
	secEquipWords.position = ccp(backSpriteSize.width/2, backSpriteSize.height/2);
	backWords.position = ccp(backSpriteSize.width/2, backSpriteSize.height/2);
	
	[equiped addChild:equipWords];
	[back addChild:backWords];
	[equipSecondary addChild:secEquipWords];
	
	CCSprite * tempGunBacking = [CCSprite spriteWithSpriteFrameName:@"backingPrimary.png"];
	CGSize tgbSize = tempGunBacking.contentSizeInPixels;
	
    if([Options sharedOptions].isIpad){
        equiped.position = ccp(tgbSize.width-backSpriteSize.width/1.5f,tgbSize.height + backSpriteSize.height/2);
        equipSecondary.position = ccp(tgbSize.width-backSpriteSize.width/1.5f, backSpriteSize.height/2);
    }else{
        equiped.position = ccp(tgbSize.width-backSpriteSize.width/2.5,tgbSize.height + backSpriteSize.height/2);
        equipSecondary.position = ccp(tgbSize.width-backSpriteSize.width/2.5, backSpriteSize.height/2);
    }
	CGSize backSize = backSprite.contentSizeInPixels;
	back.position = ccp(backSize.width/2,backSize.height/2);
	
	equiped.scale = 0.7;
	back.scale = 0.7;
	equipSecondary.scale = 0.7;
	
	CCMenu * buttonMenu = [CCMenu menuWithItems:equiped, equipSecondary, back,nil];
	buttonMenu.position = CGPointZero;
	[self addChild:buttonMenu];
	
}
-(void)equipPrimaryWeapon{
    if (currentPrimary.requiredUnlockLevel>[[Options sharedOptions]currentRank]) {
        return;
    }
	[[SimpleAudioEngine sharedEngine]playEffect:@"equipClick.wav"];
	if (prevEquipPrim == curPrimItem) {
		return;
	}
	[[Options sharedOptions]setPrimarySave:currentPrimary.gunName];
	curPrimItem.color = ccc3(0, 255, 0);
	prevEquipPrim.color = ccc3(255,255,255);
	prevEquipPrim = curPrimItem;
}
-(void)equipSecondaryWeapon{
    if (currentSecondary.requiredUnlockLevel>[[Options sharedOptions]currentRank]) {
        return;
    }

	[[SimpleAudioEngine sharedEngine]playEffect:@"equipClick.wav"];
	if (prevEquipSec == curSecItem) {
		return;
	}
	[[Options sharedOptions]setSecondarySave:currentSecondary.gunName];
	curSecItem.color = ccc3(0, 255, 0);
	prevEquipSec.color = ccc3(255,255,255);
	prevEquipSec = curSecItem;
}
-(void)exitArmory{
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenu scene] withColor:ccc3(5, 5, 5)]];
}
-(void)addWeaponToPrimaryMenu:(Weapon*)weapon{
	CCSprite * weaponSprite =  [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",weapon.gunName]];
	CCSprite * wS2 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",weapon.gunName]];
    NSAssert(weaponSprite!=nil,@"failed to load sprite in addWeaponToPrimaryMenu");
	//NSAssert(wS2!=nil, @"failed to load sprite with path : ");
	wS2.opacity = 100;
	MyMenuItem * item;
	item = [MyMenuItem itemFromNormalSprite:weaponSprite selectedSprite:wS2 target:self selector:@selector(gunTapped:)];
	item.customData = weapon;
	item.scale = 0.5;
	CGSize weaponSize = weaponSprite.contentSizeInPixels;
	primaryx = primaryx + weaponSize.width/2 + padding;
	if (primaryx + weaponSize.width/2>=primaryMax) {
		primaryy = primaryy - padding*3;
		primaryx = 0;
		primaryx = primaryx + weaponSize.width/2 + padding;
	}
	item.position = ccp(primaryx, primaryy);
	if (weapon.requiredUnlockLevel>[[Options sharedOptions]currentRank]) {
        CCSprite * lockedSprite = [CCSprite spriteWithSpriteFrameName:@"padlock2.png"];
        
        CCLabelTTF * unlockAt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"lv %i",weapon.requiredUnlockLevel] fontName:@"futured.ttf" fontSize:25];
        unlockAt.color = ccRED;
        if([Options sharedOptions].isIpad){
            unlockAt.position = ccp(unlockAt.contentSize.width*0.5f,unlockAt.contentSize.height/2);
        }else{
            unlockAt.position = ccp(unlockAt.contentSize.width*1.1f,unlockAt.contentSize.height/2);
        }
        [lockedSprite addChild:unlockAt];
        lockedSprite.position = ccp(weaponSprite.contentSize.width/2,weaponSprite.contentSize.height/2);
        [item addChild:lockedSprite];
    }

	[primaryMenu addChild:item];
	
	if ([weapon.gunName compare:[[Options sharedOptions]getPrimarySave]]==NSOrderedSame) {
		CGSize itemSize = item.normalImage.contentSizeInPixels;
		selectedFlame.position = ccp(item.position.x - itemSize.width/4, item.position.y + itemSize.height/2);
		item.color = ccc3(0, 250, 0);
		prevEquipPrim = item;
		previousItem = item;
		curPrimItem = item;
		[primaryDetails updateDataWithWeapon:weapon];
		CCLOG(@"retrieved primary save");
		
	}
	
	//[weapon release];
	
}
-(void)addWeaponToSecondaryMenu:(Weapon*)weapon{
	CCSprite * weaponSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",weapon.gunName]];
	CCSprite * wS2 =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",weapon.gunName]];
	NSAssert(weaponSprite!=nil, @"failed to load sprite with path :  ");
	wS2.opacity = 100;	
	MyMenuItem * item;
	item = [MyMenuItem itemFromNormalSprite:weaponSprite selectedSprite:wS2 target:self selector:@selector(gunTapped:)]; //need to find a way to pass weapon as a paremeter of this selector
	item.customData = weapon;
	item.scale = 0.5;
	CGSize weaponSize = weaponSprite.contentSizeInPixels;
	secondaryx =secondaryx + weaponSize.width/2 + padding*2;
	if (secondaryx + weaponSize.width/2>=secondaryMax) {
		secondaryy = secondaryy - padding*5;
		secondaryx = 0;
		secondaryx = secondaryx + weaponSize.width/2 + padding;
	}
	item.position = ccp(secondaryx, secondaryy);
    
    if (weapon.requiredUnlockLevel>[[Options sharedOptions]currentRank]) {
        CCSprite * lockedSprite = [CCSprite spriteWithSpriteFrameName:@"padlock2.png"];
        CCLabelTTF * unlockAt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"lv %i",weapon.requiredUnlockLevel] fontName:@"futured.ttf" fontSize:25];
        unlockAt.color = ccRED;
        if([Options sharedOptions].isIpad){
            unlockAt.position = ccp(unlockAt.contentSize.width*0.5f,unlockAt.contentSize.height/2);
        }else{
            unlockAt.position = ccp(unlockAt.contentSize.width*1.1f,unlockAt.contentSize.height/2);
        }
        [lockedSprite addChild:unlockAt];        lockedSprite.position = ccp(weaponSprite.contentSize.width/2,weaponSprite.contentSize.height/2);
        [item addChild:lockedSprite];
    }

    
	if ([weapon.gunName compare:[[Options sharedOptions]getSecondarySave]]==NSOrderedSame) {
		secSelectedFlame.position = item.position;
		item.color = ccc3(0, 250, 0);
		prevEquipSec = item;
		secPrevItem = item;
		curSecItem = item;
		CCLOG(@"saved secondary retrieved");
		[secondaryDetails updateDataWithWeapon:weapon];
	}
	
	[secondaryMenu addChild:item];
	//[weapon release];
	
	
}
-(void)gunTapped:(id)mySender{
	[[SimpleAudioEngine sharedEngine]playEffect:@"ButtonClick.wav"];
	MyMenuItem * sender = (MyMenuItem*)mySender;
	Weapon * sentWeapon = (Weapon*)sender.customData;
	
	
	//sender.color = ccc3(0, 0, 0);
	//selectedFlame.position = sender.position;
	CCLOG(@"sentWeapon damage = %f",sentWeapon.damage);
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	CCNode * sentParent = [sender parent];
	CGSize senderSize = sender.normalImage.contentSizeInPixels;
	senderSize.width = senderSize.width /4;
	senderSize.height = senderSize.height /2;
    
	if (sentParent.tag == 111) {
		selectedFlame.position = ccp(sender.position.x - senderSize.width, sender.position.y + senderSize.height);
		[selectedFlame resetSystem];
		
		
		if (previousItem!=prevEquipPrim) {
			previousItem.color = ccc3(255, 255, 255);
			
		}


		
		
		
		if(sender!=prevEquipPrim){
			sender.color = ccc3(250, 0, 0);
		}
		previousItem = sender;
		[primaryDetails updateDataWithWeapon:sentWeapon];
		currentPrimary = sentWeapon;
		curPrimItem = sender;
        return;
	}
	if (sentParent.tag == 222) {
        [secSelectedFlame resetSystem];
		secSelectedFlame.position = sender.position;
		
		if (secPrevItem!=prevEquipSec) {
			secPrevItem.color = ccc3(255, 255, 255);
		}
		if (sender!=prevEquipSec) {
			sender.color = ccc3(250, 0, 0);
		}
		secPrevItem = sender;
		[secondaryDetails updateDataWithWeapon:sentWeapon];
		currentSecondary = sentWeapon;
		curSecItem = sender;
		
	
	}
	
	
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
