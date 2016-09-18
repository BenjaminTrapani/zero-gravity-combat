//
//  ZGCGKHelper.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ZGCGKHelper.h"



static NSString* kCachedAchievementsFile = @"CachedAchievements.archive";
static NSString* kCachedScoresFile = @"CashedScores.archive";
@interface ZGCGKHelper (Private)
-(void) setLastError:(NSError*)error;
-(UIViewController*) getRootViewController;
@end




@implementation ZGCGKHelper


static ZGCGKHelper *instanceOfGameKitHelper;

+(id) alloc
{
	@synchronized(self)
	{
		NSAssert(instanceOfGameKitHelper == nil, @"Attempted to allocate a second instance of the singleton: GameKitHelper");
		instanceOfGameKitHelper = [[super alloc] retain];
		return instanceOfGameKitHelper;
	}
	return nil;
}

+(ZGCGKHelper*) sharedGameKitHelper
{
	@synchronized(self)
	{
		if (instanceOfGameKitHelper == nil)
		{
			[[ZGCGKHelper alloc] init];
		}
		
		return instanceOfGameKitHelper;
	}
	
	// to avoid compiler warning
	return nil;
}
@synthesize delegate;
@synthesize isGameCenterAvailable;
@synthesize lastError;
@synthesize currentMatch;
@synthesize matchStarted;
@synthesize achievements;

-(id) init
{
	if ((self =[super init])) {
		Class gameKitLocalPlayerClass = NSClassFromString(@"GKLocalPlayer");
		bool isLocalPlayerAvailable = (gameKitLocalPlayerClass != nil);
		
		// Test if device is running iOS 4.1 or higher
		NSString* reqSysVer = @"4.1";
		NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
		bool isOSVer41 = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
		
		isGameCenterAvailable = (isLocalPlayerAvailable && isOSVer41);
		NSLog(@"GameCenter available = %@", isGameCenterAvailable ? @"YES" : @"NO");
		
		[self registerForLocalPlayerAuthChange];
		[self initCachedAchievements];
		
	}
	return self;
}
-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
    [currentViewController release];
	[instanceOfGameKitHelper release];
	instanceOfGameKitHelper = nil;
	[lastError release];
	[currentMatch release];
	[[NSNotification defaultCenter] removeObserver:self];
	[super dealloc];
}
-(void) setLastError:(NSError*)error
{
	[lastError release];
	lastError = [error copy];
	if (lastError !=nil) 
	{
		NSLog(@"GameKitHelper ERROR: %@", [[lastError userInfo] description]);
	}
}
-(void) authenticateLocalPlayer
{
	if (isGameCenterAvailable == NO) {
        [delegate onLocalPlayerAuthenticationChanged];
		return;
    }
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	if (localPlayer.authenticated == NO) {
		[localPlayer authenticateWithCompletionHandler:^(NSError* error)
		 {
			 [self setLastError:error];
			 [self reportCachedAchievements];
			 [self loadAchievements];
			 [self reportCachedScores];
			 [self initMatchInvitationHandler];
		 }];
	}
}
-(void) onLocalPlayerAuthenticationChanged
{
	[delegate onLocalPlayerAuthenticationChanged];
}
-(void) registerForLocalPlayerAuthChange
{
	if (isGameCenterAvailable == NO) 
		return;
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(onLocalPlayerAuthenticationChanged)
			   name:GKPlayerAuthenticationDidChangeNotificationName
			 object:nil];
}
-(void) getLocalPlayerFriends
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	
	if (localPlayer.authenticated)
	{
		// First, get the list of friends (player IDs)
		[localPlayer loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* error)
		 
		 {
			 [self setLastError:error];
			 [delegate onFriendListReceived:friends];
		 }];
	}
}
-(void) getPlayerInfo:(NSArray*)playerList
{
	if (isGameCenterAvailable == NO)
		return;
	
	if ([playerList count] > 0)
	{
		// Get detailed information about a list of players
		[GKPlayer loadPlayersForIdentifiers:playerList withCompletionHandler:^(NSArray* players, NSError* error)
         
		 {
			 [self setLastError:error];
			 [delegate onPlayerInfoReceived:players];
		 }];
		CCLOG(@"got player info");
	}else {
		[delegate noFriends];
	}
    
}







