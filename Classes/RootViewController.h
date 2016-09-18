//
//  RootViewController.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "MobclixAds.h"
#import "GameConfig.h"
@interface RootViewController : UIViewController <ADBannerViewDelegate, MobclixAdViewDelegate> {

	ADBannerView * adView;
	MobclixAdView* madView;

	BOOL bannerIsVisible;
	BOOL adsVisible;
	BOOL isGameAlreadyPaused;
	BOOL misGameAlreadyPaused;
	BOOL isGameBeingPlayed;
	BOOL firstCall;
    
}
-(void) showAds:(BOOL)show;
-(void) createAdView;
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@property (nonatomic,assign) BOOL bannerIsVisible;

@property (nonatomic,retain) ADBannerView * adView;
@property (nonatomic, retain) MobclixAdView * madView;
@end

