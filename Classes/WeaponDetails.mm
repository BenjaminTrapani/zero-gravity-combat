//
//  WeaponDetails.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeaponDetails.h"
#import "GPBar.h"
#import "Weapon.h"
#import "Options.h"
#import "BaseAI.h"
@implementation WeaponDetails
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		accuracy = [GPBar barWithBarFrame:@"bar.png" insetFrame:@"inset.png" maskFrame:@"mask.png"];
		damage = [GPBar barWithBarFrame:@"bar.png" insetFrame:@"inset.png" maskFrame:@"mask.png"];
		rateOfFire = [GPBar barWithBarFrame:@"bar.png" insetFrame:@"inset.png" maskFrame:@"mask.png"];
		recoil = [GPBar barWithBarFrame:@"bar.png" insetFrame:@"inset.png" maskFrame:@"mask.png"];
		//reloadTime = [GPBar barWithBarFrame:@"bar.png" insetFrame:@"inset.png" maskFrame:@"mask.png"];
		CGSize screenSize = [[CCDirector sharedDirector]winSize];
		
		CCSprite * backing = [CCSprite spriteWithSpriteFrameName:@"gunInfoBacking.png"];
		backing.rotation = 90;
		backing.scaleX = 0.7;
		backing.scaleY = 1.3;
		backing.position = ccp(0,screenSize.height/13);
		[self addChild:backing];
		CGSize backingSize = backing.contentSizeInPixels;
		backingSize.width = backingSize.width * 1.3;
		backingSize.height = backingSize.height * 0.7;
		nameLabel = [CCLabelTTF labelWithString:@"." fontName:@"futured.ttf" fontSize:20];
		CGSize nameLabelSize = nameLabel.contentSizeInPixels;
		[nameLabel setString:@""];
		nameLabel.position = ccp(backing.position.x,backing.position.y + backingSize.height/2 + nameLabelSize.height);
		[self addChild:nameLabel];
		accuracyLabel = [CCLabelTTF labelWithString:@"" fontName:@"futured.ttf" fontSize:10];
		damageLabel = [CCLabelTTF labelWithString:@"" fontName:@"futured.ttf" fontSize:10];
		rateOfFireLabel = [CCLabelTTF labelWithString:@"" fontName:@"futured.ttf" fontSize:10];
		recoilLabel = [CCLabelTTF labelWithString:@"" fontName:@"futured.ttf" fontSize:10];
		accuracyLabel.color = ccc3(5, 5, 5);
		damageLabel.color = ccc3(5, 5, 5);
		rateOfFireLabel.color = ccc3(5, 5, 5);
		recoilLabel.color = ccc3(5, 5, 5);
		//reloadTimeLabel = [CCLabelTTF labelWithString:@"" fontName:@"futured.ttf" fontSize:10];
		CCSprite* tempSprite = [CCSprite spriteWithSpriteFrameName:@"inset.png"];
		CGSize barSize = tempSprite.contentSizeInPixels;
		
		accuracy.position = ccp(-screenSize.width/2,barSize.height*2-screenSize.height/2);
		damage.position = ccp(-screenSize.width/2,barSize.height-screenSize.height/2);
		rateOfFire.position = ccp(-screenSize.width/2,-screenSize.height/2);
		recoil.position = ccp(-screenSize.width/2,-barSize.height-screenSize.height/2);
		//reloadTime.position = ccp(-screenSize.width/2,-barSize.height*2-screenSize.height/2);
		
		
		[self addChild:accuracy];
		[self addChild:damage];
		[self addChild:rateOfFire];
		[self addChild:recoil];
		//[self addChild:reloadTime];
		
		
		//adjust all label positions up half screen x and half screen y 
		
		accuracyLabel.position = ccp(accuracy.position.x + screenSize.width/2, accuracy.position.y + screenSize.height/2 - [[Options sharedOptions]makeYConstantRelative:4.5]);
		damageLabel.position = ccp(damage.position.x + screenSize.width/2, damage.position.y + screenSize.height/2- [[Options sharedOptions]makeYConstantRelative:4.5]);
		rateOfFireLabel.position = ccp(rateOfFire.position.x + screenSize.width/2, rateOfFire.position.y + screenSize.height/2- [[Options sharedOptions]makeYConstantRelative:4.5]);
		recoilLabel.position = ccp(recoil.position.x + screenSize.width/2, recoil.position.y + screenSize.height/2- [[Options sharedOptions]makeYConstantRelative:4.5]);
		//reloadTimeLabel.position = ccp(reloadTime.position.x + screenSize.width/2, reloadTime.position.y + screenSize.height/2- [[Options sharedOptions]makeYConstantRelative:4.5]);
		
		CCLabelTTF * accuracyTitle = [CCLabelTTF labelWithString:@"Accuracy" fontName:@"futured.ttf" fontSize:10];
		accuracyTitle.position = ccp(accuracy.position.x + screenSize.width/2, accuracy.position.y + screenSize.height/2+[[Options sharedOptions]makeYConstantRelative:9]);
		accuracyTitle.color = ccc3(5, 5, 5);
		[self addChild:accuracyTitle];
		
		CCLabelTTF * damageTitle = [CCLabelTTF labelWithString:@"Damage" fontName:@"futured.ttf" fontSize:10];
		damageTitle.position = ccp(damage.position.x + screenSize.width/2, damage.position.y + screenSize.height/2+[[Options sharedOptions]makeYConstantRelative:9]);
		damageTitle.color = ccc3(5, 5, 5);
		[self addChild:damageTitle];
		
		CCLabelTTF * rateOfFireTitle =[CCLabelTTF labelWithString:@"Rate Of Fire" fontName:@"futured.ttf" fontSize:10];
		rateOfFireTitle.position = ccp(rateOfFire.position.x + screenSize.width/2, rateOfFire.position.y + screenSize.height/2+[[Options sharedOptions]makeYConstantRelative:9]);
		rateOfFireTitle.color = ccc3(5, 5, 5);
		[self addChild:rateOfFireTitle];
		
		CCLabelTTF * recoilTitle = [CCLabelTTF labelWithString:@"Recoil" fontName:@"futured.ttf" fontSize:10];
		recoilTitle.position = ccp(recoil.position.x + screenSize.width/2, recoil.position.y + screenSize.height/2+[[Options sharedOptions]makeYConstantRelative:9]);
		recoilTitle.color = ccc3(5, 5, 5);
		[self addChild:recoilTitle];
		
		/*[accuracy addChild:accuracyLabel];
		[damage addChild:damageLabel];
		[rateOfFire addChild:rateOfFireLabel];
		[recoil addChild:recoilLabel];
		[reloadTime addChild:reloadTimeLabel];
		 */
		[self addChild:accuracyLabel];
		[self addChild:damageLabel];
		[self addChild:rateOfFireLabel];
		[self addChild:recoilLabel];
		//[self addChild:reloadTimeLabel];
	}
	return self;
}
-(void)updateDataWithWeapon:(Weapon*)weapon{
	[accuracyLabel setString:[NSString stringWithFormat:@"%i/10",(int)weapon.accuracy]];
	[damageLabel setString:[NSString stringWithFormat:@"%i/10",(int)weapon.damage]];
	[rateOfFireLabel setString:[NSString stringWithFormat:@"%i/10",(int)weapon.rateOfFire]];
	[recoilLabel setString:[NSString stringWithFormat:@"%i/10",(int)weapon.recoil]];
	[nameLabel setString:weapon.gunName];
	//[reloadTimeLabel setString:[NSString stringWithFormat:@"%i/10",(int)weapon.reloadTime]];
	accuracy.progress = weapon.accuracy * 10;
	damage.progress = weapon.damage * 10;
	rateOfFire.progress = weapon.rateOfFire * 10;
	recoil.progress = weapon.recoil * 10;
	//reloadTime.progress = weapon.reloadTime * 10;
	CCLOG(@"details updated");
	
}
+(id)details{
	return [[[self alloc]init]autorelease];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

@end
