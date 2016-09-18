//
//  Options.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Options.h"
#import "CDAudioManager.h"
#import "SimpleAudioEngine.h"

#define rankBenchmark 5.0f //higher values cause less space between ranks, easier to rank up.
@implementation Options
@synthesize isIpad;
@synthesize isLite;
@synthesize currentLevel;
@synthesize levelScore;
@synthesize rangesForCurrentLevel;
@synthesize currentRank;
@synthesize totalXP;
@synthesize isUsingEditor;

static Options *instanceOfOptions;

+(id) alloc
{
	@synchronized(self)
	{
		NSAssert(instanceOfOptions == nil, @"Attempted to allocate a second instance of the singleton: Options");
		instanceOfOptions = [[super alloc] retain];
		return instanceOfOptions;
	}
	return nil;
}

+(Options*) sharedOptions
{
	@synchronized(self)
	{
		if (instanceOfOptions== nil)
		{
			[[Options alloc] init];
			
		}
		
		return instanceOfOptions;
	}
	
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	if ((self =[super init])) {
        isLoading = YES;
        [CDAudioManager sharedManager].backgroundMusic.delegate = self;
        lastSongIndex = backgroundMusicCount+1;
        
		NSFileManager * fm;
		NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString * fName = [paths objectAtIndex:0];
		fm = [NSFileManager defaultManager];
		
		rangesForCurrentLevel = [[NSMutableArray alloc]initWithCapacity:3];
        curTag = 0;
        rankBenchmarks = [[NSMutableArray alloc]initWithCapacity:100];
        for (int i = 0; i<100; i++) {
            NSNumber * curMark = [NSNumber numberWithInt:(100*i*(i/rankBenchmark))];
            [rankBenchmarks addObject:curMark];
        }
        
		for (int b = 0; b<=CD_SOURCE_LIMIT; b++) {
			soundSlots[b]=NO;
		}
		
		if ([fm fileExistsAtPath:fName]==NO) {
			soundEnabled = YES;
			
			CCLOG(@"file not found");
			NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
			[prefs setObject:@"On" forKey:@"newsoundEnabled"];
			[prefs setObject:@"M16a2" forKey:@"primarySave"];
			primarySave = @"M16a2";
			[prefs setObject:@"M92" forKey:@"secondarySave"];
			secondarySave = @"M92";
			[prefs synchronize];
			
		}else {
			CCLOG(@"file exists");
			CCLOG(@"path = %@", fName);
			
			NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
			NSString * cSS = [prefs stringForKey:@"newsoundEnabled"];
			CCLOG(@"cSS = %@",cSS);
			if (cSS == [NSString stringWithFormat:@"On"]) {
				soundEnabled = YES;
				CCLOG(@"Open soundEnabled setting = YES");
			}else if (cSS == [NSString stringWithFormat:@"Off"]) {
				soundEnabled = NO;
                [[SimpleAudioEngine sharedEngine]setEffectsVolume:0.0f];
				CCLOG(@"Open soundEnabled setting = NO");
			}else {
				soundEnabled = YES;
				CCLOG(@"Defaulted to On");
				[prefs setObject:@"On" forKey:@"newSoundEnabled"];
			}
			
			primarySave = [prefs objectForKey:@"primarySave"];
			secondarySave = [prefs objectForKey:@"secondarySave"];
            
            totalXP = [prefs integerForKey:@"totalXP"];
            currentRank = [prefs integerForKey:@"currentRank"];
            if (currentRank == 0) {
                currentRank = 1;
                [prefs setInteger:currentRank forKey:@"currentRank"];
            }
            
			if (primarySave==nil) {
                primarySave = @"M16a2";
            }
            if (secondarySave==nil) {
                secondarySave = @"M92";
            }
			//currentLevel = 3;
                    
		}
		
		
	}
	
	
	return self;
}

-(void)cdAudioSourceDidFinishPlaying:(CDLongAudioSource *) audioSource{ //handle nil values of audioSource
    if (![self getSoundEnabled])return;
        
    
    [self performSelectorInBackground:@selector(playMusicAsync) withObject:nil];
}
-(void)playMusicAsync{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    int aRandom = 1+arc4random()%backgroundMusicCount;
    while (aRandom==lastSongIndex) {
        aRandom = 1+arc4random()%backgroundMusicCount;
    }
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:[NSString stringWithFormat:@"bm%i.mp3",aRandom] loop:NO];
    
    lastSongIndex = aRandom;
    [pool release];
}
-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[instanceOfOptions release];
	instanceOfOptions = nil;
	[rangesForCurrentLevel release];
    [rankBenchmarks release];
	[super dealloc];
}

