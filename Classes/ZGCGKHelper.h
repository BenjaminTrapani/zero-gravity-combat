//
//  ZGCGKHelper.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "Options.h"
@protocol GameKitHelperProtocol
-(void) onLocalPlayerAuthenticationChanged;

-(void) onFriendListReceived:(NSArray*)friends;
-(void) onPlayerInfoReceived:(NSArray*)players;
-(void) noFriends;

-(void) onScoresSubmitted:(bool)success;
-(void) onScoresReceived:(NSArray*)scores;

-(void) onMatchFound:(GKMatch*)match;
-(void) onPlayersAddedToMatch:(bool)success;
-(void) onReceivedMatchmakingActivity;
-(void) onAcceptedInvite;
-(void) InviteGameStarted;

-(void) onPlayerConnected:(NSString*)playerID;
-(void) onPlayerDisconnected:(NSString*)playerID;
-(void) onStartMatch;
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID;


-(void) onAchievementReported:(GKAchievement*)achievement;
-(void) onAchievementsLoaded:(NSDictionary*)achievements;
-(void) onResetAchievements:(bool)success;

-(void) onMatchmakingViewDismissed;
-(void) onMatchmakingViewError;
-(void) onLeaderboardViewDismissed;
-(void) onAchievementsViewDismissed;
@end
@interface ZGCGKHelper : NSObject<GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate,GKMatchDelegate, GKAchievementViewControllerDelegate>

{
	id<GameKitHelperProtocol> delegate;
	bool isGameCenterAvailable;
	NSError * lastError;
	GKMatch * currentMatch;
	bool matchStarted;
	bool didPlayerAcceptInvite;
	bool isPlayerHost;
	NSMutableDictionary* achievements;
	NSMutableDictionary* cachedAchievements;
	NSMutableDictionary* cachedScores;
    UIViewController * currentViewController;
}
@property (nonatomic, retain) id<GameKitHelperProtocol> delegate;
@property (nonatomic, readonly) bool isGameCenterAvailable;
@property (nonatomic, readonly) NSError* lastError;
@property (nonatomic, readonly) GKMatch* currentMatch;
@property (nonatomic, readonly) bool matchStarted;
@property (nonatomic, readonly) NSMutableDictionary* achievements;
+(ZGCGKHelper*) sharedGameKitHelper;
-(void) authenticateLocalPlayer;
-(void) getLocalPlayerFriends;
-(void) getPlayerInfo:(NSArray*)players;
-(void) registerForLocalPlayerAuthChange;
-(void)setViewController:(UIViewController*)controller;
-(void) submitScores:(int64_t)score category:(NSString*)category;
-(void) retrieveScoresForPlayers:(NSArray*)players
						category:(NSString*)category
                           range:(NSRange) range
                     playerScore:(GKLeaderboardPlayerScope)playerScope
					   timeScope:(GKLeaderboardTimeScope)timeScope;
-(void) retrieveTopTenAllTimeGlobalScores;
-(int) getLocalPlayerLeaderboardHighScore;
-(void) showLeaderboard;
-(void) showAchievements;

-(void) disconnectCurrentMatch;
-(void) findMatchForRequest:(GKMatchRequest*)request;
-(void) addPlayersToMatch:(GKMatchRequest*)request;
-(void) cancelMatchmakingRequest;
-(void) queryMatchmakingActivity;
-(void) showMatchmakerWithInvite:(GKInvite*)invite;
-(void) showMatchmakerWithRequest:(GKMatchRequest*)request;
-(void) sendDataToAllPlayers:(void *)data length:(NSUInteger)length;
-(void) sendReliableDataToAllPlayers:(void*)data length:(NSUInteger)length;
-(void) getOponent;

-(GKAchievement*) getAchievementByID:(NSString*)identifier;
-(void) reportAchievementWithID:(NSString*)identifier percentComplete:(float)percent;
-(void) loadAchievements;
-(void) resetAchievements;
-(void) reportCachedAchievements;
-(void) saveCachedAchievements;
-(void) cacheAchievement:(GKAchievement*)achievement;
-(void) uncacheAchievement:(GKAchievement*)achievement;
-(NSMutableDictionary*)getCachedAchievements;
-(void) reportCachedScores;
-(void) saveCachedScores;
-(void) cacheScore:(GKScore*)score;
-(void) uncacheScore:(GKScore*)score;
@end
