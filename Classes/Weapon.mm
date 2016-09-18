//
//  Weapon.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "EventBus.h"
#import "Bullets.h"
#import "Soldier.h"
#import "Options.h"
#import "LazerSight.h"
#import "BodyPart.h"
@implementation Weapon
@synthesize accuracy;
@synthesize damage;
@synthesize recoil;
@synthesize rateOfFire;
@synthesize isFiring;
@synthesize reloadTime;
@synthesize magCapacity;
@synthesize numMags;
@synthesize shotsLeftInMag;
@synthesize magsLeft;
@synthesize gunName;
@synthesize fireType;
@synthesize timeToReload;
@synthesize isReloading;
@synthesize gun;
@synthesize gunShot;
@synthesize reloadProgress;
@synthesize lazerSight;
@synthesize hasCarrier;
@synthesize gunMan;
@synthesize isRocketLauncher;
@synthesize requiredUnlockLevel;
-(id) initWithGunName:(NSString*)mygunName
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		//NSString * initName;
		super.userData = kBodyTypeWeapon;
		isCarrierSoldier = YES;
		
		if ([mygunName isEqualToString: @"M16a2"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M16a2.png"];
			//initName = @"M16.png";
			self.damage = 7; //done
			self.accuracy = 8; //done
			self.recoil = 5; //done
			self.rateOfFire = 6; //done //use to be 3
			self.reloadTime = 3; //
			self.magCapacity = 5;//
			self.numMags = 7;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 0;
			
		}
		if ([mygunName isEqualToString: @"M92"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M92.png"];
			self.damage = 5;
			self.accuracy = 6;
			self.recoil = 2;
			self.rateOfFire = 5; //used to be 10
			self.reloadTime = 5;
			self.magCapacity = 1;
			self.numMags = 10;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 0;
		}
		if ([mygunName isEqualToString: @"9mm"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"9mm.png"];
			self.damage = 6;
			self.accuracy = 4;
			self.recoil = 7;
			self.rateOfFire = 5; 
			self.reloadTime = 7;
			self.magCapacity = 1.5;
			self.numMags = 15;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 4;
		}
		if ([mygunName isEqualToString:@"AK47"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"AK47.png"];
			self.damage = 6;
			self.accuracy = 8;
			self.recoil = 3;
			self.rateOfFire = 8; 
			self.reloadTime = 6;
			self.magCapacity = 7;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 8;
		}
		if ([mygunName isEqualToString: @"L96A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"L96A1.png"];
			self.damage = 10;
			self.accuracy = 10;
			self.recoil = 8;
			self.rateOfFire = 1; 
			self.reloadTime = 7;
			self.magCapacity = 2;
			self.numMags = 10;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 3;
		}
		if ([mygunName isEqualToString: @"M1911A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M1911A1.png"];
			self.damage = 8;
			self.accuracy = 8;
			self.recoil = 6;
			self.rateOfFire = 3; 
			self.reloadTime = 8;
			self.magCapacity = 1.2;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 6;
		}
		if ([mygunName isEqualToString: @"MD2A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"MD2A1.png"];
			self.damage = 5;
			self.accuracy = 4;
			self.recoil = 3;
			self.rateOfFire = 9; 
			self.reloadTime = 6;
			self.magCapacity = 9.5;
			self.numMags = 12;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 3;
			
		}
        if ([mygunName isEqualToString:@"LAV 15"]) {
            gun = [CCSprite spriteWithSpriteFrameName:@"LAV 15.png"];
            self.damage = 10;
			self.accuracy = 6;
			self.recoil = 10;
			self.rateOfFire = 2; 
			self.reloadTime = 2;
			self.magCapacity = 1;
			self.numMags = 5;
			self.fireType = @"sa";
            self.isRocketLauncher = YES;
            self.requiredUnlockLevel = 15;
        }

		if ([mygunName isEqualToString: @"Model 59"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Model 59.png"];
			self.damage = 5;
			self.accuracy = 9;
			self.recoil = 6;
			self.rateOfFire = 5; 
			self.reloadTime = 7;
			self.magCapacity = 1.3;
			self.numMags = 5;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 7;
			
		}
		if ([mygunName isEqualToString: @"MP44"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"MP44.png"];
			self.damage = 4;
			self.accuracy = 4;
			self.recoil = 2;
			self.rateOfFire = 9; 
			self.reloadTime = 5;
			self.magCapacity = 7.5;
			self.numMags = 15;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 10;
			
		}
		if ([mygunName isEqualToString: @"NM149S"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"NM149S.png"];
			self.damage = 9;
			self.accuracy = 9;
			self.recoil = 7;
			self.rateOfFire = 2; 
			self.reloadTime = 6;
			self.magCapacity = 0.5;
			self.numMags = 8;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 2;
			
		}
		if ([mygunName isEqualToString: @"PPK"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"PPK.png"];
			self.damage = 6;
			self.accuracy = 8;
			self.recoil = 6;
			self.rateOfFire = 5; 
			self.reloadTime = 6;
			self.magCapacity = 0.8;
			self.numMags = 5;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 6;
		}
		if ([mygunName isEqualToString: @"SAR 4800"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"SAR 4800.png"];
			self.damage = 7;
			self.accuracy = 9;
			self.recoil = 6;
			self.rateOfFire = 7; 
			self.reloadTime = 5;
			self.magCapacity = 2;
			self.numMags = 12;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 5;
		}
		if ([mygunName isEqualToString: @"SSG 69"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"SSG 69.png"];
			self.damage = 10;
			self.accuracy = 8;
			self.recoil = 7;
			self.rateOfFire = 2; 
			self.reloadTime = 5;
			self.magCapacity = 0.5;
			self.numMags = 6;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 12;
		}
		if ([mygunName isEqualToString: @"Uzi"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Uzi.png"];
			self.damage = 5; //start changing stuff herepolo
			self.accuracy = 3;
			self.recoil = 2;
			self.rateOfFire = 9; 
			self.reloadTime = 7;
			self.magCapacity = 6;
			self.numMags = 15;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 13;
		}
		if ([mygunName isEqualToString: @"Vektor R4"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Vektor R4.png"];
			self.damage = 7;
			self.accuracy = 9;
			self.recoil = 4;
			self.rateOfFire = 7; 
			self.reloadTime = 4;
			self.magCapacity = 5.5;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 10;
		}
		self.gunName = mygunName; 
		rawMagCapacity = self.magCapacity * 10;
		self.isReloading = NO;
		
		self.shotsLeftInMag = rawMagCapacity;
		self.magsLeft = self.numMags;
		
		timeBetweenShots = 11 - rateOfFire;
		timeToReload = 11 - self.reloadTime;
		timeToReload = timeToReload * 25; //relative amount of time it takes to reload all guns
		reloadDelay = 0;
		semiAutoDelay = (11-self.rateOfFire) * 5; //*5
		saDelayCount = semiAutoDelay;
		
		canShoot = YES;
		hasFiringStickBeenDead = YES;
		isOutOfAmmo = NO;
		
		
		//[self addChild:gun];
		CGSize gunSize = gun.contentSizeInPixels;
		/*muzzleFlash = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"muzzleFlash.plist"];
		muzzleFlash.position = ccp(gunSize.width,gunSize.height/2);
		muzzleFlash.visible = NO;
		[gun addChild:muzzleFlash];
		*/
		
		//Bullets * bullets = [[HelloWorldLayer sharedHelloWorldLayer]getBullets];
		//[bullets addBulletsForWeapon:self];
		
		
		self.isFiring = NO;
		
		
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		CGPoint startPos = ccp(screenSize.width/2,screenSize.height/2);
		bodyDef.position = ([Helper toMeters:startPos]);
		
		bodyDef.angularDamping = 0.9f;
		//bodyDef.linearDamping = 0.9f;
		
		b2PolygonShape shape;
		shape.SetAsBox((gunSize.width/10) / PTM_RATIO, (gunSize.height/10) / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density =  0.03f;
		fixtureDef.friction = 1.0f;
		fixtureDef.restitution = 0.2f;
		fixtureDef.filter.groupIndex = -8;
		fixtureDef.filter.categoryBits = CATEGORY_WEAPON;
		fixtureDef.filter.maskBits = MASK_WEAPON;
		//super.usesSpriteBatch = YES;
        
		[super createBodyInWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:[NSString stringWithFormat:@"%@.png",self.gunName] scale:0.2];
        for (int i = 0; i<10; i++) {
            muzzleFrame[i] = [CCSprite spriteWithSpriteFrameName:@"muzzleFlash.png"];
            muzzleFrame[i].rotation = arc4random()%360;
            muzzleFrame[i].opacity = arc4random()%100 + 155;
            muzzleFrame[i].scale = CCRANDOM_0_1() + 1.0f;
            muzzleFrame[i].visible = NO;
            muzzleFrame[i].position = ccp(gunSize.width,gunSize.height/2);
            [super.sprite addChild:muzzleFrame[i]];
        }
		
		if (self.isRocketLauncher == NO) {
            bullets = [[Bullets alloc]initWithGroupIndex:-8];
        }else {
            bullets = [[Bullets alloc]initForRocketsWithGroupIndex:-8];
        }

		//[bullets addBulletsForWeapon:self];
		[[HelloWorldLayer sharedHelloWorldLayer]addChild:bullets];
		
		
		
		
        //[self onSoldierCreatedAsParent];
		
		lazerSight = [LazerSight lazerSightWithWeapon:self];
		[super.sprite addChild:lazerSight];
		
		[self schedule:@selector(Update:)];
	}
	return self;
}
-(void)onSoldierCreatedAsParent{
    self.gunShot = [CDXAudioNode audioNodeWithFile:@"singleShot.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	
	reloadSound = [CDXAudioNode audioNodeWithFile:@"reloadSFX.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	
	boltActionSound = [CDXAudioNode audioNodeWithFile:@"boltAction.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
    
	sharpClick = [CDXAudioNode audioNodeWithFile:@"sharpClick.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	[[HelloWorldLayer sharedHelloWorldLayer] addChild:sharpClick];
	
	
	addBullets = [CDXAudioNode audioNodeWithFile:@"addBullets.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	//Soldier * localSoldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];;
    
    
    
	//NSAssert(localSoldier.sprite!=nil, @"local soldier not yet initialized");
	
	//figure out a way to clear the buffers that each weapon uses. Better yet, find a way to get CDSoundEngine to find the best available buffer and use it.
	//CCSprite*tempEarNode = [CCSprite spriteWithSpriteFrameName:@"AK47.png"]; all this worked
	//tempEarNode.position = ccp(200,200);
	//[[HelloWorldLayer sharedHelloWorldLayer]addChild:tempEarNode];
	//self.gunShot.earNode = localSoldier.sprite;
    //[gunShot.earNode release];
	//[[HelloWorldLayer sharedHelloWorldLayer] addChild:gunShot];
	NSAssert(super.sprite!=nil,@"super.sprite hasn't been initialized yet");
	//[super.sprite addChild:self.gunShot];
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:gunShot];
	//reloadSound.earNode = localSoldier.sprite;
    //[reloadSound.earNode release];
	//[super.sprite addChild:reloadSound];
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:reloadSound];
	//boltActionSound.earNode = localSoldier.sprite;
    
	//[super.sprite addChild:boltActionSound];
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:boltActionSound];
	//[boltActionSound.earNode release];
	
	//addBullets.earNode = localSoldier.sprite;
    //[addBullets.earNode release];
    
    [[HelloWorldLayer sharedHelloWorldLayer]addChild:addBullets];
}
-(void)onSoldierCreated{
	CCLOG(@"soldier created called");
	
	self.gunShot = [CDXAudioNode audioNodeWithFile:@"singleShot.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	
	reloadSound = [CDXAudioNode audioNodeWithFile:@"reloadSFX.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	
	boltActionSound = [CDXAudioNode audioNodeWithFile:@"boltAction.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	sharpClick = [CDXAudioNode audioNodeWithFile:@"sharpClick.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	[[HelloWorldLayer sharedHelloWorldLayer] addChild:sharpClick];
	
	
	addBullets = [CDXAudioNode audioNodeWithFile:@"addBullets.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:1];
	Soldier * localSoldier = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier];;
   
    
	 
	NSAssert(localSoldier.sprite!=nil, @"local soldier not yet initialized");
	
	//figure out a way to clear the buffers that each weapon uses. Better yet, find a way to get CDSoundEngine to find the best available buffer and use it.
	//CCSprite*tempEarNode = [CCSprite spriteWithSpriteFrameName:@"AK47.png"]; all this worked
	//tempEarNode.position = ccp(200,200);
	//[[HelloWorldLayer sharedHelloWorldLayer]addChild:tempEarNode];
	self.gunShot.earNode = localSoldier.sprite;
	[[HelloWorldLayer sharedHelloWorldLayer] addChild:gunShot];
	NSAssert(super.sprite!=nil,@"super.sprite hasn't been initialized yet");
	//[super.sprite addChild:self.gunShot];
	
	reloadSound.earNode = localSoldier.sprite;
	//[super.sprite addChild:reloadSound];
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:reloadSound];
	boltActionSound.earNode = localSoldier.sprite;
	//[super.sprite addChild:boltActionSound];
	[[HelloWorldLayer sharedHelloWorldLayer]addChild:boltActionSound];
	
	
	addBullets.earNode = localSoldier.sprite;
    [[HelloWorldLayer sharedHelloWorldLayer]addChild:addBullets];
	//[super.sprite addChild:addBullets];
		/*
	audioNode = [CDXAudioNode audioNodeWithFile:@"singleShot.wav" soundEngine:soundEngine sourceId:0];
	audioNode.earNode = mySoldier.sprite;
	//audioNode.position = ccp(200,200);
	[mySoldier.primaryWeapon.sprite addChild:audioNode];
	 //this code works
	*/
	
}
-(id) initWithGunName:(NSString*)mygunName identifier:(int)idtt{
	if( (self=[super init])) {
		
		//NSString * initName;
		super.userData = kBodyTypeWeapon;
		
		
		if ([mygunName isEqualToString: @"M16a2"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M16a2.png"];
			//initName = @"M16.png";
			self.damage = 7; //done
			self.accuracy = 8; //done
			self.recoil = 5; //done
			self.rateOfFire = 6; //done //use to be 3
			self.reloadTime = 3; //
			self.magCapacity = 5;//
			self.numMags = 7;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 0;
			
		}
		if ([mygunName isEqualToString: @"M92"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M92.png"];
			self.damage = 5;
			self.accuracy = 6;
			self.recoil = 2;
			self.rateOfFire = 5; //used to be 10
			self.reloadTime = 5;
			self.magCapacity = 1;
			self.numMags = 10;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 0;
		}
		if ([mygunName isEqualToString: @"9mm"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"9mm.png"];
			self.damage = 6;
			self.accuracy = 4;
			self.recoil = 7;
			self.rateOfFire = 5; 
			self.reloadTime = 7;
			self.magCapacity = 1.5;
			self.numMags = 15;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 4;
		}
		if ([mygunName isEqualToString:@"AK47"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"AK47.png"];
			self.damage = 6;
			self.accuracy = 8;
			self.recoil = 3;
			self.rateOfFire = 8; 
			self.reloadTime = 6;
			self.magCapacity = 7;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 8;
		}
		if ([mygunName isEqualToString: @"L96A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"L96A1.png"];
			self.damage = 10;
			self.accuracy = 10;
			self.recoil = 8;
			self.rateOfFire = 1; 
			self.reloadTime = 7;
			self.magCapacity = 2;
			self.numMags = 10;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 3;
		}
		if ([mygunName isEqualToString: @"M1911A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"M1911A1.png"];
			self.damage = 8;
			self.accuracy = 8;
			self.recoil = 6;
			self.rateOfFire = 3; 
			self.reloadTime = 8;
			self.magCapacity = 1.2;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 6;
		}
		if ([mygunName isEqualToString: @"MD2A1"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"MD2A1.png"];
			self.damage = 5;
			self.accuracy = 4;
			self.recoil = 3;
			self.rateOfFire = 9; 
			self.reloadTime = 6;
			self.magCapacity = 9.5;
			self.numMags = 12;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 3;
			
		}
        if ([mygunName isEqualToString:@"LAV 15"]) {
            gun = [CCSprite spriteWithSpriteFrameName:@"LAV 15.png"];
            self.damage = 10;
			self.accuracy = 6;
			self.recoil = 10;
			self.rateOfFire = 2; 
			self.reloadTime = 2;
			self.magCapacity = 1;
			self.numMags = 5;
			self.fireType = @"sa";
            self.isRocketLauncher = YES;
            self.requiredUnlockLevel = 15;
        }
        
		if ([mygunName isEqualToString: @"Model 59"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Model 59.png"];
			self.damage = 5;
			self.accuracy = 9;
			self.recoil = 6;
			self.rateOfFire = 5; 
			self.reloadTime = 7;
			self.magCapacity = 1.3;
			self.numMags = 5;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 7;
			
		}
		if ([mygunName isEqualToString: @"MP44"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"MP44.png"];
			self.damage = 4;
			self.accuracy = 4;
			self.recoil = 2;
			self.rateOfFire = 9; 
			self.reloadTime = 5;
			self.magCapacity = 7.5;
			self.numMags = 15;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 10;
			
		}
		if ([mygunName isEqualToString: @"NM149S"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"NM149S.png"];
			self.damage = 9;
			self.accuracy = 9;
			self.recoil = 7;
			self.rateOfFire = 2; 
			self.reloadTime = 6;
			self.magCapacity = 0.5;
			self.numMags = 8;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 2;
			
		}
		if ([mygunName isEqualToString: @"PPK"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"PPK.png"];
			self.damage = 6;
			self.accuracy = 8;
			self.recoil = 6;
			self.rateOfFire = 5; 
			self.reloadTime = 6;
			self.magCapacity = 0.8;
			self.numMags = 5;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 6;
		}
		if ([mygunName isEqualToString: @"SAR 4800"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"SAR 4800.png"];
			self.damage = 7;
			self.accuracy = 9;
			self.recoil = 6;
			self.rateOfFire = 7; 
			self.reloadTime = 5;
			self.magCapacity = 2;
			self.numMags = 12;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 5;
		}
		if ([mygunName isEqualToString: @"SSG 69"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"SSG 69.png"];
			self.damage = 10;
			self.accuracy = 8;
			self.recoil = 7;
			self.rateOfFire = 2; 
			self.reloadTime = 5;
			self.magCapacity = 0.5;
			self.numMags = 6;
			self.fireType = @"sa";
            self.requiredUnlockLevel = 12;
		}
		if ([mygunName isEqualToString: @"Uzi"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Uzi.png"];
			self.damage = 5; //start changing stuff herepolo
			self.accuracy = 3;
			self.recoil = 2;
			self.rateOfFire = 9; 
			self.reloadTime = 7;
			self.magCapacity = 6;
			self.numMags = 15;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 13;
		}
		if ([mygunName isEqualToString: @"Vektor R4"]) {
			gun = [CCSprite spriteWithSpriteFrameName:@"Vektor R4.png"];
			self.damage = 7;
			self.accuracy = 9;
			self.recoil = 4;
			self.rateOfFire = 7; 
			self.reloadTime = 4;
			self.magCapacity = 5.5;
			self.numMags = 10;
			self.fireType = @"fa";
            self.requiredUnlockLevel = 10;
		}
		self.gunName = mygunName; 
		rawMagCapacity = self.magCapacity * 10;
		self.isReloading = NO;
		
		self.shotsLeftInMag = rawMagCapacity;
		self.magsLeft = self.numMags;
		
		timeBetweenShots = 11 - rateOfFire;
		timeToReload = 11 - self.reloadTime;
		timeToReload = timeToReload * 25; //relative amount of time it takes to reload all guns
		reloadDelay = 0;
		semiAutoDelay = (11-self.rateOfFire) * 5; //*5
		saDelayCount = semiAutoDelay;
		
		canShoot = YES;
		hasFiringStickBeenDead = YES;
		isOutOfAmmo = NO;
		
		
		//[self addChild:gun];
		CGSize gunSize = gun.contentSizeInPixels;
		/*muzzleFlash = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"muzzleFlash.plist"];
		 muzzleFlash.position = ccp(gunSize.width,gunSize.height/2);
		 muzzleFlash.visible = NO;
		 [gun addChild:muzzleFlash];
		 */
		//Bullets * bullets = [[HelloWorldLayer sharedHelloWorldLayer]getBullets];
		//[bullets addBulletsForWeapon:self];
		
		self.isFiring = NO;
		
		
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		CGPoint startPos = ccp(screenSize.width/2,screenSize.height/2);
		bodyDef.position = ([Helper toMeters:startPos]);
		
		bodyDef.angularDamping = 0.9f;
		//bodyDef.linearDamping = 0.9f;
		
		b2PolygonShape shape;
		shape.SetAsBox((gunSize.width/10) / PTM_RATIO, (gunSize.height/10) / PTM_RATIO);
		b2FixtureDef fixtureDef;
		
		fixtureDef.shape = &shape; //cshape
		fixtureDef.density = 0.03f;
		fixtureDef.friction = 1.0f;
		fixtureDef.restitution = 0.2f;
		fixtureDef.filter.groupIndex = idtt;
		fixtureDef.filter.categoryBits = CATEGORY_WEAPON;
		fixtureDef.filter.maskBits = MASK_WEAPON;
        super.usesSpriteBatch = YES;
		
		[super createBodyInWorld:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:[NSString stringWithFormat:@"%@.png",self.gunName] scale:0.2];
		
		for (int i = 0; i<10; i++) {
            muzzleFrame[i] = [CCSprite spriteWithSpriteFrameName:@"muzzleFlash.png"];
            muzzleFrame[i].rotation = arc4random()%360;
            muzzleFrame[i].opacity = arc4random()%100 + 155;
            muzzleFrame[i].scale = CCRANDOM_0_1() + 1.0f;
            muzzleFrame[i].visible = NO;
            muzzleFrame[i].position = ccp(gunSize.width,gunSize.height/2);
            [super.sprite addChild:muzzleFrame[i]];
        }

				
        if (self.isRocketLauncher == NO) {
            bullets = [[Bullets alloc]initWithGroupIndex:idtt];
        }else {
            bullets = [[Bullets alloc]initForRocketsWithGroupIndex:idtt];
        }
		
		//[bullets addBulletsForWeapon:self];
		[[HelloWorldLayer sharedHelloWorldLayer]addChild:bullets z:100 tag:100];
		 
		
        [self onSoldierCreated];
		
		
		[self schedule:@selector(Update:)];
	}
	return self;
}

+(id)randomPrimaryWithId:(int)identity{
	int randomGun = arc4random()%9;
	if (randomGun == 0) {
		return [[[self alloc]initWithGunName:@"M16a2" identifier:identity]autorelease];
	}
	if (randomGun == 1) {
		return [[[self alloc]initWithGunName:@"AK47" identifier:identity]autorelease];
	}
	if (randomGun == 2) {
		return [[[self alloc]initWithGunName:@"L96A1" identifier:identity]autorelease];
	}
	if (randomGun == 3) {
		return [[[self alloc]initWithGunName:@"MP44" identifier:identity]autorelease];
	}
	if (randomGun == 4) {
		return [[[self alloc]initWithGunName:@"NM149S" identifier:identity]autorelease];
	}
	if (randomGun == 5) {
		return [[[self alloc]initWithGunName:@"SAR 4800" identifier:identity]autorelease];
	}
	if (randomGun == 6) {
		return [[[self alloc]initWithGunName:@"SSG 69" identifier:identity]autorelease];
	}
	if (randomGun == 7) {
		return [[[self alloc]initWithGunName:@"Uzi" identifier:identity]autorelease];
	}
	if (randomGun == 8) {
		return [[[self alloc]initWithGunName:@"Vektor R4" identifier:identity]autorelease];
	}
    if (randomGun == 9) {
        return [[[self alloc]initWithGunName:@"LAV 15" identifier:identity]autorelease];
    }
	NSAssert(1==0, @"random gun wasn't selected in randomPrimaryWithID");
}
+(id)gunWithName:(NSString *)name ID:(int)idtt{
	return [[[self alloc]initWithGunName:name identifier:idtt]autorelease];
}
-(id)initWithGunTag:(int)gunTag{
	
		// always call "super" init
		// Apple recommends to re-assign "self" with the "super" return value
		if( (self=[super init])) {
			NSString * mygunName;
			//NSString * initName;
			if (gunTag == 1) {
				gun = [CCSprite spriteWithSpriteFrameName:@"M16a2.png"];
				//initName = @"M16.png";
				self.damage = 7; //done
				self.accuracy = 8; //done
				self.recoil = 5; //done
				self.rateOfFire = 6; //done //use to be 3
				self.reloadTime = 3; //
				self.magCapacity = 5;//
				self.numMags = 7;
				self.fireType = @"fa";
				mygunName =@"M16a2";
                self.requiredUnlockLevel = 0;
				
			}
			if (gunTag == 2) {
				gun = [CCSprite spriteWithSpriteFrameName:@"AK47.png"];
				self.damage = 6;
				self.accuracy = 8;
				self.recoil = 3;
				self.rateOfFire = 8; 
				self.reloadTime = 6;
				self.magCapacity = 7;
				self.numMags = 10;
				self.fireType = @"fa";
				mygunName =@"AK47";
                self.requiredUnlockLevel = 8;
			}
			if (gunTag == 3) {
				gun = [CCSprite spriteWithSpriteFrameName:@"L96A1.png"];
				self.damage = 10;
				self.accuracy = 10;
				self.recoil = 8;
				self.rateOfFire = 1; 
				self.reloadTime = 7;
				self.magCapacity = 2;
				self.numMags = 10;
				self.fireType = @"sa";
				mygunName =@"L96A1";
                self.requiredUnlockLevel = 3;
			}
			if (gunTag == 4) {
				gun = [CCSprite spriteWithSpriteFrameName:@"MP44.png"];
				self.damage = 4;
				self.accuracy = 4;
				self.recoil = 2;
				self.rateOfFire = 9; 
				self.reloadTime = 5;
				self.magCapacity = 7.5;
				self.numMags = 15;
				self.fireType = @"fa";
				mygunName =@"MP44";
                self.requiredUnlockLevel = 10;
				
			}
			if (gunTag == 5) {
				gun = [CCSprite spriteWithSpriteFrameName:@"NM149S.png"];
				self.damage = 9;
				self.accuracy = 9;
				self.recoil = 7;
				self.rateOfFire = 2; 
				self.reloadTime = 6;
				self.magCapacity = 0.5;
				self.numMags = 8;
				self.fireType = @"sa";
				mygunName =@"NM149S";
                self.requiredUnlockLevel = 2;
				
			}
			if (gunTag == 6) {
				gun = [CCSprite spriteWithSpriteFrameName:@"SAR 4800.png"];
				self.damage = 7;
				self.accuracy = 9;
				self.recoil = 6;
				self.rateOfFire = 7; 
				self.reloadTime = 5;
				self.magCapacity = 2;
				self.numMags = 12;
				self.fireType = @"sa";
				mygunName =@"SAR 4800";
                self.requiredUnlockLevel = 5;
			}
			if (gunTag == 7) {
				gun = [CCSprite spriteWithSpriteFrameName:@"SSG 69.png"];
				self.damage = 10;
				self.accuracy = 8;
				self.recoil = 7;
				self.rateOfFire = 2; 
				self.reloadTime = 5;
				self.magCapacity = 0.5;
				self.numMags = 6;
				self.fireType = @"sa";
				mygunName =@"SSG 69";
                self.requiredUnlockLevel = 12;
			}
			if (gunTag == 8) {
				gun = [CCSprite spriteWithSpriteFrameName:@"Uzi.png"];
				self.damage = 5; //start changing stuff herepolo
				self.accuracy = 3;
				self.recoil = 2;
				self.rateOfFire = 9; 
				self.reloadTime = 7;
				self.magCapacity = 6;
				self.numMags = 15;
				self.fireType = @"fa";
				mygunName =@"Uzi";
                self.requiredUnlockLevel = 13;
			}
			if (gunTag == 9) {
				gun = [CCSprite spriteWithSpriteFrameName:@"Vektor R4.png"];
				self.damage = 7;
				self.accuracy = 9;
				self.recoil = 4;
				self.rateOfFire = 7; 
				self.reloadTime = 4;
				self.magCapacity = 5.5;
				self.numMags = 10;
				self.fireType = @"fa";
				mygunName =@"Vektor R4";
                self.requiredUnlockLevel = 10;
			}
			if (gunTag == 10) {
                gun = [CCSprite spriteWithSpriteFrameName:@"LAV 15.png"];
                self.damage = 10;
                self.accuracy = 6;
                self.recoil = 10;
                self.rateOfFire = 2; 
                self.reloadTime = 2;
                self.magCapacity = 1;
                self.numMags = 5;
                self.fireType = @"sa";
                self.isRocketLauncher = YES;
                mygunName = @"LAV 15";
                self.requiredUnlockLevel = 15; //15
            }
			//secondary weapons start here
			if (gunTag == 11) {
				gun = [CCSprite spriteWithSpriteFrameName:@"M92.png"];
				self.damage = 5;
				self.accuracy = 6;
				self.recoil = 2;
				self.rateOfFire = 5; //used to be 10
				self.reloadTime = 5;
				self.magCapacity = 1;
				self.numMags = 10;
				self.fireType = @"sa";
				mygunName =@"M92";
                self.requiredUnlockLevel = 0;
			}
			if (gunTag == 12) {
				gun = [CCSprite spriteWithSpriteFrameName:@"9mm.png"];
				self.damage = 6;
				self.accuracy = 4;
				self.recoil = 7;
				self.rateOfFire = 5; 
				self.reloadTime = 7;
				self.magCapacity = 1.5;
				self.numMags = 15;
				self.fireType = @"sa";
				mygunName =@"9mm";
                self.requiredUnlockLevel = 4;
			}
			if (gunTag == 13) {
				gun = [CCSprite spriteWithSpriteFrameName:@"PPK.png"];
				self.damage = 6;
				self.accuracy = 8;
				self.recoil = 6;
				self.rateOfFire = 5; 
				self.reloadTime = 6;
				self.magCapacity = 0.8;
				self.numMags = 5;
				self.fireType = @"sa";
				mygunName =@"PPK";
                self.requiredUnlockLevel = 6;
			}
			if (gunTag == 14) {
				gun = [CCSprite spriteWithSpriteFrameName:@"Model 59.png"];
				self.damage = 5;
				self.accuracy = 9;
				self.recoil = 6;
				self.rateOfFire = 5; 
				self.reloadTime = 7;
				self.magCapacity = 1.3;
				self.numMags = 5;
				self.fireType = @"sa";
				mygunName =@"Model 59";
                self.requiredUnlockLevel = 7;
				
			}
			if (gunTag == 15) {
				gun = [CCSprite spriteWithSpriteFrameName:@"M1911A1.png"];
				self.damage = 8;
				self.accuracy = 8;
				self.recoil = 6;
				self.rateOfFire = 3; 
				self.reloadTime = 8;
				self.magCapacity = 1.2;
				self.numMags = 10;
				self.fireType = @"fa";
				mygunName =@"M1911A1";
                self.requiredUnlockLevel = 6;
			}
			
			self.gunName = mygunName;
			rawMagCapacity = self.magCapacity * 10;
			self.isReloading = NO;
			
			self.shotsLeftInMag = rawMagCapacity;
			self.magsLeft = self.numMags;
			
			timeBetweenShots = 11 - rateOfFire;
			timeToReload = 11 - self.reloadTime;
			timeToReload = timeToReload * 25; //relative amount of time it takes to reload all guns
			reloadDelay = 0;
			
			canShoot = YES;
			hasFiringStickBeenDead = YES;
			isOutOfAmmo = NO;
			[self addChild:gun];
			
			
						

			
			/*CGSize gunSize = gun.contentSizeInPixels;
			muzzleFlash = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"muzzleFlash.plist"];
			muzzleFlash.position = ccp(gunSize.width,gunSize.height/2);
			muzzleFlash.visible = NO;
			[gun addChild:muzzleFlash];
			
			self.isFiring = NO;
			
			[self schedule:@selector(Update:)];
			 */
		}
		return self;
		
}
-(void)Update:(ccTime)delta{
	interval = 60*delta; 
	timeSinceLastShot += interval;
    if(!isCarrierSoldier){
        CGPoint spritePos = sprite.position;
    
        gunShot.position = spritePos;
        reloadSound.position = spritePos;
        boltActionSound.position = spritePos;
    }
    
    //lazerSight.position = spritePos;
    
	if ([HelloWorldLayer sharedHelloWorldLayer].isFiringStickDead == YES) {
		hasFiringStickBeenDead = YES;
	}
	
	if (self.fireType == @"sa") {
		saDelayCount+=interval;
		if (abs((semiAutoDelay-saDelayCount)-semiAutoDelay/2)<interval/2 && isReloading==NO) {
				//CCLOG(@"play sound if reached");
				//[[SimpleAudioEngine sharedEngine]playEffect:@"boltAction.wav"];
				//CCLOG(@"bolt action sound played");
				[boltActionSound play];
			}
	}

		
		
	
	
	if (canShoot == NO) {
		reloadDelay += interval;
		reloadProgress = reloadDelay/self.timeToReload*100;
		if (reloadDelay>= timeToReload) {
			reloadProgress = 0;
			reloadDelay = 0;
			canShoot = YES;
			//[[SimpleAudioEngine sharedEngine]stopEffect:reloadSound];
			[reloadSound stop];
			self.shotsLeftInMag = rawMagCapacity;
			self.isReloading = NO;
		//}else{
		//	return;
		//}
		}
	}
	
	
	
	if (timeBetweenShots<timeSinceLastShot) {
		self.isFiring = NO;
		//canShoot = NO;
	}
	/*
	if (self.rotation>360) {
		self.rotation = 1;
	}
	if (self.rotation<0) {
		self.rotation = 355;
	}
	//CCLOG(@"%f",self.rotation);
	if (self.rotation >90 && self.rotation <270) {
		self.gun.flipY = YES;
	}else{
		self.gun.flipY = NO;
	}
	*/
	if (self.isFiring == NO) {
        muzzleFrame[animationIndex].visible = NO;
		//muzzleFlash.visible = NO;
		/*if (canShoot == YES) {
			//self.rotation = 0;
		}else {
			//self.rotation = 90;
			//CCLOG(@"90");
			
		}
		 */
		if (canShoot == NO && hasCarrier == YES) { //when an ai runs out of ammo, this gets called and curParent is helloWorldLayer. Add a gunman property to the weapon class.
            float parentRotation = 0;
            if (gunMan) {
                parentRotation = CC_RADIANS_TO_DEGREES(gunMan.body->GetAngle());
            }else{
                BodyNode * curParent = (BodyNode*)[self parent];
                float parentRotation = CC_RADIANS_TO_DEGREES(curParent.body->GetAngle()); //put this in degrees
            }
			if ([[HelloWorldLayer sharedHelloWorldLayer]getWorld]->IsLocked()==FALSE) {
				self.body->SetTransform(self.body->GetWorldCenter(),CC_DEGREES_TO_RADIANS(parentRotation + 270));
			}
			
			
		}
    }

		
	
	

}
+(id)gunWithName:(NSString*)name{
	return [[[self alloc]initWithGunName:name]autorelease];
}
+(id)gunWithTag:(int)gunTag{
	return [[[self alloc]initWithGunTag:gunTag]autorelease];
}
-(void)fireBulletWithVelocity:(CGPoint)velocity bulletDegrees:(CGFloat)degrees world:(b2World*)world position:(CGPoint)shotPos gunman:(BodyNode*)currentGunMan{
	
    
    if (magsLeft <=0 && shotsLeftInMag<=0) {
		isOutOfAmmo = YES;
		
	}else {
		isOutOfAmmo = NO;
	}

    
	if (isOutOfAmmo) {
		[currentGunMan rotateGunToAngle:degrees shaking:NO];
		[lazerSight showLazerSight];
		return;
	}
	
	if (shotsLeftInMag<=0 && canShoot) {
		if (magsLeft == 0) {
			shotsLeftInMag = 0;
			//[[SimpleAudioEngine sharedEngine]playEffect:@"sharpClick.wav"];
			[sharpClick play];
			[currentGunMan rotateGunToAngle:degrees shaking:NO];
			return;
		}
		
		isReloading = YES;
		
		//reloadSound = [[SimpleAudioEngine sharedEngine]playEffect:@"reloadSFX.wav"];
		[reloadSound play];
		//self.shotsLeftInMag = rawMagCapacity;
		magsLeft --;
		canShoot = NO;
		///CCLOG(@"1");
	}
	
	
	
	if (fireType == @"sa" && !hasFiringStickBeenDead) {
		//CCLOG(@"-1");
		//self.isFiring = NO;
		[currentGunMan rotateGunToAngle:degrees shaking:NO];
		[lazerSight showLazerSight];
		return;
	}
	if (fireType == @"sa" && saDelayCount>=semiAutoDelay) {
		saDelayCount = 0;
		//[[SimpleAudioEngine sharedEngine]playEffect:@"boltAction.wav"];
		//CCLOG(@"1");
	}else if (fireType == @"sa" && saDelayCount<semiAutoDelay) {
		//CCLOG(@"2");
		[currentGunMan rotateGunToAngle:degrees shaking:NO];
		[lazerSight showLazerSight];
		return;
	} 
		
	

	
	hasFiringStickBeenDead = NO;
	
	//this checks weather or not the gun is out of ammo.
	
	
	if (!canShoot) {
		
		isFiring = NO;
		[currentGunMan rotateGunToAngle:degrees shaking:NO];
		[lazerSight showLazerSight];
		return;
	}
	
	//this rotates the gun
	
	/*BodyNode * parent = (BodyNode*) [self parent];
	float playerRotationOffset = 360 - parent.rotation;
	self.rotation = degrees * -1 + playerRotationOffset;
	 */
	//self.body->SetTransform(b2Vec2(self.body->GetWorldCenter()),CC_DEGREES_TO_RADIANS(degrees));
	[currentGunMan rotateGunToAngle:degrees shaking:YES];
	[lazerSight showLazerSight];
	//secondaryWeapon.rotation = degrees * -1 + playerRotationOffset;
	
	isFiring = YES;
	timeSinceLastShot = 0;
	
	//Bullets * bullets = [[HelloWorldLayer sharedHelloWorldLayer]getBullets];
	CGPoint realPos = sprite.position;//[Helper toPixels:self.body->GetWorldCenter()];
	realPos.x+=velocity.x*10;
	realPos.y+=velocity.y*10;
    if (isCarrierSoldier){
        [[EventBus sharedEventBus]doWeaponFired:shotPos bulletDegrees:degrees];
    }
    
    muzzleFrame[animationIndex].visible = NO;
    animationIndex++;
    if (animationIndex>=10) {
        animationIndex = 0;
    }
    muzzleFrame[animationIndex].visible = YES;
    //return;
	[bullets fireBulletWithVelocity:velocity bulletDegrees:degrees world:world position:realPos gunman:currentGunMan weapon:self interval:interval]; //just firing bullets with this commented out costs 10 fps. optimize code leading up to this first.
	/*if ([[self parent]isKindOfClass:[Soldier class]]) {
		CCLOG(@"made it past fire bullet");
	}*/
	//self.shotsLeftInMag --;
		
	
	
	
	//[[EventBus sharedEventBus]doBulletFired:shotPos shotAngle:degrees];
	/*shotCount ++;
	if (shotCount<timeBetweenShots) {
		return;
	}else {
		shotCount = 0;
	}
	[[SimpleAudioEngine sharedEngine]playEffect:@"singleShot.wav"];
	//Bullet * currentBullet = [Bullet bulletWithWorld:world position:shotPos angle:degrees];
	//currentBullet.position = shotPos;
	//currentBullet.damage = self.damage;
	////CCSpriteBatchNode * batch = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatch];
	////[batch addChild:currentBullet];
	//[[HelloWorldLayer sharedHelloWorldLayer]addChild:currentBullet];
	////[self addChild:currentBullet];
	b2Vec2 force = [Helper toMeters:velocity];
	force.Normalize();
	b2Vec2 realForce = 75.0f * force;
	float realAccuracy = 10 - self.accuracy;
	realAccuracy = realAccuracy * 3;
	float amountToVary = CCRANDOM_0_1()*realAccuracy;
	int positiveOrNegative;
	float decider = CCRANDOM_0_1();
	if (decider>=0.5) {
		positiveOrNegative = -1;
	}else {
		positiveOrNegative = 1;
	}
	amountToVary = amountToVary * positiveOrNegative;
	realForce.x = realForce.x + amountToVary;
	realForce.y = realForce.y + amountToVary;
	//CCLOG(@"realForcex = %f realForcey = %f",realForce.x, realForce.y); //fix joystick. this works fine
	currentBullet.body->ApplyForce(realForce, currentBullet.body->GetWorldCenter());
	CGPoint pointRecoil = ccp(velocity.x * self.recoil, velocity.y * self.recoil);
	pointRecoil.x = pointRecoil.x * -300;
	pointRecoil.y = pointRecoil.y * -300;
	b2Vec2 recoilVec = [Helper toMeters:pointRecoil];
	currentGunMan.body->ApplyForce(recoilVec, currentGunMan.body->GetWorldCenter());
	 */
	
}

-(void)reloadGun{
	if (canShoot == YES && shotsLeftInMag<rawMagCapacity && magsLeft>0) {
		//HUD * hud = [[HelloWorldLayer sharedHelloWorldLayer]getHUD];
		//[hud doReloadTimer];
		self.isReloading = YES;
		//reloadSound = [[SimpleAudioEngine sharedEngine]playEffect:@"reloadSFX.wav"];
		[reloadSound play];
		//self.shotsLeftInMag = rawMagCapacity;
		self.magsLeft --;
		canShoot = NO;
		///CCLOG(@"1");
	}else {
		//[[SimpleAudioEngine sharedEngine]playEffect:@"sharpClick.wav"];
		[sharpClick play];
	}

	
}
-(void)addBulletsFromWeapon:(Weapon*)weapon{
    addBullets.position = [[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].position;
	[addBullets play];
	int totalToAdd = weapon.shotsLeftInMag + (weapon.magsLeft * (weapon.magCapacity*10));
	//CCLOG(@"totalToAdd = %i",totalToAdd);
	
	for (int c = 0; c<totalToAdd; c++) {
		shotsLeftInMag++;
		if (shotsLeftInMag>=(magCapacity*10)) {
			magsLeft++;
			shotsLeftInMag = 0;
			//CCLOG(@"magCap = %f",weapon.magCapacity*10);
			//CCLOG(@"magsLeft = %i",magsLeft);
		}
	}
    //[[EventBus sharedEventBus]removeSubscriber:weapon fromEvent:@"@soldierCreated"];
}
-(void)updateDataWithWeapon:(Weapon*)weapon{
	

	self.accuracy = weapon.accuracy;
	self.damage = weapon.damage;
	self.recoil = weapon.recoil;
	self.rateOfFire = weapon.rateOfFire;
	self.reloadTime = weapon.reloadTime;
	self.magCapacity = weapon.magCapacity;
	self.numMags = weapon.numMags;
	self.shotsLeftInMag = weapon.shotsLeftInMag;
	self.magsLeft = weapon.magsLeft;
	self.gunName = [NSString stringWithString:weapon.gunName];
	self.fireType = [NSString stringWithString:weapon.fireType];
    bullets.usingRockets = weapon.isRocketLauncher;
    self.isRocketLauncher = weapon.isRocketLauncher;
	[super createNewSprite:[NSString stringWithFormat:@"%@.png",weapon.gunName]];
    if (super.body) {
        bullets.bulletBodyIndex = (int)super.body->GetFixtureList()->GetFilterData().groupIndex;
    }
    CGSize gunSize = super.sprite.contentSize;
    for (int i = 0; i<10; i++) {
        muzzleFrame[i].position = ccp(gunSize.width,gunSize.height/2);
    }

    
    
	rawMagCapacity = self.magCapacity * 10;
	self.isReloading = NO;
	
	//self.shotsLeftInMag = rawMagCapacity;
	//self.magsLeft = self.numMags;
	
	timeBetweenShots = 11 - rateOfFire;
	timeToReload = 11 - self.reloadTime;
	timeToReload = timeToReload * 25; //relative amount of time it takes to reload all guns
	reloadDelay = 0;
	semiAutoDelay = (11-self.rateOfFire) * 5; //*5
	saDelayCount = semiAutoDelay;
	canShoot = YES;
	hasFiringStickBeenDead = YES;
	isOutOfAmmo = NO;
	self.isFiring = NO;
	
	

		
	
}

-(void)onLinkedBodyDestroyed:(BodyPart*)destroyedBody withPoint:(CGPoint)bloodPos{
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	CCLOG(@"*************************************weapon dealloced*********************************************"); 
	[bullets release];
	//[[EventBus sharedEventBus]removeSubscriber:self fromEvent:@"soldierCreated"];
	[super dealloc];
}




@end
