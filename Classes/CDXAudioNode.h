//
//  CCAudioNode.h
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDAudioManager.h"

typedef enum {
	kAudioNodeSinglePlay,
    kAudioNodeLoop,
	kAudioNodePeriodicLoop
} AudioNodePlayMode;

@interface CDXAudioNode : CCNode {
    
    CDSoundEngine *soundEngine;
    CDSoundSource *sound;
    
    CCNode *earNode;
    
    int sourceId;
    
    AudioNodePlayMode playMode;
    
    float minLoopFrequency;
    float maxLoopFrequency;
    
    
    
	BOOL soundEnabled;
	
    float attenuation;
	float halfScreenSize;
    float curPan;
    float curGain;
    BOOL autoRemoveOnFinish;
    BOOL beginCountdown;
}

/**
 Node that acts as the listener
 */
@property (nonatomic,assign) CCNode *earNode;

/**
 Playback loop mode
 */
@property (nonatomic,assign) AudioNodePlayMode playMode;

/**
 Minimum loop frequency for kAudioNodePeriodicLoop (in seconds)
 */
@property (nonatomic,assign) float minLoopFrequency;

/**
 Maximum loop frequency for kAudioNodePeriodicLoop (in seconds)
 */
@property (nonatomic,assign) float maxLoopFrequency;

/**
 Attenuation factor. The higher this value is, the steeper will be
 the volume drop as this sound moves farther from the listener. The
 default value is 0.003
 */
@property (nonatomic,assign) float attenuation;

//should this audio node remove itself from its parent once it has finished playing for the first time
@property (nonatomic,readwrite) BOOL autoRemoveOnFinish;

+ (CDXAudioNode *)audioNodeWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId;

+ (CDXAudioNode *)audioNodeWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId;

/**
 Initializes the audio node with an already created sound buffer, identified by
 the sourceId.
 */
- (id)initWithSoundEngine:(CDSoundEngine *)se sourceId:(int)sId;

/**
 Initializes the audio node with an audio file, creating a sound buffer with the
 specified sourceId.
 */
- (id)initWithFile:(NSString *)file soundEngine:(CDSoundEngine *)se sourceId:(int)sId;

- (void)play;

- (void)pause;

- (void)stop;

@end
