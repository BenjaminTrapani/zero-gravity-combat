//
//  GunInfo.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GunInfo.h"
#import "HelloWorldLayer.h"
#import "Soldier.h"
#import "MyMenu.h"
@implementation GunInfo
@synthesize representedWeapon;
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		reloadTimerRunning = NO;
		gunReloadTime = 0;
		loopCount = 0;
		soldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
		NSString * primaryFN = [NSString stringWithFormat:@"%@.png",soldier.primaryWeapon.gunName];
		NSString * secondaryFN = [NSString stringWithFormat:@"%@.png",soldier.secondaryWeapon.gunName];
		CCLOG(@"primaryFN = %@ secondaryFN = %@", primaryFN, secondaryFN);
		primaryWeapon = [CCSprite spriteWithSpriteFrameName:primaryFN];
		secondaryWeapon = [CCSprite spriteWithSpriteFrameName:secondaryFN];
		secondaryWeapon.visible = NO;
		backing = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];
		shotsInMagAndMags = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i/%i",soldier.primaryWeapon.shotsLeftInMag, soldier.primaryWeapon.magsLeft] fntFile:@"gf3.fnt"]; //fix size of this. Make it bigger. Edit hiero file
		gunName = [CCLabelBMFont labelWithString:soldier.primaryWeapon.gunName fntFile:@"FuturedBMFont.fnt"];
        CGSize shotsInMagAndMagsSize = shotsInMagAndMags.contentSizeInPixels;
        CCLOG(@"sin width = %f sin height = %f",shotsInMagAndMagsSize.width,shotsInMagAndMagsSize.height);
        //shotsInMagAndMagsSize.width /= 12;
        //shotsInMagAndMagsSize.height /= 12;
        backingSize = backing.contentSizeInPixels;
        float gunNameScale = 0.5f;
        gunName.scale = gunNameScale;
        CGSize gunNameSize = gunName.contentSizeInPixels;
        gunNameSize.width *=gunNameScale;
        gunNameSize.height*=gunNameScale;
		[self addChild:backing];
		[self addChild:primaryWeapon];
		[self addChild:secondaryWeapon];
		shotsInMagAndMags.anchorPoint = ccp(1, 0.5f);
		shotsInMagAndMags.position = ccp(backingSize.width / 2 - 5, shotsInMagAndMagsSize.height/2 - backingSize.height/2);
		[self addChild:shotsInMagAndMags];
		gunName.anchorPoint = ccp(0, 0.5f);
		gunName.position = ccp(-backingSize.width/2 + 5,-gunNameSize.height*2);
		[self addChild:gunName];
		CCSprite*swap = [CCSprite spriteWithSpriteFrameName:@"swapButton.png"];
		CCSprite*selectedS = [CCSprite spriteWithSpriteFrameName:@"swapButton.png"];
		CGSize swapSize = swap.contentSize;
		selectedS.opacity = 100;
		//swap.position = ccp(backingSize.width/2, backingSize.height/2 * -1 - swapSize.height/2);
		//selectedS.position = swap.position;
		CCMenuItem * swapItem = [CCMenuItemSprite itemFromNormalSprite:swap selectedSprite:selectedS target:self selector:@selector(doSwap)];
		//swapItem.position = ccp(-backingSize.width/2, -swapSize.height/2 - backingSize.height/2);
		MyMenu * menu = [MyMenu menuWithItems:swapItem,nil]; //Test this. I modified some things in the menu to allow it to be moved around without getting screwed up.
        menu.isContinuous = NO;
		menu.position = ccp(backingSize.width/2 - swapSize.width/2, -swapSize.height/2 - backingSize.height/2);
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
		swapSound = [CDXAudioNode audioNodeWithFile:@"goodClick.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
		[self addChild:swapSound];
		
		[self createProgressTimer];
		[self addChild:menu];
		[self schedule:@selector(Update:)];
		
		}
	return self;
}
-(id)initForPropertyUpdate{
	if ((self = [super init])) {
		
	
	reloadTimerRunning = NO;
	gunReloadTime = 0;
	loopCount = 0;
	soldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
	NSString * primaryFN = [NSString stringWithFormat:@"%@.png",soldier.primaryWeapon.gunName];
	NSString * secondaryFN = [NSString stringWithFormat:@"%@.png",soldier.secondaryWeapon.gunName];
	CCLOG(@"primaryFN = %@ secondaryFN = %@", primaryFN, secondaryFN);
	primaryWeapon = [CCSprite spriteWithSpriteFrameName:primaryFN];
	secondaryWeapon = [CCSprite spriteWithSpriteFrameName:secondaryFN];
	secondaryWeapon.visible = NO;
	backing = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];
	shotsInMagAndMags = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i/%i",soldier.primaryWeapon.shotsLeftInMag, soldier.primaryWeapon.magsLeft] fntFile:@"gf3.fnt"]; //fix size of this. Make it bigger. Edit hiero file
	gunName = [CCLabelBMFont labelWithString:soldier.primaryWeapon.gunName fntFile:@"FuturedBMFont.fnt"];
	CGSize shotsInMagAndMagsSize = shotsInMagAndMags.contentSizeInPixels;
	CCLOG(@"sin width = %f sin height = %f",shotsInMagAndMagsSize.width,shotsInMagAndMagsSize.height);
	//shotsInMagAndMagsSize.width /= 12;
	//shotsInMagAndMagsSize.height /= 12;
	backingSize = backing.contentSizeInPixels;
        float gunNameScale = 0.5f;
        gunName.scale = gunNameScale;
	CGSize gunNameSize = gunName.contentSizeInPixels;
        gunNameSize.width *=gunNameScale;
        gunNameSize.height*=gunNameScale;
	[self addChild:backing];
	[self addChild:primaryWeapon];
	[self addChild:secondaryWeapon];
	shotsInMagAndMags.anchorPoint = ccp(1, 0.5f);
	shotsInMagAndMags.position = ccp(backingSize.width / 2 - 5, shotsInMagAndMagsSize.height/2 - backingSize.height/2);
	[self addChild:shotsInMagAndMags];
	gunName.anchorPoint = ccp(0, 0.5f);
	gunName.position = ccp(-backingSize.width/2 + 5,-gunNameSize.height*2);
	[self addChild:gunName];
		/*
	CCSprite*swap = [CCSprite spriteWithSpriteFrameName:@"swapButton.png"];
	CCSprite*selectedS = [CCSprite spriteWithSpriteFrameName:@"swapButton.png"];
	CGSize swapSize = swap.contentSizeInPixels;
	selectedS.opacity = 100;
	//swap.position = ccp(backingSize.width/2, backingSize.height/2 * -1 - swapSize.height/2);
	//selectedS.position = swap.position;
	CCMenuItem * swapItem = [CCMenuItemSprite itemFromNormalSprite:swap selectedSprite:selectedS target:self selector:@selector(doSwap)];
	//swapItem.position = ccp(-backingSize.width/2, -swapSize.height/2 - backingSize.height/2);
	CCMenu * menu = [CCMenu menuWithItems:swapItem,nil];
	menu.position = ccp(backingSize.width/2 - swapSize.width/2, -swapSize.height/2 - backingSize.height/2);
	//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[self createProgressTimer];
	[self addChild:menu];
	[self schedule:@selector(Update:)];
		 */
	}
	return self;
}
+(id)gunInfoForPropertyUpdate{
	return [[[self alloc]initForPropertyUpdate]autorelease];
}
-(void)doSwap{
	
	//[[SimpleAudioEngine sharedEngine]playEffect:@"goodClick.wav"];
	[swapSound play];
	[soldier swapWeapon];
	[self updateInformation];
}
-(void)refresh{
	if (soldier.currentWeapon == @"primary") {
		[gunName setString:soldier.primaryWeapon.gunName];
		[self removeChild:primaryWeapon cleanup:YES];
		primaryWeapon = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",soldier.primaryWeapon.gunName]];
		[self addChild:primaryWeapon];
	}
	if (soldier.currentWeapon == @"secondary") {
		[gunName setString:soldier.secondaryWeapon.gunName];
		[self removeChild:secondaryWeapon cleanup:YES];
		secondaryWeapon = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",soldier.secondaryWeapon.gunName]];
		[self addChild:secondaryWeapon];
	}
}
-(void)Update:(ccTime*)delta{
	
	if (soldier.currentWeapon == @"primary") {
		[shotsInMagAndMags setString:[NSString stringWithFormat:@"%i/%i",soldier.primaryWeapon.shotsLeftInMag, soldier.primaryWeapon.magsLeft]];
		CCProgressTimer * timer = (CCProgressTimer*)[self getChildByTag:12];
		//if (soldier.primaryWeapon.isReloading == YES) {
			timer.percentage = soldier.primaryWeapon.reloadProgress;
			//if (timer.percentage>=100) {
			//	timer.visible=NO;
			//}
			
		//}

		
	}
	if (soldier.currentWeapon == @"secondary") {
		[shotsInMagAndMags setString:[NSString stringWithFormat:@"%i/%i",soldier.secondaryWeapon.shotsLeftInMag, soldier.secondaryWeapon.magsLeft]];
		CCProgressTimer * timer = (CCProgressTimer*)[self getChildByTag:12];
		//if (soldier.secondaryWeapon.isReloading == YES) {
			timer.percentage = soldier.secondaryWeapon.reloadProgress;
		//	if (timer.percentage>=100) {
			//	timer.visible = NO;
			//}
		
	//}
		
	}
}
-(void)setcurrentWeapon:(Weapon*)newWeapon{
	//if (newWeapon.gunName!= [gunName string]) {
		[gunName setString:newWeapon.gunName];
		
		[self removeChild:primaryWeapon cleanup:YES];
		primaryWeapon = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",newWeapon.gunName]];
		[self addChild:primaryWeapon];
		self.representedWeapon = newWeapon;
	//}
	[shotsInMagAndMags setString:[NSString stringWithFormat:@"%i/%i",newWeapon.shotsLeftInMag, newWeapon.magsLeft]];
	
	
}
-(void)updateInformation{
	//CCLOG(@"in update information, soldier.currentWeapon = %@",soldier.currentWeapon);
	if (soldier.currentWeapon == @"primary") {
		primaryWeapon.visible = YES;
		if ([primaryWeapon displayedFrame]!=[soldier.primaryWeapon.sprite displayedFrame]) {
			[primaryWeapon setDisplayFrame:[soldier.primaryWeapon.sprite displayedFrame]];
		}
											
		secondaryWeapon.visible = NO;
		[gunName setString:soldier.primaryWeapon.gunName];
		[shotsInMagAndMags setString:[NSString stringWithFormat:@"%i/%i",soldier.primaryWeapon.shotsLeftInMag, soldier.primaryWeapon.magsLeft]];
		
	}
	if (soldier.currentWeapon == @"secondary") {
		primaryWeapon.visible = NO;
		secondaryWeapon.visible = YES;
		if ([secondaryWeapon displayedFrame]!=[soldier.secondaryWeapon.sprite displayedFrame]) {
			[secondaryWeapon setDisplayFrame:[soldier.secondaryWeapon.sprite displayedFrame]];
		}
		[gunName setString:soldier.secondaryWeapon.gunName];
		[shotsInMagAndMags setString:[NSString stringWithFormat:@"%i/%i",soldier.secondaryWeapon.shotsLeftInMag, soldier.secondaryWeapon.magsLeft]];
	}
}
-(void)createProgressTimer{
	CCProgressTimer * timer = [CCProgressTimer progressWithFile:@"reloadTimer.png"]; 
	timer.type = kCCProgressTimerTypeRadialCW;
	timer.percentage = 0;
	timer.tag = 12;
	CGSize timerSize = timer.contentSizeInPixels;
	//timer.scale = 1.0f;
	timerSize.width /=2;
	timerSize.height /=2;
	timer.position = ccp(-backingSize.width/2 + timerSize.width*1.5f,  backingSize.height/2 - timerSize.height*2);
	CCLOG(@"progress timer created");
	[self addChild:timer];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
