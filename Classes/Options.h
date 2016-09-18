//
//  Options.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDAudioManager.h"
#define kLevelLocked -1
#define kLevelUnlocked 1
#define kLevelCompleted 2
#define releaseFileSystem 11
#define debugFileSystem 10
#define fileSystemScheme releaseFileSystem
#define backgroundMusicCount 4
@interface Options : NSObject <CDLongAudioSourceDelegate>{
	BOOL isIpad;
	BOOL isLite;
	BOOL soundEnabled;
    
    //weapon saves
	NSString * primarySave;
	NSString * secondarySave;
    
    //sound open slots
	BOOL soundSlots[CD_SOURCE_LIMIT];
    
    //level stuff
	int currentLevel;
    int levelScore;
    NSMutableArray * rangesForCurrentLevel;
   
    
    //rank stuff
    int currentRank;
    int totalXP;
    NSMutableArray * rankBenchmarks;
    int curTag;
    BOOL isUsingEditor;
    
    //background music stuff
    int lastSongIndex;
    
    @public
    BOOL isLoading;
    
}
+(Options*)sharedOptions;
-(void)setIsIpadManually:(BOOL)isItIpad;
-(BOOL)getSoundEnabled;
-(void)setSoundEnabled:(BOOL)enable;
-(float)makeYConstantRelative:(float)constant;
-(float)makeXConstantRelative:(float)constant;
-(float)makeAverageConstantRelative:(float)constant;
-(void)setPrimarySave:(NSString*)newSave;
-(NSString*)getPrimarySave;
-(void)setSecondarySave:(NSString*)newSave;
-(NSString*)getSecondarySave;
-(int)findNextOpenSoundSlot;
-(void)addSoundToArray:(CDSoundSource*)source index:(int)addIndex;
-(void)removeSoundAtIndex:(int)index;
-(void)clearSoundArray;
-(int)getHighScoreForCurrentLevel;
-(int)getPointsRequiredForRankUp;
-(int)getPercentProgressForRankUp;
-(int)getUnlockStatusForLevel:(int)level;
-(void)setLevelUnlockStatus:(int)status ForLevel:(int)level;
-(void)updateHighestStars:(int)numberOfStars ForLevel:(int)level;
-(int)getHighestStarsForLevel:(int)level;
-(int)nextTag;
-(void)incrementTag;
-(void)saveLevelSavesDictionary:(NSMutableDictionary*)dict forKey:(NSString*)key;
-(NSMutableDictionary*)getLevelSavesDictionaryForKey:(NSString*)key;
-(void)cdAudioSourceDidFinishPlaying:(CDLongAudioSource *) audioSource;
-(float)smartMultByTwo:(float)constant;
@property (nonatomic, readwrite) BOOL isIpad;
@property (nonatomic, readwrite) BOOL isLite;
@property (nonatomic, readwrite) int currentLevel;
@property (nonatomic, readwrite) int levelScore;
@property (nonatomic, assign) NSMutableArray * rangesForCurrentLevel;
@property (nonatomic, readwrite) int currentRank;
@property (nonatomic,readwrite) BOOL isUsingEditor;
        
@property (nonatomic, readwrite) int totalXP;

@end
