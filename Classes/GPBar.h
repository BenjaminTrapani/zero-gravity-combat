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



#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
	kBarRounded,
	kBarRectangle,
} kBarTypes;

@interface GPBar : CCNode {
    NSString *bar, *inset, *mask;
    CCSprite *barSprite, *maskSprite, *insetSprite, *masked;
    CCRenderTexture *renderMasked, *renderMaskNegative;
    kBarTypes type;
    float progress;
    BOOL active, spritesheet;
    CGPoint screenMid;
    CGSize screenSize;
}
@property (nonatomic, retain ,readonly)	NSString *bar, *inset;
@property (nonatomic, assign) CCSprite * barSprite;
@property (nonatomic) float progress;
@property kBarTypes type;
@property BOOL active;

+(id) barWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m;
-(id) initBarWithBar:(NSString *)b inset:(NSString *)i mask:(NSString *)m;
+(id) barWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m;
-(id) initBarWithBarFrame:(NSString *)b insetFrame:(NSString *)i maskFrame:(NSString *)m;

-(void) hide;
-(void) show;
-(void) setTransparency:(float)trans;
-(void) setProgress:(float)lv;
-(void) clearRender;
-(void) maskBar;
-(void) drawLoadingBar;

@end
