//
//  Zero_Gravity_CombatAppDelegate.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Zero_Gravity_CombatAppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "Options.h"
#import "Constants.h"

#import "Mobclix.h"

#import "MainMenu.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Helper.h"
#import "LoadingScene.h"
#include "Singleton.h"

@implementation Zero_Gravity_CombatAppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
		//CC_ENABLE_DEFAULT_GL_STATES();
		//CCDirector *director = [CCDirector sharedDirector];
		//CGSize size = [director winSize];
		//CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"Default.png"];
		//sprite.position = ccp(size.width/2, size.height/2);
		//sprite.rotation = -90;
		//[sprite visit];
		//[[director openGLView] swapBuffers];
		//CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    CCLOG(@"music playing state = %i",[[MPMusicPlayerController iPodMusicPlayer]playbackState]);
	
    if ([[MPMusicPlayerController iPodMusicPlayer]playbackState]!= MPMusicPlaybackStatePlaying) {
        [[Options sharedOptions]cdAudioSourceDidFinishPlaying:nil];
    }
	[Options sharedOptions].isLite = NO;
    
    
	 if ([Options sharedOptions].isLite == YES){
         [Mobclix startWithApplicationId:@"610D97AF-033E-45E2-8B5F-57F9620550DE"]; //change this to a real app id and make new app on moblcix.com
	 }
    
	// Init the window
	
	NSString* currSysVer = [[UIDevice currentDevice]model];
	CCLOG(currSysVer);
	
	if ([currSysVer compare: @"iPad"] == NSOrderedSame) {
		
		[[Options sharedOptions]setIsIpadManually:YES];
        Singleton::sharedInstance()->isIpad = true;
		
	}else {
		[[Options sharedOptions]setIsIpadManually:NO];
        Singleton::sharedInstance()->isIpad = false;
	}
	
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeRight];
	CCLOG(@"landscape right");
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	CCLOG(@"landscape left");
#endif

    
	// Init the View Controller
	//viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController = [[RootViewController alloc]init];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
    glView.multipleTouchEnabled = YES;
	[director setOpenGLView:glView];
	
	
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    //	if( ! [director enableRetinaDisplay:YES] )
    //		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
    //#ifdef _ARM_NEON_
    //#define ARCH_OPTIMAL_PARTICLE_SYSTEM CCQuadParticleSystem //used to be CCQuadParticleSystem
    //#elif _ARM_|| TARGET_IPHONE_SIMULATOR
    //#define ARCH_OPTIMAL_PARTICLE_SYSTEM CCPointParticleSystem
    //#else
    //#error(unknown architecture)
    //#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
    [viewController.view addSubview:glView];
    
	[viewController.view sendSubviewToBack:glView];
    [window addSubview:viewController.view];
    [window setRootViewController:viewController];
    
	
    [[ZGCGKHelper sharedGameKitHelper]setViewController:viewController];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	//load resources
	/*[[SimpleAudioEngine sharedEngine]preloadEffect:@"propulsionSound.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"singleShot.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"reloadSFX.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"goodClick.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"sharpClick.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"ButtonClick.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"equipClick.wav"];
	[[SimpleAudioEngine sharedEngine]preloadEffect:@"boltAction.wav"];
	*/
    //[[SimpleAudioEngine sharedEngine]preloadEffect:@"The Path of the Goblin King.mp3"]; //takes to long to load
    //[[SimpleAudioEngine sharedEngine]preloadEffect:@"Five Armies.mp3"];
	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	//[CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
	
    if ([Options sharedOptions].isIpad) {
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlashd.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlas2hd.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlas3hd.plist"];
    }else{
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlas.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlas2.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"ZGCTextureAtlas3.plist"];
    }
	//remember to fix default saves before publishing. Done!
	
	//while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
		//CCLOG(@"waiting for audio manager to initialize");
	//}
	
	
	//NSArray *sourceGroups = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:81], nil];
	//[soundEngine defineSourceGroups:sourceGroups];
	[self removeStartupFlicker];
	
    [Options sharedOptions]->isLoading = YES;
    
	[[CCDirector sharedDirector] runWithScene:[CCTransitionFade transitionWithDuration:1 scene:[LoadingScene node]]];
    //[[CCDirector sharedDirector] runWithScene:[CCTransitionFade transitionWithDuration:1 scene:[MainMenu node]]];
    /*CGSize screenSize = [[CCDirector sharedDirector]winSize];
    CCSprite * loadingImage = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"sp%i.png",1+arc4random()%LoadingImageCount]];
    loadingImage.position = ccp(screenSize.width/2,screenSize.height/2);
    CGSize relSize = [Helper relativeSizeFromSize:CGSizeMake(480, 320)];
    loadingImage=[Helper scaleSprite:loadingImage toDimensions:relSize];
    [loadingImage visit];
    
    
    CCLabelTTF * loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"futured.ttf" fontSize:25];
    loading.position = ccp(loading.contentSize.width,loading.contentSize.height);
    [loading visit];
 */
	
	
}

-(void) onLocalPlayerAuthenticationChanged{
    // Removes the startup flicker
	[self removeStartupFlicker];
	[Options sharedOptions]->isLoading = false;
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene:[LoadingScene scene]]; //[HelloWorldLayer scene]];
}
-(void) onAchievementsLoaded:(NSDictionary*)achievements{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
