//
//  RootViewController.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"
#import "Options.h"
#import "RootViewController.h"


@implementation RootViewController

@synthesize bannerIsVisible;


@synthesize adView;

@synthesize madView;

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!self.bannerIsVisible)
	{
		NSLog(@"banner view did load ad");
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		
		//banner.frame = CGRectOffset(banner.frame, 0, 0);
		if ([Options sharedOptions].isIpad == NO) {
			banner.frame = CGRectOffset(banner.frame, 0, 50);
			CCLOG(@"offset 32");
		}else {
			banner.frame = CGRectOffset(banner.frame, 0, 130);
			CCLOG(@"offset 77");
		}
		
		
		// banner is invisible now and moved out of the screen on 50 px
		//CGAffineTransform transform; //= CGAffineTransformMakeTranslation(100, 150);
		//transform = CGAffineTransformTranslate(transform, 100, 10);
		//transform = CGAffineTransformRotate(transform, CC_DEGREES_TO_RADIANS(90));
		//[adView setTransform:CGAffineTransformMakeTranslation(100, 500)];
		//CCLOG(@"banner view pos x = %i",banner.bounds.origin.x);
		
		//banner.frame = CGRectOffset(banner.frame, 0, 0);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
		[madView pauseAdAutoRefresh];
		[self showAds:NO];
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (self.bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		if ([Options sharedOptions].isIpad == NO) {
			banner.frame = CGRectOffset(banner.frame, 0, -50);
			CCLOG(@"offset -32");
		}else {
			banner.frame = CGRectOffset(banner.frame, 0, -130);
			CCLOG(@"offset -77");
		}
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
		
		[madView resumeAdAutoRefresh];
		[self showAds:YES];
	}
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	NSLog(@"Banner view is beginning an ad action");
	BOOL shouldExecuteAction = YES;
	if (!willLeave && shouldExecuteAction)
    {
		// stop all interactive processes in the app
		// [video pause];
		// [audio pause];
		if ([CCDirector sharedDirector].isPaused == YES) {
			isGameAlreadyPaused = YES;
		}else{
			isGameAlreadyPaused = NO;
			[[CCDirector sharedDirector]pause];
			//[[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
		}
		
    }
	return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	// resume everything you've stopped
	// [video resume];
	// [audio resume];
	//GameScene * tempScene = [[[GameScene alloc]init]autorelease];
	if (isGameAlreadyPaused == NO) {
		[[CCDirector sharedDirector]resume];
		//[[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
	}
	
	
}

- (void)adViewDidFinishLoad:(MobclixAdView*)cadView {
	NSLog(@"Ad Loaded: %@.", NSStringFromCGSize(cadView.frame.size));
	[self showAds:YES];
}

- (void)adView:(MobclixAdView*)cadView didFailLoadWithError:(NSError*)error {
	NSLog(@"Ad Failed: %@.", NSStringFromCGSize(cadView.frame.size));
	[self showAds:NO];
}

- (void)adViewWillTouchThrough:(MobclixAdView*)cadView {
	NSLog(@"Ad Will Touch Through: %@.", NSStringFromCGSize(cadView.frame.size));
	misGameAlreadyPaused = [[CCDirector sharedDirector]isPaused];
	if (misGameAlreadyPaused == NO) {
		[[CCDirector sharedDirector]pause];
	}
}

- (void)adViewDidFinishTouchThrough:(MobclixAdView*)cadView {
	NSLog(@"Ad Did Finish Touch Through: %@.", NSStringFromCGSize(cadView.frame.size));
	if (misGameAlreadyPaused == NO) {
		[[CCDirector sharedDirector]resume];
	}
}



- (void)viewDidLoad {
	CCLOG(@"view did load method called");
    
    
    NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
	NSString* reqSysVer = @"4.0";
	bool isOSVer42 = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	Class iadClass = NSClassFromString(@"ADBannerView");
	BOOL showAdd = [Options sharedOptions].isLite;
    
    
    
	if (iadClass !=nil && showAdd !=NO && isOSVer42) {
		
		
		NSString* currSysVer = [[UIDevice currentDevice]model];
		
		adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
		
		if ([currSysVer compare: @"iPad"] == NSOrderedSame) {
			
			adView.frame = CGRectOffset(adView.frame, 0, -130);
			CCLOG(@"offset 120");
			
			
		}else {
			adView.frame = CGRectOffset(adView.frame, 0, -50);
		}
		
		adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait]; //use update landscape identifier.
		adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
		
		
		CCLOG(@"view did load!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
		
		adView.delegate=self;
		
		[self.view addSubview:adView];
		self.bannerIsVisible=NO;
		[self createAdView];
	}else {
		CCLOG(@"if statement failed*******************************************************");
	}

	//creates mobclix add view;
	firstCall = YES;
	 
	[super viewDidLoad];
	
	
}



//Mobclix stuff starts here
-(void)createAdView{
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	if ([Options sharedOptions].isIpad == YES) {
		self.madView = [[[MobclixAdViewiPad_728x90 alloc]initWithFrame:CGRectZero]autorelease];
		self.madView.center = CGPointMake(screenSize.width/2,-100); //728+100);//728 X 90	  (screenSize.width/1.3,-100)
	}else {
		self.madView = [[[MobclixAdViewiPhone_320x50 alloc]initWithFrame:CGRectZero]autorelease];
		self.madView.center = CGPointMake(screenSize.width/2,-25); //320+25);    (screenSize.width/1.3,-25)
	}
	self.madView.delegate = self;
	// 320+25  //1.5
	[self.view addSubview:self.madView];
	[self.madView pauseAdAutoRefresh];
	
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.madView resumeAdAutoRefresh];
	CCLOG(@"add auto refresh resumed");
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.madView pauseAdAutoRefresh];
	CCLOG(@"add auto refresh paused");
}


-(void) showAds:(BOOL)show{
    
    
	if (isGameBeingPlayed==YES) {
		CCLOG(@"game is already being played. Don't try to load an add!!");
		return;
	}
	if (madView!=nil) {
		if (firstCall == YES) {
			firstCall = NO;
			adsVisible = NO;
		}
		float offset = 0.0;
		if (adsVisible && !show) {
			if ([Options sharedOptions].isIpad == YES) {
				offset = -100.0;
			}else {
				offset = -50.0;
			}
			//[madView pauseAdAutoRefresh];
		}
		if (!adsVisible && show) {
			if (self.bannerIsVisible == YES) {
				CCLOG(@"banner is visible. don't show an add");
				return;
			}
			
			if ([Options sharedOptions].isIpad == YES) {
				offset = 100.0;
			}else {
				offset = 50.0;
			}
		}
		if (offset != 0.0) {
			[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
			madView.frame = CGRectOffset(madView.frame, 0, offset);
			[UIView commitAnimations];
			adsVisible = show;
			NSLog(@"madView.frame.origin = %@",NSStringFromCGPoint(madView.frame.origin));
		}
	}
}

- (void)dealloc {
	adView.delegate=nil;
	[adView release];
	[madView release];
	
	[self.madView cancelAd];
	self.madView.delegate = nil;
	self.madView = nil;
	
    [super dealloc];
}


//#endif
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
 }
 */
-(BOOL)shouldAutorotate{
    return [self shouldAutorotateToInterfaceOrientation:[[UIDevice currentDevice]orientation]];
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationLandscapeRight); //used to be UIInterfaceOrientationPortrait
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end

