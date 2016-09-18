/*
 * Wrensation: http://www.wrensation.com/
 * Web-Geeks: http://www.web-geeks.com/
 *
 * Copyright (c) 2011 Wrensation + Web-Geeks
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "GPBar.h"


@implementation GPBar
@synthesize bar, inset, type, active, progress, barSprite;

+(id) barWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m {
    return [[[self alloc] initBarWithBar:b inset:i mask:m] autorelease];
}
-(id) initBarWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m {
    if ((self = [super init])) {
        bar = [[NSString alloc] initWithString:b];
        inset = [[NSString alloc] initWithString:i];
        mask = [[NSString alloc] initWithString:m];
        spritesheet = NO;
		
        screenSize = [[CCDirector sharedDirector] winSize];
        
        screenMid = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
        
        barSprite = [[CCSprite alloc] initWithFile:bar];
        barSprite.anchorPoint = ccp(0.5,0.5);
        barSprite.position = screenMid;
		
        insetSprite = [[CCSprite alloc] initWithFile:inset];
        insetSprite.anchorPoint = ccp(0.5,0.5);
        insetSprite.position = screenMid;
        [self addChild:insetSprite z:1];
		
        maskSprite = [[CCSprite alloc] initWithFile:mask];
        maskSprite.anchorPoint = ccp(1,0.5);
        maskSprite.position = screenMid;
        
        renderMasked = [[CCRenderTexture alloc] initWithWidth:screenSize.width height:screenSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMasked sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMasked.position = barSprite.position;
        renderMaskNegative = [[CCRenderTexture alloc] initWithWidth:screenSize.width height:screenSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMaskNegative sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMaskNegative.position = barSprite.position;
        
        [maskSprite setBlendFunc: (ccBlendFunc) {GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
        [maskSprite retain];
        
        [self clearRender];
        
        [self maskBar];
        
        [self addChild:renderMasked z:2];
    }
    return self;
}

+(id) barWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m {
    return [[[self alloc] initBarWithBarFrame:b insetFrame:i maskFrame:m] autorelease];
}
-(id) initBarWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m {
    if ((self = [super init])) {
        bar = [[NSString alloc] initWithString:b];
        inset = [[NSString alloc] initWithString:i];
        mask = [[NSString alloc] initWithString:m];
        spritesheet = YES;
		
		screenSize = [[CCDirector sharedDirector] winSize];
        
        screenMid = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
        
        barSprite = [[CCSprite alloc] initWithSpriteFrameName:bar];
        barSprite.anchorPoint = ccp(0.5,0.5);
        barSprite.position = screenMid;
		
        insetSprite = [[CCSprite alloc] initWithSpriteFrameName:inset];
        insetSprite.anchorPoint = ccp(0.5,0.5);
        insetSprite.position = screenMid;
        [self addChild:insetSprite z:1];
		
        maskSprite = [[CCSprite alloc] initWithSpriteFrameName:mask];
        maskSprite.anchorPoint = ccp(1,0.5);
        maskSprite.position = screenMid;
        
        renderMasked = [[CCRenderTexture alloc] initWithWidth:screenSize.width height:screenSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMasked sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMasked.position = barSprite.position;
        renderMaskNegative = [[CCRenderTexture alloc] initWithWidth:screenSize.width height:screenSize.height pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        [[renderMaskNegative sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
        renderMaskNegative.position = barSprite.position;
        
        [maskSprite setBlendFunc: (ccBlendFunc) {GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
        [maskSprite retain];
        
        [self clearRender];
        
        [self maskBar];
        
        [self addChild:renderMasked z:2];		
    }
    return self;
}
-(void) clearRender {
    [renderMasked beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
    
    [barSprite visit];
    
    [renderMasked end];
    
    [renderMaskNegative beginWithClear:0.0f g:0.0f b:0.0f a:0.0f];
    
    [barSprite visit];
    
    [renderMaskNegative end];
}
-(void) maskBar {
    [renderMaskNegative begin];
    
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    [maskSprite visit];
    
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [renderMaskNegative end];
        
    masked = renderMaskNegative.sprite;
    masked.position = screenMid;
    
    [masked setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [masked retain];
    
    [renderMasked begin];
    
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    [masked visit];
    
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [renderMasked end];
}
-(void) setProgress:(float)lp {
    progress = lp;
    [self drawLoadingBar];
}
-(void) drawLoadingBar {
    maskSprite.position = ccp(((screenSize.width - maskSprite.boundingBox.size.width) / 2) + (progress / 100 * maskSprite.boundingBox.size.width), screenMid.y);
    [self clearRender];
    [self maskBar];
}
-(void) show {
	active = YES;
}
-(void) hide {
	active = NO;
}
-(void) setTransparency:(float)trans {
	if (trans > 0 && trans <= 255) {
		active = YES;
	}
	else if (trans < 0) {
		NSLog(@"Transparency must be greater than or equal 0.");
	}
	else if (trans == 0) {
		
	}
	else if (trans > 255) {
		NSLog(@"Transparency must be less than or equal to 255.");
	}
	barSprite.opacity = trans;
	insetSprite.opacity = trans;
	maskSprite.opacity = trans;
}
-(void)dealloc{
    [masked release];
    [renderMasked release];
    [renderMaskNegative release];
    [maskSprite release];
    [barSprite release];
    [insetSprite release];
    [mask release];
    [bar release];
    [inset release];
    [super dealloc];
}

@end