-(void) submitScores:(int64_t)score  category:(NSString*)category
{
	if (isGameCenterAvailable == NO){
        return;
	}
	GKScore* gkScore = [[[GKScore alloc] initWithCategory:category] autorelease];
	
	gkScore.value = score;
    
	
	[gkScore reportScoreWithCompletionHandler:^(NSError* error)
	 {
		 [self setLastError:error];
		 
		 bool success = (error == nil);
         if (!success) {
             NSLog(@"Error Reporting High Score: %@", [[error userInfo] description]);
         }
		 [delegate onScoresSubmitted:success];
	 }];
}

-(void) retrieveScoresForPlayers:(NSArray*)players
						category:(NSString*)category 
						   range:(NSRange)range
					 playerScope:(GKLeaderboardPlayerScope)playerScope 
					   timeScope:(GKLeaderboardTimeScope)timeScope 
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKLeaderboard* leaderboard = nil;
	if ([players count] > 0)
	{
		leaderboard = [[[GKLeaderboard alloc] initWithPlayerIDs:players] autorelease];
	}
	else
	{
		leaderboard = [[[GKLeaderboard alloc] init] autorelease];
		leaderboard.playerScope = playerScope;
	}
	
	if (leaderboard != nil)
	{
		leaderboard.timeScope = timeScope;
		leaderboard.category = category;
		leaderboard.range = range;
		[leaderboard loadScoresWithCompletionHandler:^(NSArray* scores, NSError* error)
		 {
			 [self setLastError:error];
			 [delegate onScoresReceived:scores];
		 }];
	}
}

-(void) retrieveTopTenAllTimeGlobalScores
{
	[self retrieveScoresForPlayers:nil
						  category:nil 
							 range:NSMakeRange(1, 10)
					   playerScope:GKLeaderboardPlayerScopeGlobal 
						 timeScope:GKLeaderboardTimeScopeAllTime];
}

-(int) getLocalPlayerLeaderboardHighScore{
	GKLocalPlayer * localPlayer=[GKLocalPlayer localPlayer];
	NSArray * locPlayerArray = [[[NSArray alloc]initWithObjects:localPlayer,nil]autorelease];
	GKLeaderboard * leaderboard = [[[GKLeaderboard alloc]initWithPlayerIDs:locPlayerArray]autorelease]; 
	GKScore * localPlayerHighScore = leaderboard.localPlayerScore;
	int scoreInt = localPlayerHighScore.value;
	return scoreInt;
}

//achievments
-(void) loadAchievements
{
	if (isGameCenterAvailable == NO)
		return;
	
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* loadedAchievements, NSError* error)
	 {
		 [self setLastError:error];
		 
		 if (achievements == nil)
		 {
			 achievements = [[NSMutableDictionary alloc] init];
		 }
		 else
		 {
			 [achievements removeAllObjects];
		 }
		 
		 for (GKAchievement* achievement in loadedAchievements)
		 {
			 [achievements setObject:achievement forKey:achievement.identifier];
		 }
		 
		 [delegate onAchievementsLoaded:achievements];
	 }];
}

-(GKAchievement*) getAchievementByID:(NSString*)identifier
{
	if (isGameCenterAvailable == NO)
		return nil;
	
	// Try to get an existing achievement with this identifier
	GKAchievement* achievement = [achievements objectForKey:identifier];
	
	if (achievement == nil)
	{
		// Create a new achievement object
		achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
		[achievements setObject:achievement forKey:achievement.identifier];
	}
	
	return [[achievement retain] autorelease];
}

