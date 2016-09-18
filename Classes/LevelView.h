//
//  LevelView.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LevelView : UIViewController <UITextFieldDelegate>{
    int twoStarValue;
    int threeStarValue;
    float timeLimitValue;
    UILabel * positionIndicator;
    UILabel * label;
    UILabel * threeStars;
    UILabel * TimeLimit;
    UITextField * ttextField;
    UITextField * field2;
    UITextField * field3;
    UIButton * saveLevel;
    UIButton * hideButton;
    UIButton * showButton;
}
@property(nonatomic,assign)UILabel*positionIndicator;
@end
