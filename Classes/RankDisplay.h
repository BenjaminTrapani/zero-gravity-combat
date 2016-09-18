//
//  RankDisplay.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 2/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GPBar;
@interface RankDisplay : CCNode {
    GPBar * progressBar;
    CCLabelBMFont * rankProgressLabel;
    CCLabelBMFont * totalXP;
    CCLabelBMFont * xpNeededForRankUp;
    CCLabelBMFont * currRank;
    float lengthToPercentRatio;
}
+(id)rankDisplay;
-(void)startRefreshing;
-(void)refresh;
-(void)doneRefreshing;
@end