-(void) reportAchievementWithID:(NSString*)identifier percentComplete:(float)percent
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKAchievement* achievement = [self getAchievementByID:identifier];
	
	if (achievement != nil && achievement.percentComplete < percent)
	{
		achievement.percentComplete = percent;
		[self cacheAchievement:achievement];
		[achievement reportAchievementWithCompletionHandler:^(NSError* error)
		 {
			 [self setLastError:error];
			 
			 bool success = (error == nil);
			 if (success == NO)
			 {
				 // Keep achievement to try to submit it later
                 // [self cacheAchievement:achievement];
				 
			 }
			 
			 [delegate onAchievementReported:achievement];
		 }];
	}
}

-(void) resetAchievements
{
	if (isGameCenterAvailable == NO)
		return;
	
	[achievements removeAllObjects];
	[cachedAchievements removeAllObjects];
	
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError* error)
	 {
		 [self setLastError:error];
		 bool success = (error == nil);
		 [delegate onResetAchievements:success];
	 }];
}


-(void) reportCachedAchievements
{
	if (isGameCenterAvailable == NO)
		return;
	
	if ([cachedAchievements count] == 0)
		return;
	
	for (GKAchievement* achievement in [cachedAchievements allValues])
	{
		[achievement reportAchievementWithCompletionHandler:^(NSError* error)
		 {
			 bool success = (error == nil);
			 if (success == YES)
			 {
				 [self uncacheAchievement:achievement];
			 }
		 }];
	}
}

-(void) initCachedAchievements
{
	NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:kCachedAchievementsFile];
	id object = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
	
	if ([object isKindOfClass:[NSMutableDictionary class]])
	{
		NSMutableDictionary* loadedAchievements = (NSMutableDictionary*)object;
		cachedAchievements = [[NSMutableDictionary alloc] initWithDictionary:loadedAchievements];
	}
	else
	{
		cachedAchievements = [[NSMutableDictionary alloc] init];
	}
}
-(NSMutableDictionary*)getCachedAchievements{
	return cachedAchievements;
}
-(void) saveCachedAchievements
{
	NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:kCachedAchievementsFile];
	[NSKeyedArchiver archiveRootObject:cachedAchievements toFile:file];
}

-(void) cacheAchievement:(GKAchievement*)achievement
{
	
	[cachedAchievements setObject:achievement forKey:achievement.identifier];
	
	// Save to disk immediately, to keep achievements around even if the game crashes.
	[self saveCachedAchievements];
}

-(void) uncacheAchievement:(GKAchievement*)achievement
{
	[cachedAchievements removeObjectForKey:achievement.identifier];
	
	// Save to disk immediately, to keep the removed cached achievement from being loaded again
	[self saveCachedAchievements];
}

-(void) reportCachedScores{
	if (isGameCenterAvailable == NO)
		return;
	
	if ([cachedAchievements count] == 0)
		return;
	
	for (GKScore * score in [cachedScores allValues])
	{
		NSLog(@"IIIIIIIIIIIIIIIIITTTTTTTTTTTTTTTWWWWWWWWWWWWWWOOOOOOOOOOOOORRRRRRRRRRKKKKKKKKKEEEEEEEEEEDDDDD");
		[score reportScoreWithCompletionHandler:^(NSError* error)
		 {
			 [self setLastError:error];
			 
			 bool success = (error == nil);
			 if (success == YES) {
				 [self uncacheScore:score];
			 }
			 
		 }];
	}
	
}
-(void) saveCachedScores{
	NSString* file = [NSHomeDirectory() stringByAppendingPathComponent:kCachedScoresFile];
	[NSKeyedArchiver archiveRootObject:cachedAchievements toFile:file];
}
-(void) cacheScore:(GKScore*)score{
	[cachedScores setObject:score forKey:score.category];
	
	// Save to disk immediately, to keep achievements around even if the game crashes.
	[self saveCachedAchievements];
}

-(void) uncacheScore:(GKScore*)score{
	[cachedScores removeObjectForKey:score.category];
	
	// Save to disk immediately, to keep the removed cached achievement from being loaded again
	[self saveCachedScores];
	
}

