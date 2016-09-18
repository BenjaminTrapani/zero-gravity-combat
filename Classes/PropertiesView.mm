//
//  PropertiesView.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "PropertiesView.h"

#import "ObjectProperty.h"
#import "Options.h"
#import "BodyNode.h"
#import "BaseLevelObject.h"
#import "UDTextField.h"
#import "CCTouchDispatcher.h"
#import "RaysCastCallback.h"
#import "LevelView.h"
#import "BaseAI.h"
#import "Weapon.h"
#import "Level1.h"
#import "Soldier.h"
#import "HUD.h"
@implementation PropertiesView

-(void)viewDidLoad{
    self.view.frame = CGRectMake(100, 0, 100, 10);
    CCLOG(@"properties view did load");
    values = [[NSMutableArray alloc]initWithCapacity:50];
    for (int i = 0; i<50; i++) {
        NSNumber * dumby = [NSNumber numberWithInt:1];
        [values addObject:dumby];
    }
    objectParameters = [[NSMutableArray alloc]initWithCapacity:10];
    globalParameterIndex=0;
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-10 swallowsTouches:NO];
    [[CCTouchDispatcher sharedDispatcher]addStandardDelegate:self priority:-10];
        //properties = [[NSMutableArray alloc]initWithCapacity:20];
    //[properties addObject:[NSNumber numberWithInt:1]];
    //pool = [[NSMutableArray alloc]initWithCapacity:20];
    [super viewDidLoad];
}
-(void)dealloc{
    CCLOG(@"PROPERTIES VIEW DEALLOCATED");
    [values release];
    [objectParameters release];
    //[properties release];
    //[pool release];
    [super dealloc];
}
-(void)updatePropertiesWithClass:(Class)aClass{
    curClass = aClass;
    //clears out all the old properties from the view
    /*for (id object in pool) {
        [pool removeObject:object];
        [object release];
    }
     */
    
    NSArray * subviews = self.view.subviews;
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    } //recreates the create button
    self.view.frame = CGRectMake(100, 0, 100, 320);
    UIButton * createButton = [[[UIButton alloc]initWithFrame:CGRectMake(0, 75, 100, 50)]autorelease];
   // [pool addObject:createButton];
    [createButton setTitle:@"CreateObject" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createObject) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:createButton];
    
    UIButton * doneButton = [[[UIButton alloc]initWithFrame:CGRectMake(400, 75, 100, 50)]autorelease];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitle:@"DONE" forState:UIControlStateSelected];
    [doneButton addTarget:self action:@selector(finalizeSelection) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:doneButton];
    
    UIButton * hideButton = [[[UIButton alloc]initWithFrame:CGRectMake(0, 275, 100, 50)]autorelease];
    [hideButton setTitle:@"Hide" forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(hideThis) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:hideButton];
    
    UIButton * deleteMode = [[[UIButton alloc]initWithFrame:CGRectMake(0, 125, 100, 50)]autorelease];
    [deleteMode setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteMode addTarget:self action:@selector(enterDeleteMode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:deleteMode];
    
    UIButton * editButton = [[[UIButton alloc]initWithFrame:CGRectMake(0, 175, 100, 50)]autorelease];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(enterEditMode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:editButton];
     
        //if (methods!=nil) {
        free(methods);
   // }
    
    
    unsigned int retLength = 0;
    const char * charName = [NSStringFromClass(aClass) UTF8String];
    //Method *methods = class_copyMethodList(objc_getMetaClass(charName), &retLength);
    methods = class_copyMethodList(objc_getMetaClass(charName), &retLength);
    int longestParameterList = 0;
    for (int b = 0; b<retLength; b++) {
        int curParameterList = method_getNumberOfArguments(methods[b]);
        if (curParameterList>longestParameterList) {
            longestParameterList = curParameterList;
            longestMethodIndex = b;
        }
    }
    int startY = [[Options sharedOptions]makeYConstantRelative:320];
    int padding = [[Options sharedOptions]makeYConstantRelative:50];
    int xPos = 0;
    int xIncrement = [[Options sharedOptions]makeXConstantRelative:60];
    Options * o = [Options sharedOptions];
    
    //for (int i = 0; i< retLength; i++) {
        NSString * singleString = NSStringFromSelector(method_getName(methods[longestMethodIndex]));
        NSArray * stringList = [singleString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]]; 
        //removes the withWorld paramter. This will always be the same
        //CCLOG(@"stringList = %@",stringList);
        int elementCount = [stringList count];
        for (int c = 1; c<elementCount-1; c++) { //this is all lined up. Now write all the if statements to determine types. Here is a link that describes the types http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1  the only types that should exist are f (float) @ (object) i (int), and CGSize and CGPoint structures {CGPoint=ff
            NSString * parameterLabel = (NSString*)[stringList objectAtIndex:c];
            //CCLOG(@"Parameter label = %@",parameterLabel);                                     
            char * parameterTypes = method_copyArgumentType(methods[longestMethodIndex],c+2); 
            NSString * argsString = [NSString stringWithUTF8String:parameterTypes];
            UILabel * label = [[[UILabel alloc]init]autorelease];
            //[pool addObject:label];
            startY -=padding;
            if (startY<=0) {
                startY = [o makeYConstantRelative:320];
                xPos += xIncrement;
            }
            label.frame = CGRectMake(xPos-35, startY, 70, 20);
            label.text = parameterLabel;
            [self.view addSubview:label];
            
            UDTextField * ttextField = [[[UDTextField alloc]initWithFrame:CGRectMake(xPos+padding, startY, 70, 20)]autorelease];
            //[pool addObject:ttextField];
            ttextField.borderStyle = UITextBorderStyleNone;
            ttextField.textColor = [UIColor redColor];
            ttextField.font = [UIFont systemFontOfSize:20.0];
            ttextField.autocorrectionType = UITextAutocorrectionTypeNo;
            ttextField.backgroundColor = [UIColor yellowColor];
            //textField.keyboardType = UIKeyboardTypeNumberPad;
            // textField.returnKeyType = UIReturnKeyDone;
            ttextField.delegate = self;
            NSMutableArray * userDataArray = [NSMutableArray array];
            [userDataArray addObject:[NSNumber numberWithInt:c]];
            CCLOG(@"Arg type = %@",argsString);
            if ([argsString isEqualToString:@"{CGPoint=ff}"]) {
                [userDataArray addObject:@"CGPoint"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @",";
            }
            if ([argsString isEqualToString:@"{CGSize=ff}"]) {
                [userDataArray addObject:@"CGSize"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @",";
            }
            if ([argsString isEqualToString:@"f"]) {
                [userDataArray addObject:@"float"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @"0.0";
            }
            if ([argsString isEqualToString:@"i"]) {
                [userDataArray addObject:@"Int"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @"0";
            }
            if ([argsString isEqualToString:@"@"]) {
                [userDataArray addObject:@"object"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @"Obj";
            }
            if  ([argsString isEqualToString:@"c"]){
                [userDataArray addObject:@"BOOL"];
                ttextField.userData = userDataArray;
                ttextField.placeholder = @"1=Y,0=N";
            }
            [self.view addSubview:ttextField];
            //need to finish this     
            free(parameterTypes);
        }
        
        
   // }
    
}
-(void)enterEditMode{
    
    curSelectionType = selectSingleObject;
    //[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].body->SetLinearVelocity(b2Vec2(0,0));
    self.view.frame = CGRectMake(-400, 0, 500, 100);
}
-(void)hideThis{
    //[self finalizeSelection];
    NSArray * subviews = self.view.subviews;
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    } 
    self.view.frame = CGRectMake(100, 0, 100, 10);
}
-(void)updatePropertiesWithObject:(BodyNode*)object{ //untested
    
    NSArray * subviews = self.view.subviews;
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    }
    self.view.frame = CGRectMake(100, 0, 100, 320);
    UIButton * createButton = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)]autorelease];
    [createButton setTitle:@"CreateObject" forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createObject) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:createButton];

    
    NSMutableArray * curProperties = [object getProperties];
    int startY = [[Options sharedOptions]makeYConstantRelative:320];
    int padding = [[Options sharedOptions]makeYConstantRelative:50];
    int xPos = 240;
    int xIncrement = [[Options sharedOptions]makeXConstantRelative:60];
    Options * o = [Options sharedOptions];
    for (ObjectProperty * curProp in curProperties) {
        UILabel * label = [[[UILabel alloc]init]autorelease];
        startY -=padding;
        if (startY<=0) {
            startY = [o makeYConstantRelative:320];
            xPos += xIncrement;
        }
        
        UITextField * ttextField = [[[UITextField alloc]initWithFrame:CGRectMake(xPos+padding, startY, 70, 20)]autorelease];
        ttextField.borderStyle = UITextBorderStyleNone;
        ttextField.textColor = [UIColor redColor];
        ttextField.font = [UIFont systemFontOfSize:20.0];
        ttextField.autocorrectionType = UITextAutocorrectionTypeNo;
        ttextField.backgroundColor = [UIColor clearColor];
        //textField.keyboardType = UIKeyboardTypeNumberPad;
        // textField.returnKeyType = UIReturnKeyDone;
        ttextField.delegate = self;

        //determine the value of the id property
        int propValueType = 0;  //0 = error, 1 = CGPoint, 2 = CGSize, 3 = int, 4 = float, 5 = baseLevelObjectClass
        id propValue = curProp.value;
        
        if ([propValue isKindOfClass:[NSValue class]]) {
                CGPoint pval = [propValue CGPointValue];
                CGSize sizeVal = [propValue CGSizeValue];
                if (pval.x == 0 && pval.y ==0) {
                    propValueType = 3;
                    float width = sizeVal.width;
                    float height = sizeVal.height;
                    NSString * placeHolderString = [NSString stringWithFormat:@"%f,%f",width,height];
                    ttextField.placeholder = placeHolderString;
                }else{
                    propValueType = 2;
                    NSString * placeHolderString = [NSString stringWithFormat:@"%f,%f",pval.x,pval.y];
                    ttextField.placeholder = placeHolderString;                                
                }
                
        }
            
        if([propValue isKindOfClass:[NSNumber class]]){
                float floatValue = [propValue floatValue];
                int intValue = [propValue intValue];
                if (floatValue==0) {
                    propValueType = 3;
                    ttextField.placeholder = [NSString stringWithFormat:@"%i",intValue];
                }else{
                    propValueType  =4;
                    ttextField.placeholder = [NSString stringWithFormat:@"%f",floatValue];
                }
            }
            
        if ([propValue isKindOfClass:[BaseLevelObject class]]) {
                propValueType = 5;
                ttextField.placeholder = ((BaseLevelObject*)propValue).uniqueID; 
                
        }
        NSAssert(propValueType!=0,@"unknown property type sent to properties view");
                
        label.frame = CGRectMake(xPos-60, startY, 120, 20);
        label.textAlignment = UITextAlignmentCenter;
        //label.backgroundColor = [UIColor transparent
        label.text = curProp.name;
        [self.view addSubview:label];
        
        ttextField.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:ttextField];

    }
}
-(void)updateSelectedObjectWithPos:(CGPoint)position Rotation:(float)degreeAngle{
    //CCLOG(@"new values set for selected objects in properties view");
    if ([objectParameters count]==0) 
        return;
    HelloWorldLayer * gameLayer = [HelloWorldLayer sharedHelloWorldLayer];
    position = [gameLayer makePointRelative:position];
    BodyNode * objectToUpdate = (BodyNode*)[objectParameters objectAtIndex:0];
    objectToUpdate.body->SetTransform([Helper toMeters:position], degreeAngle); //degreeAngle is actually in radians
   /* CCCamera * myCam = [gameLayer camera];
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    [myCam setEyeX:position.x - screenSize.width/2 eyeY:position.y - screenSize.height/2 eyeZ:1.0];
    [myCam setCenterX:position.x - screenSize.width/2 centerY:position.y - screenSize.height/2 centerZ:0.0];
    [gameLayer getHUD].position = ccp(position.x-screenSize.width/2,position.y-screenSize.height/2); //fix camera snapping to person because of loop
    [gameLayer getGameController]o.position = [gameLayer getHUD].position;
   */
}
-(void)finalizeSelection{
    int objectCount = [objectParameters count];
    CCLOG(@"objects selected Count = %i",objectCount);
    for (BodyNode * bn in objectParameters) {
        bn.sprite.color = ccc3(255, 255, 255);
    }
    if (curSelectionType == selectionTypeNone) {
        [objectParameters removeAllObjects];
        self.view.frame = CGRectMake(100, 0, 100, 320);
        //[HelloWorldLayer sharedHelloWorldLayer].surrenderCameraControl = NO;
        shouldListenForMultiTouch = NO;
        if(curSingleSelectedBN){
            curSingleSelectedBN.body->SetActive(true);
            curSingleSelectedBN = nil;
            
        }
        
        //The above works well. You can place an object with physics disabled. Test sandbag automatic deletion and ai saving init position. Once done, make rocketRobot only use rocket launcher and continue level editing.

        //[HelloWorldLayer sharedHelloWorldLayer].isTouchEnabled=NO;
        return;
    }
    if (curSelectionType==selectSingleObject) {
        curSelectionType = selectionTypeNone;
        if (objectCount>0) {
            curSingleSelectedBN = (BodyNode*)[objectParameters objectAtIndex:0];
            curSingleSelectedBN.body->SetActive(false);
            //[HelloWorldLayer sharedHelloWorldLayer].surrenderCameraControl = YES;
            shouldListenForMultiTouch = YES;
        }
        //[HelloWorldLayer sharedHelloWorldLayer].isTouchEnabled=YES; 
        return;
    }
    //[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel].respondsToTouches=NO; 
    self.view.frame = CGRectMake(100, 0, 100, 320);
    
    //[[CCTouchDispatcher sharedDispatcher]setPriority:10 forDelegate:self];
    if (objectCount==0) {
        curSelectionType = selectionTypeNone;
        return;
    }
    curSelectionType = selectionTypeNone;
    NSMutableArray * objectArrayCopy = [[NSMutableArray alloc]initWithCapacity:objectCount];
    for (id object in objectParameters) {
        [objectArrayCopy addObject:object];
        [object release];
    }
    if (objectCount>1) {
        NSData * data = [NSData dataWithBytes:&objectArrayCopy length:sizeof(objectParameters)];
        [values replaceObjectAtIndex:globalParameterIndex withObject:data];
    }else if(objectCount==1){
        BodyNode * object = [objectParameters objectAtIndex:0];
        NSData * data = [NSData dataWithBytes:&object length:sizeof(object)];
        [values replaceObjectAtIndex:globalParameterIndex withObject:data];
    }
    [objectParameters removeAllObjects];
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //CCLOG(@"touch began");
    CGPoint touchedLocation =[[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    touchedLocation=[[HelloWorldLayer sharedHelloWorldLayer]makePointRelative:touchedLocation];
    [[HelloWorldLayer sharedHelloWorldLayer]getLevelView].positionIndicator.text = [NSString stringWithFormat:@"(%i,%i)",(int)touchedLocation.x,(int)touchedLocation.y];
    startLocation = touchedLocation;
    //CCLOG(@"touchedLocation.x = %f .y = %f",touchedLocation.x,touchedLocation.y);
    return YES;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (curSelectionType == selectionTypeNone) {
        return;
    }
    b2Vec2 vec1 = [Helper toMeters:startLocation];
    CGPoint endPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    endPos = [[HelloWorldLayer sharedHelloWorldLayer]makePointRelative:endPos];
    b2Vec2 vec2 = [Helper toMeters:endPos];
    RaysCastCallback callback;
    b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
    world->RayCast(&callback, vec1, vec2);
    if (callback.m_fixture) {
        //CCLOG(@"fixture");
        BodyNode * bn = (BodyNode*)callback.m_fixture->GetBody()->GetUserData();
        if (curSelectionType==deleteObjects) {
            BodyNode * bn = (BodyNode*)callback.m_fixture->GetBody()->GetUserData();
           // bn.shouldDelete = YES;
            if ([bn isKindOfClass:[BaseLevelObject class]]) {
                if (((BaseLevelObject*)bn).destructible==NO) {
                    bn.shouldDelete = YES;
                }else{
                    ((BaseLevelObject*)bn).health=-1;
                }
            }
            if ([bn isKindOfClass:[BaseAI class]]) {
                ((BaseAI*)bn).health=-1;
            }
            if ([bn isKindOfClass:[Weapon class]]) {
                if (((Weapon*)bn).hasCarrier==NO) {
                    bn.shouldDelete = YES;
                }
                
            }
        }
        if (curSelectionType==selectMultipleObjects) {
            CCLOG(@"object selected for parameter");
            bn.sprite.color = ccc3(0, 0, 0);
            [objectParameters addObject:bn];
            
        }
        if (curSelectionType==selectSingleObject) {
            if ([objectParameters count]>0) {
                BodyNode * oldObject = (BodyNode*)[objectParameters objectAtIndex:0];
                oldObject.sprite.color = ccc3(255, 255, 255);
                [objectParameters replaceObjectAtIndex:0 withObject:bn];
                bn.sprite.color = ccc3(0, 0, 0);
            }else{
                bn.sprite.color = ccBLACK;
                [objectParameters addObject:bn];
            }
            
        }
    }

}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //CCLOG(@"touches began");
    if (!shouldListenForMultiTouch) 
        return;
    NSArray * touchArray = [touches allObjects];
    if ([touchArray count]>=2) {
        UITouch * touch1 = [touchArray objectAtIndex:0];
        UITouch * touch2 = [touchArray objectAtIndex:1];
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector]convertToGL:location1];
        CGPoint location2 = [touch2 locationInView:[touch2 view]];
        location2 = [[CCDirector sharedDirector]convertToGL:location2];
        touchPos1 = location1;
        touchPos2 = location2;
    }else{
        UITouch * touch1 = [touchArray objectAtIndex:0];
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector]convertToGL:location1];
        touchPos1 = location1;
        touchPos2 = location1;
    }
    /*float acceptableError = 20;
    for ( UITouch* touch in touches ) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        //location = [[HelloWorldLayer sharedHelloWorldLayer]makePointRelative:location];
        if (ccpDistance(location, touchPos1)<acceptableError || touch1ShouldReset==YES) {
            touchPos1 = location;
            touch1ShouldReset = NO;
        }
        if (ccpDistance(location, touchPos2)<acceptableError || touch2ShouldReset==YES) {
            touchPos2 = location;
            touch2ShouldReset = NO;
        }
    }
     */
    float angle = angleBetweenPoints(touchPos1, touchPos2);
    //float degreeAngle = CC_RADIANS_TO_DEGREES(angle);
    CGPoint position = ccpMidpoint(touchPos1, touchPos2);
    [self updateSelectedObjectWithPos:position Rotation:angle];
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!shouldListenForMultiTouch) 
        return;
    //CCLOG(@"touches moved");
    NSArray * touchArray = [touches allObjects];
    if ([touchArray count]>=2) {
        UITouch * touch1 = [touchArray objectAtIndex:0];
        UITouch * touch2 = [touchArray objectAtIndex:1];
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector]convertToGL:location1];
        CGPoint location2 = [touch2 locationInView:[touch2 view]];
        location2 = [[CCDirector sharedDirector]convertToGL:location2];
        touchPos1 = location1;
        touchPos2 = location2;
    }
   /* }else{
        UITouch * touch1 = [touchArray objectAtIndex:0];
        CGPoint location1 = [touch1 locationInView:[touch1 view]];
        location1 = [[CCDirector sharedDirector]convertToGL:location1];
        touchPos1 = location1;
        touchPos2 = location1;
    }
    */
    float angle = angleBetweenPoints(touchPos1, touchPos2);
    //float degreeAngle = CC_RADIANS_TO_DEGREES(angle);
    CGPoint position = ccpMidpoint(touchPos1, touchPos2);
    [self updateSelectedObjectWithPos:position Rotation:angle];}
