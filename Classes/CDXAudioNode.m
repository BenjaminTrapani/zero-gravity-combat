//
//  CCAudioNode.m
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//

#import "CDXAudioNode.h"
#import "Options.h"
@implementation CDXAudioNode

@synthesize earNode;
@synthesize playMode;
@synthesize minLoopFrequency;
@synthesize maxLoopFrequency;
@synthesize attenuation;
@synthesize autoRemoveOnFinish;

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) rand() / RAND_MAX) * diff) + smallNumber;
}

+ (CDXAudioNode *)audioNodeWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    return [[[self alloc] initWithSoundEngine:se sourceId:sId] autorelease];
}

+ (CDXAudioNode *)audioNodeWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId {
	NSAssert(file!=nil, @"file for CDXAudioNode can't equal nil");
	NSAssert(se!=nil, @"sound engine for CDXAudioNode can't equal nil");
    return [[[self alloc] initWithFile:file soundEngine:se sourceId:sId] autorelease];
}

- (id)initWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    
    if ((self = [super init])) {
        
        attenuation = 0.003f;
        
        playMode = kAudioNodeSinglePlay;
        
        soundEngine = [se retain];
        
        sourceId = sId;
        
        sound = [[soundEngine soundSourceForSound:sourceId sourceGroupId:0] retain];
    }
    return self;
}

- (id)initWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId {
    
    if ((self = [super init])) {
        if ([file isEqualToString:@"boltAction.wav"]) {
			self.attenuation = 0.006f;
        }else if([file isEqualToString:@"singleShot.wav"]){
            self.attenuation = 0.001f;
        
		}else{
            self.attenuation = 0.003f;
        }
        halfScreenSize = [[CCDirector sharedDirector]winSize].width/2;
        playMode = kAudioNodeSinglePlay;
        
        soundEngine = [se retain];
        
		soundEnabled = [[Options sharedOptions]getSoundEnabled];
        //sourceId = sId;
		sourceId = [[Options sharedOptions]findNextOpenSoundSlot];
		//[soundEngine unloadBuffer:sourceId];
		//CCLOG(@"sourceID = %i",sourceId);
       BOOL success = [soundEngine loadBuffer:sourceId filePath:file];
		NSAssert(success==YES, @"buffer loading didn't succeed");
		sound = [[soundEngine soundSourceForSound:sourceId sourceGroupId:0]retain];
		NSAssert(sound!=nil, @"sound doesn't equal anything with file % @",file);
		[[Options sharedOptions]addSoundToArray:sound index:sourceId];
		beginCountdown = NO;
	}
    return self;
}
-(void)setAutoRemoveOnFinish:(BOOL)sautoRemoveOnFinish{
    autoRemoveOnFinish = sautoRemoveOnFinish;
    [self schedule:@selector(checkAutoRemove)];
}
-(void)checkAutoRemove{
    if (beginCountdown) {
        if (!sound.isPlaying) {
            [self removeFromParentAndCleanup:YES];
            //return;
        }
    }

}
- (void)dealloc {
	//CCLOG(@"audioNode released");
    //[self stop];
	[[Options sharedOptions]removeSoundAtIndex:sourceId];
	//[soundEngine unloadBuffer:sourceId]; 
	//CCLOG(@"sound retainCount = %i", [sound retainCount]);
    [sound release];
	
	//CCLOG(@"sound retainCount = %i", [sound retainCount]);
	//[sound release];
	
    [soundEngine release];
    //CCLOG(@"cdx audionode deallocated");
	//[soundEngine release];
    [super dealloc];
}

- (void)play {
    if (!soundEnabled) {
		return;
	}
    [self unschedule:@selector(play)];
    
    switch (playMode) {
        case kAudioNodeSinglePlay:
            sound.looping = NO;
            break;
        case kAudioNodeLoop:
            sound.looping = YES;
            break;
        case kAudioNodePeriodicLoop:
            sound.looping = NO;
            float delay = sound.durationInSeconds + [self randomFloatBetween:minLoopFrequency and:maxLoopFrequency];
            [self schedule:@selector(play) interval:delay];
        default:
            break;
    }
    
    sound.gain = 0.0f;
	[sound stop];
    [sound play];
    if (self.autoRemoveOnFinish) {
        beginCountdown = YES;
    }
}

- (void)pause {
    [sound pause];
}

- (void)stop {
    [sound stop];
    [self unschedule:@selector(play)];
}

- (void)visit {
    CGPoint realPos = [self convertToWorldSpace:CGPointZero];
    
   // CGSize size = [[CCDirector sharedDirector] winSize];
	
    CGPoint earPos = self.position;
    if (earNode) {
        earPos = [earNode convertToWorldSpace:CGPointZero];
    }
    
    float dist = sqrt((realPos.x - earPos.x) * (realPos.x - earPos.x) + (realPos.y - earPos.y) * (realPos.y - earPos.y));
    
    float distX = realPos.x - earPos.x;
    
    sound.pan = distX / halfScreenSize;
    
    //curPan = distX / (halfScreenSize);
    float gain = 1.0f - (dist * attenuation);
    
    if (gain < 0.0f) gain = 0.0f;
    if (gain > 1.0f) gain = 1.0f;
    
    sound.gain = gain;
    
    //curGain = gain;
	//CCLOG(@"audionode.x = %f audionode.y = %f",realPos.x,realPos.y);
	//CCLOG(@"earpos.x = %f earpos.y = %f",earPos.x,earPos.y);
    [super visit];
    
    
}

-(void)setAttenuation:(float)nattenuation{
    if([Options sharedOptions].isIpad)
        nattenuation/=2.0f;
    
    attenuation = nattenuation;
}

- (void)onExit {
    [self stop];
}

@end