-(void)setViewController:(UIViewController*)controller{
    [currentViewController release];
    currentViewController = [controller retain];
}

//These are matchmaking stuff
-(void) disconnectCurrentMatch
{
	[currentMatch disconnect];
	currentMatch.delegate = nil;
	[currentMatch release];
	currentMatch = nil;
	
}

-(void) setCurrentMatch:(GKMatch*)match
{
	if ([currentMatch isEqual:match] == NO)
	{
		[self disconnectCurrentMatch];
		currentMatch = [match retain];
		currentMatch.delegate = self;
	}
}

-(void) initMatchInvitationHandler
{
	if (isGameCenterAvailable == NO)
        
		
		return;
	[self disconnectCurrentMatch];
	[GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite* acceptedInvite, NSArray* playersToInvite)
	{
		//[self disconnectCurrentMatch];
		
		if (acceptedInvite)
		{
			[[Options sharedOptions]setGameMode:@"multiplayer:standard"];
			[self showMatchmakerWithInvite:acceptedInvite];
			CCLOG(@"reached acceptedinvite if");
			didPlayerAcceptInvite = YES;
			[delegate onAcceptedInvite];
			
		}
		else if (playersToInvite)
		{
			GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
			request.minPlayers = 2;
			request.maxPlayers = 2;
			request.playersToInvite = playersToInvite;
			[self findMatchForRequest:request];
			[self showMatchmakerWithRequest:request];
			
			CCLOG(@"reached playersToInvite if");
		}
	};
}

-(void) findMatchForRequest:(GKMatchRequest*)request
{
	if (isGameCenterAvailable == NO)
		return;
	
	[[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch* match, NSError* error)
	 {
		 [self setLastError:error];
		 
		 if (match != nil)
		 {
			 [self setCurrentMatch:match];
			 //[delegate onMatchFound:match];
			 if (didPlayerAcceptInvite == YES) {
				 CCLOG(@"reached didPlayerAcceptinvite if");
				 [delegate onStartMatch];
			 }
			 
		 }
	 }];
}

-(void) addPlayersToMatch:(GKMatchRequest*)request
{
	if (isGameCenterAvailable == NO)
		return;
	
	if (currentMatch == nil)
		return;
	
	[[GKMatchmaker sharedMatchmaker] addPlayersToMatch:currentMatch matchRequest:request completionHandler:^(NSError* error)
	 {
		 [self setLastError:error];
		 
		 bool success = (error == nil);
		 [delegate onPlayersAddedToMatch:success];
	 }];
}

-(void) cancelMatchmakingRequest
{
	if (isGameCenterAvailable == NO)
		return;
	
	[[GKMatchmaker sharedMatchmaker] cancel];
}

-(void) queryMatchmakingActivity
{
	if (isGameCenterAvailable == NO)
		return;
	
	[[GKMatchmaker sharedMatchmaker] queryActivityWithCompletionHandler:^(NSInteger activity, NSError* error)
	 {
		 [self setLastError:error];
		 
		 if (error == nil)
		 {
			 [delegate onReceivedMatchmakingActivity];
		 }
	 }];
}

#pragma mark Match Connection

-(void) match:(GKMatch*)match player:(NSString*)playerID didChangeState:(GKPlayerConnectionState)state
{
	switch (state)
	{
		case GKPlayerStateConnected:
			[delegate onPlayerConnected:playerID];
			break;
		case GKPlayerStateDisconnected:
			[delegate onPlayerDisconnected:playerID];
			break;
	}
	
	if (matchStarted == NO) //&& match.expectedPlayerCount == 2)
	{
		CCLOG(@"match started if reached");
		matchStarted = YES;
		if (didPlayerAcceptInvite == NO) {
			[delegate onStartMatch];
		}
		
	}
}

