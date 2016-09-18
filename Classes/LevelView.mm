//
//  LevelView.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelView.h"
#import "Options.h"
#import "HelloWorldLayer.h"
#import "GameController.h"
#import "Level1.h"
@implementation LevelView
@synthesize positionIndicator;

-(void)viewDidLoad{
    [super viewDidLoad];
    NSMutableArray * starArray = [Options sharedOptions].rangesForCurrentLevel;
    NSNumber * twoStarsNum = [starArray objectAtIndex:0];
    NSNumber * threeStarsNum = [starArray objectAtIndex:1];
    int twoStarInt = [twoStarsNum intValue];
    int threeStarInt = [threeStarsNum intValue];
    self.view.frame = CGRectMake(0, 0, 350, 100);
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(130, 10, 120, 20);
    label.textAlignment = UITextAlignmentCenter;
    //label.backgroundColor = [UIColor transparent
    label.text = @"Two Stars:";
    [self.view addSubview:label];
    
    threeStars = [[UILabel alloc]init];
    threeStars.frame = CGRectMake(130, 30, 120, 20);
    threeStars.textAlignment = UITextAlignmentCenter;
    threeStars.text = @"Three Stars:";
    [self.view addSubview:threeStars];
    
    TimeLimit = [[UILabel alloc]init];
    TimeLimit.frame = CGRectMake(130, 50, 120, 20);
    TimeLimit.textAlignment = UITextAlignmentCenter;
    TimeLimit.text = @"Time Limit:";
    [self.view addSubview:TimeLimit];
    
    positionIndicator = [[UILabel alloc]init];
    positionIndicator.frame = CGRectMake(250, 70, 120, 20);
    positionIndicator.textAlignment = UITextAlignmentCenter;
    positionIndicator.text = @"(0,0)";
    [self.view addSubview:positionIndicator];
    
    ttextField = [[UITextField alloc]initWithFrame:CGRectMake(240, 10, 70, 20)];
    ttextField.borderStyle = UITextBorderStyleNone;
    ttextField.textColor = [UIColor redColor];
    ttextField.font = [UIFont systemFontOfSize:20.0];
    ttextField.autocorrectionType = UITextAutocorrectionTypeNo;
    ttextField.backgroundColor = [UIColor clearColor];
    //textField.keyboardType = UIKeyboardTypeNumberPad;
   // textField.returnKeyType = UIReturnKeyDone;
    ttextField.delegate = self;
    ttextField.placeholder = [NSString stringWithFormat:@"%i",twoStarInt];
    ttextField.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:ttextField];
    
    field2 = [[UITextField alloc]initWithFrame:CGRectMake(240, 30, 70, 20)];
    field2.borderStyle = UITextBorderStyleNone;
    field2.textColor = [UIColor redColor];
    field2.font = [UIFont systemFontOfSize:20.0];
    field2.autocorrectionType = UITextAutocorrectionTypeNo;
    field2.backgroundColor = [UIColor darkGrayColor];
    //textField.keyboardType = UIKeyboardTypeNumberPad;
    // textField.returnKeyType = UIReturnKeyDone;
    field2.delegate = self;
    field2.placeholder = [NSString stringWithFormat:@"%i",threeStarInt];
    field2.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:field2];

    field3 = [[UITextField alloc]initWithFrame:CGRectMake(240, 50, 70, 20)];
    field3.borderStyle = UITextBorderStyleNone;
    field3.textColor = [UIColor redColor];
    field3.font = [UIFont systemFontOfSize:20.0];
    field3.autocorrectionType = UITextAutocorrectionTypeNo;
    field3.backgroundColor = [UIColor lightGrayColor];
    //textField.keyboardType = UIKeyboardTypeNumberPad;
    // textField.returnKeyType = UIReturnKeyDone;
    field3.delegate = self;
    field3.placeholder = [NSString stringWithFormat:@"%f",[[HelloWorldLayer sharedHelloWorldLayer]getGameController].timeLimit];
    field3.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:field3];

    saveLevel = [[UIButton alloc]initWithFrame:CGRectMake(240, 80, 80, 40)];
    [saveLevel setTitle:@"Save Level" forState:UIControlStateNormal];
    [saveLevel addTarget:self action:@selector(saveLevelPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:saveLevel];
    
    hideButton = [[UIButton alloc]initWithFrame:CGRectMake(170, 80, 80, 40)];
    [hideButton setTitle:@"Hide" forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(hideThis) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hideButton];
    
    showButton = [[UIButton alloc]initWithFrame:CGRectMake(170, 1000, 80, 40)];
    [showButton setTitle:@"Show" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showThis) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:showButton];
}
-(void)dealloc{
    CCLOG(@"level view deallocated");
    [hideButton release];
    [showButton release];
    [label release];
    [positionIndicator release];
    [ttextField release];
    [field2 release];
    [field3 release];
    [threeStars release];
    [TimeLimit release];
    [saveLevel release];
    [super dealloc];
}
 
-(void)hideThis{
    self.view.frame = CGRectMake(0, -1000, 350, 1030);
}
-(void)showThis{
    self.view.frame = CGRectMake(0, 0, 350, 100);
}
-(void)saveLevelPressed:(UIButton*)button{
    CCLOG(@"saving level...");
    BOOL success = [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]saveLevel];
    CCLOG(@"save complete and %i",success);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)TextField{
    return YES;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)TextField{
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)TextField{
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)TextField{
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)curTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; 
{
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)TextField{
    return YES;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)TextField{
    //getting values works fine. Make the rest of the level editor. Remember to test the saving and loading element of this later.
    NSString * input = TextField.text;
    NSMutableArray * levelInfo = [Options sharedOptions].rangesForCurrentLevel;

    
    if (TextField == ttextField) {
        twoStarValue = [input intValue];
        CCLOG(@"twoStarValue = %i",twoStarValue);
        [levelInfo replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:twoStarValue]];
    }
    if (TextField == field2) {
        threeStarValue = [input intValue];
        CCLOG(@"threeStarValue = %i",threeStarValue);
        [levelInfo replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:threeStarValue]];
    }
    if (TextField == field3) {
        timeLimitValue = [input floatValue];
        CCLOG(@"timeLimitValue = %f",timeLimitValue);
        //[levelInfo addObject:[NSNumber numberWithFloat:timeLimitValue]];
    }
    [[HelloWorldLayer sharedHelloWorldLayer]getGameController].timeLimit = timeLimitValue; 
    CCLOG(@"text = %@",TextField.text); 
    [TextField resignFirstResponder];
    return YES;
}// called when 'return' key pressed. return NO to ignore.

@end