-(int)nextTag{
    return curTag;
}
-(void)incrementTag{
    curTag ++;
}
-(void)setIsIpadManually:(BOOL)isItIpad{
	self.isIpad = isItIpad;
}
-(BOOL)getSoundEnabled{
	return soundEnabled;
}
-(void)setSoundEnabled:(BOOL)enable{
	soundEnabled = enable;
	NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
	if (soundEnabled == YES) {
		[prefs setObject:@"On" forKey:@"newsoundEnabled"];
        if([[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying]){
        [[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
        }else{
            [self cdAudioSourceDidFinishPlaying:nil];
        }
        [[SimpleAudioEngine sharedEngine]setEffectsVolume:1.0f];
	}
	if (soundEnabled == NO) {
        [[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
        [[SimpleAudioEngine sharedEngine]setEffectsVolume:0.0f];
		[prefs setObject:@"Off" forKey:@"newsoundEnabled"];
	}
	[prefs synchronize];
}
-(float)makeYConstantRelative:(float)constant{
	if (self.isIpad) {
		constant = constant * 2.4;
	}
	return constant;
}
-(float)makeXConstantRelative:(float)constant{
	if (self.isIpad) {
		constant = constant * 2.13;
	}
	return constant;
}
-(float)makeAverageConstantRelative:(float)constant{
	if (self.isIpad) {
		constant = constant * 2.27;
	}
	return constant;
}
-(float)smartMultByTwo:(float)constant{
    if(self.isIpad)
        constant *= 2.0f;
    return constant;
}
-(void)setPrimarySave:(NSString*)newSave{
	primarySave = newSave;
	NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:primarySave forKey:@"primarySave"];
    [prefs synchronize];
}
-(NSString*)getPrimarySave{
	return primarySave;
}
-(void)setSecondarySave:(NSString*)newSave{
	secondarySave = newSave;
	NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:secondarySave forKey:@"secondarySave"];
    [prefs synchronize];
}
-(NSString*)getSecondarySave{
	return secondarySave;
}

-(void)setCurrentLevel:(int)ncurrentLevel{
    currentLevel = ncurrentLevel;
    CCLOG(@"current level set to %i", ncurrentLevel);
}
-(void)setLevelScore:(int)nlevelScore{
    levelScore = nlevelScore;
    //[self addPointsToScore:nlevelScore];
    if (levelScore>[self getHighScoreForCurrentLevel]) {
        [[NSUserDefaults standardUserDefaults]setInteger:levelScore forKey:[NSString stringWithFormat:@"%i",currentLevel]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(int)getHighScoreForCurrentLevel{
    return [[NSUserDefaults standardUserDefaults]integerForKey:[NSString stringWithFormat:@"%i",currentLevel]];
}

-(void)setTotalXP:(int)ntotalXP{
    totalXP = ntotalXP;
    
    if ([self getPointsRequiredForRankUp]<=0) {
        //CCLOG(@"rank told to increment");
        self.currentRank+= 1;
    }
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:totalXP forKey:@"totalXP"];
    [prefs synchronize];
}
-(int)getTotalXP{
    return totalXP;
}
-(int)getPointsRequiredForRankUp{
    NSNumber * numberAtIndex = (NSNumber*)[rankBenchmarks objectAtIndex:self.currentRank];
    return numberAtIndex.intValue-self.totalXP; 
}
-(int)getPercentProgressForRankUp{
    NSNumber * goal = (NSNumber*)[rankBenchmarks objectAtIndex:self.currentRank];
    //CCLOG(@"goal.intValue = %i",goal.intValue);
    NSNumber * cameFrom = (NSNumber*)[rankBenchmarks objectAtIndex:self.currentRank-1];
   // CCLOG(@"cameFrom.intValue = %i",cameFrom.intValue);
    int progress = self.totalXP - cameFrom.intValue;
    //CCLOG(@"progress = %i",progress);
    //CCLOG(@"total xp = %i",totalXP);
    int totalDif = goal.intValue - cameFrom.intValue;
    float retVal = (float)progress/(float)totalDif *100;
    //CCLOG(@"retVal =%f",retVal);//this does indeed = 0. Check the values for progress and totalDif. I suspect totalXP is what is scewing this up
    return (int)retVal;
       
}
-(void)setCurrentRank:(int)ncurrentRank{
    currentRank = ncurrentRank;
    //CCLOG(@"rank incremented");
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:currentRank forKey:@"currentRank"];
    [prefs synchronize];
}

-(int)getCurrentRank{
    return currentRank;
}

-(int)findNextOpenSoundSlot{
	for (int b = 0; b<=CD_SOURCE_LIMIT; b++) {
		if (soundSlots[b]==NO) {
			//CCLOG(@"found empty slot");
			return b;
		}
	}	
	for (int b = 0; b<=CD_SOURCE_LIMIT; b++) {
		if (soundSlots[b]==YES) {
			CCLOG(@"had to replace already created sound with new sound with id %i",b);
			return b;
		}
	}
}
-(void)addSoundToArray:(CDSoundSource*)source index:(int)addIndex{
	//[sounds insertObject:source atIndex:addIndex];
	soundSlots[addIndex]=YES;
}
-(void)removeSoundAtIndex:(int)index{
	//CCLOG(@"sound removed at index: %i",index);
	soundSlots[index]=NO;
	/*for (int v = 0; v<40; v++) {
		if (soundSlots[v]==YES) {
			CCLOG(@"sound still present in array at index %i",v);
		}
	}
	 */
}
-(void)clearSoundArray{
	for (int b = 0; b<=CD_SOURCE_LIMIT; b++) {
		soundSlots[b]=NO;
	}
}
-(int)getUnlockStatusForLevel:(int)level{
    NSNumber * num = (NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"levelStatus%i",level]];
    int value = num.intValue;
    if (value == 0 && level!=1) {
        value = kLevelLocked;
    }
    return value;
}
-(void)setLevelUnlockStatus:(int)status ForLevel:(int)level{
    NSNumber * num = [NSNumber numberWithInt:status];
    [[NSUserDefaults standardUserDefaults]setObject:num forKey:[NSString stringWithFormat:@"levelStatus%i",level]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)updateHighestStars:(int)numberOfStars ForLevel:(int)level{
    if (numberOfStars>[self getHighestStarsForLevel:self.currentLevel]) {
        NSNumber * num = [NSNumber numberWithInt:numberOfStars];
        [[NSUserDefaults standardUserDefaults]setObject:num forKey:[NSString stringWithFormat:@"levelStars%i",level]];
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
}
-(int)getHighestStarsForLevel:(int)level{
    NSNumber * valueForLevel =(NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"levelStars%i",level]];
    if (valueForLevel!=nil) {
        return valueForLevel.intValue;
    }else {
        return 0;
    }
}
-(void)saveLevelSavesDictionary:(NSMutableDictionary*)dict forKey:(NSString*)key{
    NSFileManager * fm;
    NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString * fName = [paths objectAtIndex:0];
    fm = [NSFileManager defaultManager];
    NSString * saveLocation = [fName stringByAppendingPathComponent:[NSString stringWithFormat:@"LevelSaves%@",key]]; //try .plist
    if ([fm fileExistsAtPath:fName]==NO) {
        CCLOG(@"save path not found in saveLevelSavesDictionary in Options");
    }else{
        if ([fm fileExistsAtPath:saveLocation]==NO) {
            [fm createFileAtPath:saveLocation contents:nil attributes:nil];
            CCLOG(@"file didn't exist at level save location and was created");
        }
        BOOL success = [NSKeyedArchiver archiveRootObject:dict toFile:saveLocation];
        if (!success) {
            CCLOG(@"file saving and archiving wasn't successful"); //this part gets called.
        }
    }
}
-(NSMutableDictionary*)getLevelSavesDictionaryForKey:(NSString*)key{
    NSFileManager * fm;
    if (fileSystemScheme == releaseFileSystem) { //got both file schemes working correctly. When you want to release the game, open iExplorer and drag LevelSaves to desktop. Delete current one and replace. Switch file system scheme to releaseFileSystem
        NSString * bundle = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"LevelSaves%@",key] ofType:@""];
        CCLOG(@"bundlePath = %@",bundle);
        NSMutableDictionary * saves = [NSKeyedUnarchiver unarchiveObjectWithFile:bundle];
        //NSArray * keys = [saves allKeys];
        return saves;
    }else{
        NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString * fName = [paths objectAtIndex:0];
        fm = [NSFileManager defaultManager];
        NSString * saveLocation = [fName stringByAppendingPathComponent:[NSString stringWithFormat:@"LevelSaves%@",key]];
        if ([fm fileExistsAtPath:fName]==NO) {
            CCLOG(@"save path not found in saveLevelSavesDictionary in Options");
        }else{
            NSMutableDictionary * saves = [NSKeyedUnarchiver unarchiveObjectWithFile:saveLocation];
            return saves;
        }
    }
    
}
@end
