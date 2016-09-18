//
//  PropertiesView.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include <objc/runtime.h>
#import "BodyNode.h"
typedef enum{
    deleteObjects=1,selectSingleObject=2,selectMultipleObjects=3,selectionTypeNone=0
}SelectionType;
@interface PropertiesView :UIViewController <UITextFieldDelegate, CCTargetedTouchDelegate, CCStandardTouchDelegate> {
    Method* methods;
    int longestMethodIndex;
    //NSMutableArray * properties;
    Class curClass;
    NSMutableArray * values;
    NSMutableArray * objectParameters;
    SelectionType curSelectionType;
    int globalParameterIndex; //used for object selection
    CGPoint startLocation;
    CGPoint touchPos1;
    CGPoint touchPos2;
    BOOL shouldListenForMultiTouch;
    BodyNode * curSingleSelectedBN; //this is the object currently selected for editing
   // NSMutableArray * pool;
}
-(void)updateSelectedObjectWithPos:(CGPoint)position Rotation:(float)degreeAngle;
-(void)updatePropertiesWithClass:(Class)aClass;
-(void)finalizeSelection;
@end