-(void) sendDataToAllPlayers:(void*)data length:(NSUInteger)length
{
	if (isGameCenterAvailable == NO)
		return;
	
	NSError* error = nil;
	NSData* packet = [NSData dataWithBytes:data length:length];
	
    [currentMatch sendDataToAllPlayers:packet withDataMode:GKMatchSendDataUnreliable error:&error];
    [self setLastError:error];
}
-(void) sendReliableDataToAllPlayers:(void*)data length:(NSUInteger)length{
	if (isGameCenterAvailable == NO)
		return;
	
	NSError* error = nil;
	NSData* packet = [NSData dataWithBytes:data length:length];
	
	[currentMatch sendDataToAllPlayers:packet withDataMode:GKMatchSendDataReliable error:&error];
	[self setLastError:error];
	
}
-(void) match:(GKMatch*)match didReceiveData:(NSData*)data fromPlayer:(NSString*)playerID
{
	[delegate onReceivedData:data fromPlayer:playerID];
}
//end matchmaking

#pragma mark Views (Leaderboard, Achievements)

// Helper methods

-(UIViewController*) getRootViewController
{
	return currentViewController;
}

-(void) presentViewController:(UIViewController*)vc
{
    
   	UIViewController* rootVC = [self getRootViewController];
    //[[rootVC parentViewController].view bringSubviewToFront:rootVC.view];
	[[CCDirector sharedDirector] stopAnimation];
    [rootVC presentViewController:vc animated:YES completion:^(void){
        [[CCDirector sharedDirector] startAnimation];
        //[[rootVC parentViewController].view sendSubviewToBack:rootVC.view];
    }];
}

-(void) dismissModalViewController
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC dismissViewControllerAnimated:YES completion:nil];
}

// Leaderboards

-(void) showLeaderboard
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKLeaderboardViewController* leaderboardVC = [[[GKLeaderboardViewController alloc] init] autorelease];
    
	if (leaderboardVC != nil)
	{
		leaderboardVC.leaderboardDelegate = self;
		[self presentViewController:leaderboardVC];
	}
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
	[self dismissModalViewController];
	[delegate onLeaderboardViewDismissed];
}

//achievements

-(void) showAchievements
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKAchievementViewController* achievementsVC = [[[GKAchievementViewController alloc] init] autorelease];
	if (achievementsVC != nil)
	{
		achievementsVC.achievementDelegate = self;
		[self presentViewController:achievementsVC];
	}
}

-(void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController
{
	[self dismissModalViewController];
	[delegate onAchievementsViewDismissed];
}


//Matchmaking view
-(void) showMatchmakerWithInvite:(GKInvite*)invite
{
	GKMatchmakerViewController* inviteVC = [[[GKMatchmakerViewController alloc] initWithInvite:invite] autorelease];
	if (inviteVC != nil)
	{
		CCLOG(@"presented invite VC");
		inviteVC.matchmakerDelegate = self;
		[self presentViewController:inviteVC];
	}
}

-(void) showMatchmakerWithRequest:(GKMatchRequest*)request
{
	GKMatchmakerViewController* hostVC = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
	if (hostVC != nil)
	{
		isPlayerHost = YES;
		CCLOG(@"presented hostVC");
		hostVC.matchmakerDelegate = self;
		[self presentViewController:hostVC];
	}
}

-(void) matchmakerViewControllerWasCancelled:(GKMatchmakerViewController*)viewController
{
	[self dismissModalViewController];
	[delegate onMatchmakingViewDismissed];
}

-(void) matchmakerViewController:(GKMatchmakerViewController*)viewController didFailWithError:(NSError*)error
{
	[self dismissModalViewController];
	[self setLastError:error];
	[delegate onMatchmakingViewError];
}
-(void) matchmakerViewController:(GKMatchmakerViewController*)viewController didFindMatch:(GKMatch*)match
{
	[self dismissModalViewController];
	[self setCurrentMatch:match];
	//[delegate onMatchFound:match];
	//if (didPlayerAcceptInvite == NO ||isPlayerHost == YES) {
	//	[delegate onStartMatch];
	//}else {
    [delegate InviteGameStarted];
	//}
    
	
}




@end
