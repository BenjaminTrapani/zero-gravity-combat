//
//  HUD.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "GunInfo.h"
#import "EventBus.h"
#import "MyMenu.h"
#import "CCTouchDispatcher.h"
#import "Weapon.h"
#import "Options.h"
#import "Soldier.h"
#import "DropDownPane.h"
@implementation HUD
@synthesize joystick;
@synthesize skinStick;
@synthesize firingStick;
@synthesize myGI;
@synthesize injured;
-(id) hudinit
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		screenSize = [[CCDirector sharedDirector]winSize];
		[self addJoystick];
		[self addFiringStick];
		//[self addRotateArrows];
		
		[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:1 swallowsTouches:NO];
        //[self release];
		hasCreatedPickup = NO;
		closeCount = 0;
		
        int currentLevel = [[Options sharedOptions]currentLevel];
        
        DropDownPane * dropDownPane = nil;
        
        if(currentLevel==1){
            dropDownPane = [DropDownPane dropDownPaneWithText:@"Use the left joystick to move. Use the right joystick to shoot. Make it to the exit as quick as you can! The exit looks just like the entrance. Proceed to your right carefully" fontSize:12.0f];
        }
        
        if(currentLevel==2){
            dropDownPane = [DropDownPane dropDownPaneWithText:@"Shoot generator switches to open up pathways" fontSize:12.0f];
            CCSprite * genPic = [CCSprite spriteWithSpriteFrameName:@"Generator.png"];
            //genPic.position = ccp(dropDownPane.contentSize.width/2,dropDownPane.contentSize.height/2);
            [dropDownPane addChild:genPic];
        }
        
        if(currentLevel==4){
            dropDownPane = [DropDownPane dropDownPaneWithText:@"Shoot globes of light to open doors" fontSize:12.0f];
            CCSprite * genPic = [CCSprite spriteWithSpriteFrameName:@"smallElectricDoorSwitch.png"];
            //genPic.position = ccp(dropDownPane.contentSize.width/2,dropDownPane.contentSize.height/2);
            [dropDownPane addChild:genPic];
        }

        
        if(dropDownPane){
            dropDownPane.position = ccp(screenSize.width/2.5,screenSize.height);
            [self addChild:dropDownPane];
            [dropDownPane runAction:[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2.5,screenSize.height-(dropDownPane.contentSize.height/2))] rate:2]];
		}
        
        [self schedule:@selector(Update:)];
        //[self addGunInfo]; //need to add gun info seperately after soldier is inited
	}
	return self;
}

+(id)hud{
	//return [[[self alloc]hudinit]autorelease];
    return [[[self alloc]hudinit]autorelease];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
   // [[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
    CCLOG(@"hud deallocated");
	[myGI release];
	[pickupGI release];
	//[self removeChild:[GameController sharedGameController] cleanup:YES];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
	[super dealloc];
}
-(void)Update:(ccTime*)delta{
	closeCount++;
	float width = screenSize.width/6;
	float height = screenSize.height/10;
	eiRect.origin = ccp(pickupGI.position.x-(width),pickupGI.position.y-(height));
	if (closeCount>5 && [pickupGI numberOfRunningActions]==0 && pickupGI.position.y!=screenSize.height+height+[[Options sharedOptions]makeYConstantRelative:10]) {
		[pickupGI runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:1 position:ccp(screenSize.width-(width*3),screenSize.height+height+[[Options sharedOptions]makeYConstantRelative:10])] rate:2]];
		//CCLOG(@"reached move out");
	}
	
}