/*- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!shouldListenForMultiTouch) 
        return;
    
    float acceptableError = 20;
    for ( UITouch* touch in touches) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        //location = [[HelloWorldLayer sharedHelloWorldLayer]makePointRelative:location];
        if (ccpDistance(location, touchPos1)<acceptableError) {
            touchPos1 = location;
            touch1ShouldReset = YES;
        }
        if (ccpDistance(location, touchPos2)<acceptableError) {
            touchPos2 = location;
            touch2ShouldReset = YES;
        }
    }

}
 */
- (BOOL)textFieldShouldBeginEditing:(UDTextField *)TextField{
    NSMutableArray * curUserData = (NSMutableArray*)TextField.userData;
    NSNumber * number = (NSNumber*)[curUserData objectAtIndex:0];
    globalParameterIndex = number.intValue;
    NSString * type =  (NSString*)[curUserData objectAtIndex:1];
    NSRange objectRange = [type rangeOfString:@"object"];
    if (objectRange.location!=NSNotFound) {
        curSelectionType = selectMultipleObjects; //up to the user to figure out if this is 1 or multiple objects. Later, if count>1, pass array as parameter. Otherwise, just pass the first object.
        //[[CCTouchDispatcher sharedDispatcher]setPriority:-10 forDelegate:self];
        self.view.frame = CGRectMake(-400, 0, 500, 320);//self.view.frame = CGRectMake(100, 0, 100, 320);
        

        return NO;
    }
    //[[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    curSelectionType = selectionTypeNone;
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
- (BOOL)textFieldShouldReturn:(UDTextField *)TextField{ 
    NSAssert(values!=nil,@"values array not yet initialized");
    NSMutableArray * curUserData = TextField.userData;
    NSAssert([curUserData count]>0,@"cur user data doesn't equal anything");
    NSString * input = TextField.text;
    NSString * type =  (NSString*)[curUserData objectAtIndex:1];
    
    NSRange cgPointRange = [type rangeOfString:@"CGPoint"];
    NSRange cgSizeRange = [type rangeOfString:@"CGSize"];
    NSRange floatRange = [type rangeOfString:@"float"];
    NSRange intRange = [type rangeOfString:@"Int"];
    NSRange booRange = [type rangeOfString:@"BOOL"];
   // NSRange objectRange = [type rangeOfString:@"object"];
    
    
    NSNumber * number = (NSNumber*)[curUserData objectAtIndex:0];
    int pointIndex = number.intValue;
    //CCLOG(@"pointIndex = %i",pointIndex);
    if (cgPointRange.location!=NSNotFound) {
        NSArray * seperated1 = [input componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        if ([seperated1 count]<=1) {
            return NO;
        }

        NSString * xString = [seperated1 objectAtIndex:0];
        NSString * yString = [seperated1 objectAtIndex:1];
        float xVal = [xString floatValue];
        float yVal = [yString floatValue];
        CGPoint point = ccp(xVal,yVal);
       // NSValue * pointValue = [NSValue valueWithCGPoint:point];
        CCLOG(@"x = %f y = %f",xVal,yVal);
        NSData * data = [NSData dataWithBytes:&point length:sizeof(point)];
        [values replaceObjectAtIndex:pointIndex withObject:data];
        
    }
    if (cgSizeRange.location!=NSNotFound) {
        NSArray * seperated1 = [input componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        if ([seperated1 count]<=1) {
            return NO;
        }
        NSString * xString = [seperated1 objectAtIndex:0];
        NSString * yString = [seperated1 objectAtIndex:1];
        float widthV = [xString floatValue];
        float heightV = [yString floatValue];
        CGSize size = CGSizeMake(widthV, heightV);
        //NSValue * sizeValue = [NSValue valueWithCGSize:size];
        CCLOG(@"width = %f height = %f",widthV,heightV);
        NSData * data = [NSData dataWithBytes:&size length:sizeof(size)];
        [values replaceObjectAtIndex:pointIndex withObject:data];
    }
    if (floatRange.location!=NSNotFound) {
        float _inputValue = [input floatValue];
        CCLOG(@"float input = %f",_inputValue);
        //NSNumber * num = [NSNumber numberWithFloat:_inputValue];
       // NSAssert(num!=nil,@"num=nil");
        //addObject works fine
        NSData * data = [NSData dataWithBytes:&_inputValue length:sizeof(_inputValue)];
        [values replaceObjectAtIndex:pointIndex withObject:data];
    }
    if (intRange.location!=NSNotFound) {
        int inputValue = [input intValue];
        CCLOG(@"int value = %i",inputValue);
        NSData * data = [NSData dataWithBytes:&inputValue length:sizeof(inputValue)];
        [values replaceObjectAtIndex:pointIndex withObject:data];
    }
    if (booRange.location!=NSNotFound) {
        int inputValue = [input intValue];
        BOOL boolInput = (BOOL)inputValue;
        NSData * data = [NSData dataWithBytes:&boolInput length:sizeof(boolInput)];
        [values replaceObjectAtIndex:pointIndex withObject:data];
    }
    [TextField resignFirstResponder];
    return YES;
}// called when 'return' key pressed. return NO to ignore.
-(void)enterDeleteMode{
    curSelectionType = deleteObjects; 
    //[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].body->SetLinearVelocity(b2Vec2(0,0));
    self.view.frame = CGRectMake(-400, 0, 500, 320);

}
-(void)createObject{
    NSAssert(curClass!=nil,@"curClass equals nil");
    SEL selectorToPerform = method_getName(methods[longestMethodIndex]);
    CCLOG(@"selectorToPerform = %@",NSStringFromSelector(selectorToPerform));
    //id anInstance = [[curClass alloc]init];
    NSMethodSignature *sig = [curClass methodSignatureForSelector:selectorToPerform];
    NSAssert(sig!=nil,@"method signature = nil");
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:curClass];
    [invocation setSelector:selectorToPerform];
    
    int numberOfArguments = method_getNumberOfArguments(methods[longestMethodIndex]);
    //[invocation setArgument:[[HelloWorldLayer sharedHelloWorldLayer]getWorld] atIndex:2];
    b2World * world = [[HelloWorldLayer sharedHelloWorldLayer]getWorld];
    CCLOG(@"numberOfArguments = %i",numberOfArguments);
    for (int i = 0; i<numberOfArguments-2; i++) { //change -2 to -3
        if (i == 0) {
            [invocation setArgument:&world atIndex:i+2];
        }else{
            NSData * data = (NSData*)[values objectAtIndex:i];
            if (!(data!=nil)) {
                CCLOG(@"creation failed");
                return;
            }
            
            void * arg = (void*)[data bytes];
            CGPoint * pointVal = (CGPoint*)[data bytes];
            CCLOG(@"point.x = %f point.y = %f",pointVal->x,pointVal->y);
            //NSAssert(arg!=nil,@"current argument = nil");
            CCLOG(@"size of arg = %u",(unsigned int)sizeof(arg));
            [invocation setArgument:arg atIndex:i+2]; //try removing the &
        }

        
        //CGPoint pointArg = (CGPoint)(*arg);
       // CCLOG(@"point.x = %f point.y = %f",pointArg.x,pointArg.y);
       // if ([arg isKindOfClass:[NSValue class]]) {
        //    CGPoint point = [arg CGPointValue];
        //    CGSize size = [arg CGSizeValue];
        //}
         
    }
    
    [invocation invoke];
    BodyNode * retVal = nil;
    [invocation getReturnValue:&retVal];
    [[[HelloWorldLayer sharedHelloWorldLayer]getCurrentLevel]addChild:retVal];
    //[objectParameters removeAllObjects]; //this works fine. The problem is something do to with the new destructionListener system
    //[values removeAllObjects];
    //[anInstance release];
    
}
@end
