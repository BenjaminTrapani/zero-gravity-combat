//
//  GreenBlob.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAI.h"

@interface GreenBlob : BaseAI <NSCoding>{
	//BaseAI * myGreenBlob;
    CGPoint _pos;
    int _ID;
}
+(id)blobWithWorld:(b2World*)world Pos:(CGPoint)pos Identifier:(int)identifier;
@end