-(void)addJoystick
{
	float stickRAdius = 50;
	//CGSize screenSize = [[CCDirector sharedDirector]winSize];
	joystick = [SneakyJoystick joystickWithRect:CGRectMake(0, 0, stickRAdius, stickRAdius)];
	
	joystick.autoCenter = YES;
	joystick.hasDeadzone = YES;
	joystick.deadRadius = 10;
	
	skinStick = [SneakyJoystickSkinnedBase skinnedBase];
	skinStick.backgroundSprite = [CCSprite spriteWithFile:@"joystickBack.png"];
    skinStick.backgroundSprite.opacity = 100;
	skinStick.thumbSprite = [CCSprite spriteWithFile:@"joystickFront.png"];
    skinStick.thumbSprite.opacity = 100;
	skinStick.thumbSprite.scale = 0.5f;
    
    /*BOOL isIpad = [Options sharedOptions].isIpad;
    if (isIpad) {
        skinStick.backgroundSprite.scale = 0.5f;
        skinStick.thumbSprite.scale = 0.5f;
    }*/

    
	skinStick.joystick = joystick;
	skinStick.position = ccp(stickRAdius*2,stickRAdius*2);
	
	//this checks how long since a gun was close to the main character to determine weather or not to remove pickupGI from view
	[self addChild:skinStick];
}
-(void)addFiringStick
{
	float stickRAdius = 50;
	//CGSize screenSize = [[CCDirector sharedDirector]winSize];
	firingStick = [SneakyJoystick joystickWithRect:CGRectMake(0, 0, stickRAdius, stickRAdius)];
	
	firingStick.autoCenter = YES;
	firingStick.hasDeadzone = YES;
	firingStick.deadRadius = 50;
	
	skinFiringStick = [SneakyJoystickSkinnedBase skinnedBase];;
	skinFiringStick.backgroundSprite = [CCSprite spriteWithFile:@"joystickBack.png"];
    
    skinFiringStick.backgroundSprite.opacity = 100;
	skinFiringStick.thumbSprite = [CCSprite spriteWithFile:@"joystickFront.png"];
	skinFiringStick.thumbSprite.scale = 0.5f;
    skinFiringStick.thumbSprite.opacity = 100;
    /*BOOL isIpad = [Options sharedOptions].isIpad;
    if (isIpad) {
        skinStick.backgroundSprite.scale = 0.5f;
        skinStick.thumbSprite.scale = 0.5f;
    }*/

	skinFiringStick.joystick = firingStick;
	skinFiringStick.position = ccp(screenSize.width - stickRAdius*2,stickRAdius*2);
	[self addChild:skinFiringStick];
	
}
-(void)onSoldierCreated{ //addGunInfo
	
	//CGSize screenSize = [[CCDirector sharedDirector]winSize];
	myGI = [[GunInfo alloc]init];
	float width = screenSize.width/6; // /7
	float height = screenSize.height/10;
	myGI.position = ccp(screenSize.width-width,screenSize.height-height);
	myGI.scale = 0.75f;
	giRect = CGRectMake(myGI.position.x-width, myGI.position.y-height, width*3, height*3);
	
	[self addChild:myGI];
	tint = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];//[CCLayerColor layerWithColor:ccc4(250, 250, 0, 100) width:giRect.size.width height:giRect.size.height];
	tint.visible = NO;
	tint.opacity = 100;
	tint.color = ccc3(250, 250, 0);
	
	tint2 = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];//[CCLayerColor layerWithColor:ccc4(250, 250, 0, 100) width:giRect.size.width height:giRect.size.height];
	tint2.visible = NO;
	tint2.opacity = 100;
	tint2.color = ccc3(250, 250, 0);
	//tint.position = ccp(-width,-height);
	
	[myGI addChild:tint];
	
	pickupGI = [[GunInfo alloc]initForPropertyUpdate];// gunInfoForPropertyUpdate];
	[pickupGI unschedule:@selector(Update:)];
	pickupGI.position = ccp(screenSize.width-(width*3),screenSize.height+height);
	pickupGI.scale = 0.75f;
	eiRect = CGRectMake(screenSize.width-(width*3)-width*2, screenSize.height-(height*2), width*3, height*3);
	
	[self addChild:pickupGI];
	
	CCLabelTTF * tapToPickup = [CCLabelTTF labelWithString:@"Tap To Equip" fontName:@"futured.ttf" fontSize:20];
	tapToPickup.color = ccc3(255, 0, 0);
	tapToPickup.position = ccp(0,height);
	[pickupGI addChild:tapToPickup];
	[pickupGI addChild:tint2];
	
	/*pickupGI = [[GunInfo alloc]init];
	pickupGI.position = ccp(screenSize.width-width,screenSize.height-height);
	pickupGI.scale = 0.75f;
	eiRect = CGRectMake(pickupGI.position.x-width, pickupGI.position.y-height, width*3, height*3);
	
	[self addChild:pickupGI];
	tint2 = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];
	tint2.visible = NO;
	tint.opacity = 100;
	tint.color = ccc3(250, 250, 0);
	[pickupGI addChild:tint2];
	*/
	//[self addRotateArrows];
	
	injured = [CCLayerColor layerWithColor:ccc4(255, 0, 0, 0)];
	[self addChild:injured];
}
-(void)gunCloseForPickup:(Weapon*)weapon{
	float width = screenSize.width/6;
	float height = screenSize.height/10;
	closeCount = 0;
	if ([pickupGI numberOfRunningActions]==0 && pickupGI.position.y!=screenSize.height-height) {
		[pickupGI runAction:[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:1 position:ccp(screenSize.width-(width*3),screenSize.height-height)] rate:2]];
		
	}
	[pickupGI setcurrentWeapon:weapon];
	 //gun image is changing fine.
}
-(void)addRotateArrows{
	//left arrow
	//CGSize screenSize = [[CCDirector sharedDirector]winSize];
	CCSprite * leftArrow = [CCSprite spriteWithSpriteFrameName:@"smallLeftArrow.png"];
	CGSize arrowSize = leftArrow.contentSizeInPixels;
	CCSprite * selectedLA = [CCSprite spriteWithSpriteFrameName:@"smallLeftArrow.png"];
	selectedLA.opacity = 100;
	CCMenuItem * leftArrowItem = [CCMenuItemSprite itemFromNormalSprite:leftArrow selectedSprite:selectedLA target:[HelloWorldLayer sharedHelloWorldLayer] selector:@selector(doLeft)];
	leftArrowItem.position = ccp(- arrowSize.width/2, arrowSize.height);
	
	//right arrow
	CCSprite * rightArrow = [CCSprite spriteWithSpriteFrameName:@"smallLeftArrow.png"];
	CCSprite * selectedRA = [CCSprite spriteWithSpriteFrameName:@"smallLeftArrow.png"];
	//rightArrow.rotation = 180;
	//selectedRA.rotation = 180;
	selectedRA.opacity = 100;
	CCMenuItem * rightArrowItem = [CCMenuItemSprite itemFromNormalSprite:rightArrow selectedSprite:selectedRA target:[HelloWorldLayer sharedHelloWorldLayer] selector:@selector(doRight)];
	rightArrowItem.position = ccp(arrowSize.width/2, arrowSize.height);
	rightArrowItem.rotation = 180;
	//Menu
	MyMenu * arrowMenu = [MyMenu menuWithItems:rightArrowItem, leftArrowItem, nil];
	arrowMenu.position = ccp(screenSize.width/2,0);
	[self addChild:arrowMenu];
	
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	if (CGRectContainsPoint(giRect, location)) {
		tint.visible = YES;
	}
	if (CGRectContainsPoint(eiRect, location)) {
		//CCLOG(@"eiRect contains touched location");
		tint2.visible = YES;
	}
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	if (CGRectContainsPoint(giRect, location)) {
		tint.visible = YES;
	}else {
		tint.visible = NO;
	}
	if (CGRectContainsPoint(eiRect, location)) {
		tint2.visible = YES;
	}else {
		tint2.visible = NO;
	}


}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[self onTouchEnded];		
}
-(void)onTouchEnded{
	tint.visible = NO;
	tint2.visible = NO;
	if (CGRectContainsPoint(giRect, location)) {
		Soldier * soldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
		[soldier reloadWeapon];
		
	}
	if (CGRectContainsPoint(eiRect, location)) {
		//swap the soldier's weapon weapon with the weapon that the soldier is close to
		Soldier * soldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];
		[soldier updateCurrentWeaponWithWeapon:pickupGI.representedWeapon];
		//when tapped quickly, swaps soldier's gun for  pickupt gi.representedWeapon
		//[pickupGI.representedWeapon updateDataWithWeapon:swappedOut];
	}
	
	location = CGPointZero;
}

@end
