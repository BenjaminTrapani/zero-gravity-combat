//
//  Level1.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Level1.h"
#import "StandardBlock.h"
#import "standardWall.h"
#import "GreenBlob.h"
#import "Options.h"
#import "SandBag.h"
#import "ExplosiveBarrel.h"
#import "Entrance.h"
#import "Glass.h"
#import "CircleJoint.h"
#import "CCTouchDispatcher.h"
#import "Soldier.h"
#import "Robot.h"
#import "GameController.h"
#import "ElectricArc.h"
#import "Soldier.h"
#import "IronBar.h"
#import "ExplosiveBox.h"
#import "Exit.h"
#import "Forcefield.h"
#import "GeneratorSwitch.h"
#import "RocketRobot.h"
#import "ObjectFactory.h"
#import "PropertiesView.h"

@implementation Level1

/*
 level plans

 level1:
 this is a space station, contains stuff that you would find in one, especially robots, aliens, and even other people;
 
 Level2:
 Surface of destination planet. These are tunnels. Copper brown collored boundaries, some more sci fi boxes, switches, and doors. More aliens and other et creatures.
 */


-(void) createPlayerInWorld:(b2World*)world Pos:(CGPoint)startPos{
    startPos = [Helper relativePointFromPoint:startPos];
    [HelloWorldLayer sharedHelloWorldLayer].gameStartPosition = ccp(startPos.x,startPos.y+[[Options sharedOptions]makeYConstantRelative:25]);
    Soldier * mySoldier = [Soldier soldierWithWorld:world];
    mySoldier.maxSpeed = 2.0f;
    mySoldier.accelerationSpeed = 2.5f;
    [self addChild:mySoldier z:1];
    [[HelloWorldLayer sharedHelloWorldLayer]setSoldier:mySoldier];
    [mySoldier.primaryWeapon onSoldierCreatedAsParent];
    [mySoldier.secondaryWeapon onSoldierCreatedAsParent];
    [mySoldier.jetPack createSound];
}
-(id) initWithWorld:(b2World*)world identifier:(int)idtt
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        [[HelloWorldLayer sharedHelloWorldLayer]setCurrentLevel:self];
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        
        
        //b2Body::setCurBodyID(0);
		//CCSpriteBatchNode* batch = [[HelloWorldLayer sharedHelloWorldLayer]getSpriteBatch];//[CCSpriteBatchNode batchNodeWithFile:@"ZGCTextureAtlas.png"];
		
        //Options * o = [Options sharedOptions];
		//[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:1 swallowsTouches:YES];
		
		if (idtt == 1) {
            //setup star requirements
            //NSNumber * oneStar = [NSNumber numberWithInt:10];
            NSNumber * twoStar = [NSNumber numberWithInt:45];
            NSNumber * threeStar = [NSNumber numberWithInt:55];
            NSMutableArray * starArray = [Options sharedOptions].rangesForCurrentLevel;
            [starArray removeAllObjects];
            [starArray addObject:twoStar];
            [starArray addObject:threeStar];
           // [starArray addObject:[NSValue valueWithRange:threeStar]];
            
			GameController * gc = [[HelloWorldLayer sharedHelloWorldLayer]getGameController];
			gc.timeLimit = 120;
            CCSprite * backGround = [CCSprite spriteWithSpriteFrameName:@"level 1.png"];//[CCSprite spriteWithSpriteFrameName:@"level 1.png"];
			//backGround.anchorPoint = ccp(0,0.5);
			backGround.position = ccp(screenSize.width/2,screenSize.height/2);
            //[backGround setBlendFunc:(ccBlendFunc) {GL_ONE,GL_ZERO}];
           // backGround.visible = NO;
			[[HelloWorldLayer sharedHelloWorldLayer]addChild:backGround];
			[HelloWorldLayer sharedHelloWorldLayer].levelBacking = backGround;
            
            CGPoint startPos = ccp(80,160);
            [self createPlayerInWorld:world Pos:startPos];
            
			
			Entrance * curEntrance = [Entrance entranceWithWorld:world position:startPos];
			[self addChild:curEntrance];						  
			
            Exit * exit = [Exit exitWithWorld:world Position:ccp(1650,240)];
            [self addChild:exit];
			
            
			//b2BodyDef groundBodyDef;
			//groundBodyDef.position.Set(0, 0); 
			//world->CreateBody(&groundBodyDef);
			
			//GreenBlob * blob1 = [GreenBlob blobWithPos:ccp(200,200) World:world Identifier:-1];
			//[self addChild:blob1];
			//GreenBlob * blob2 = [GreenBlob blobWithPos:ccp(400,200) World:world Identifier:-2];
			//[self addChild:blob2];
			
			//StandardBlock * block1 = [StandardBlock blockWithWorld:world position:ccp(200,300) Dimensions:CGSizeMake(10, 10) Rotation:0];
			//[self addChild:block1];
			//[self createObject:block1 InRows:5 columns:5];
			
			standardWall * wallLeft = [standardWall wallWithWorld:world position:ccp(0,480) Dimensions:CGSizeMake(25, 25)];
			[self createObject:wallLeft InRows:10 columns:1];
			
			standardWall * wallRight = [standardWall wallWithWorld:world position:ccp(1800,480) Dimensions:CGSizeMake(25, 25)];
			[self createObject:wallRight InRows:10 columns:1];
			
			standardWall * wallTop = [standardWall wallWithWorld:world position:ccp(0,480) Dimensions:CGSizeMake(35, 25)];
			[self createObject:wallTop InRows:1 columns:26];
			standardWall * wallBottom = [standardWall wallWithWorld:world position:ccp(0,0) Dimensions:CGSizeMake(35, 25)];
			[self createObject:wallBottom InRows:1 columns:26];
			
			//StandardBlock * block1 = [StandardBlock blockWithWorld:world position:ccp(480,160) Dimensions:CGSizeMake(10, 60) Rotation:50];
			//[self addChild:block1];
			
			
			StandardBlock * block1 = [StandardBlock blockWithWorld:world position:ccp(200,70) Dimensions:CGSizeMake(100, 10) Rotation:0];
			[self addChild:block1];
			StandardBlock * block2 = [StandardBlock blockWithWorld:world position:ccp(420,180) Dimensions:CGSizeMake(150, 10) Rotation:45];
			[self addChild:block2];
			CircleJoint * j1 = [CircleJoint jointWithWorld:world Position:ccp(305,70) Radius:7 levelObject1:block1 levelObject2:block2];
			[self addChild:j1];
			StandardBlock * block3 = [StandardBlock blockWithWorld:world position:ccp(660,290) Dimensions:CGSizeMake(100, 15) Rotation:0];
			[self addChild:block3];
			CircleJoint * j2 = [CircleJoint jointWithWorld:world Position:ccp(545,290) Radius:15 levelObject1:block2 levelObject2:block3];
			[self addChild:j2];
			StandardBlock * block4 = [StandardBlock blockWithWorld:world position:ccp(855,205) Dimensions:CGSizeMake(100, 10) Rotation:315];
			[self addChild:block4];
			CircleJoint * j3 = [CircleJoint jointWithWorld:world Position:ccp(775,285) Radius:15 levelObject1:block3 levelObject2:block4];
			[self addChild:j3];
			//[self createObject:glass1 InRows:1 columns:10 xPadding:10 yPadding:0];
			StandardBlock * block5 = [StandardBlock blockWithWorld:world position:ccp(1200,125) Dimensions:CGSizeMake(250, 20) Rotation:0];
			[self addChild:block5];
			CircleJoint * j4 = [CircleJoint jointWithWorld:world Position:ccp(933,125) Radius:15 levelObject1:block4 levelObject2:block5];
			[self addChild:j4];
			
            //IronBar * bar = [IronBar ironBarWithWorld:world Position:ccp(100,100) Length:50 Width:5 Rotation:30];
            //[self addChild:bar];
            
            ExplosiveBox * expBox = [ExplosiveBox explosiveBoxWithWorld:world position:ccp(1450,125) rotation:0];
            [self createObject:expBox InRows:1 columns:9 xPadding:0 yPadding:0];
            [self addChild:expBox];
            
			ElectricArc * arc1 = [ElectricArc electricArcWithWorld:world Position1:ccp(550,230) Position2:ccp(550,75) Radius:10];
			[self addChild:arc1];
			
			StandardBlock * enemyPlatform = [StandardBlock blockWithWorld:world position:ccp(1000,270) Dimensions:CGSizeMake(100, 5) Rotation:0];
			[self addChild:enemyPlatform];
			SandBag * enemyPlatformBags = [SandBag sandbagWithWorld:world position:ccp(950,300) rows:2 columns:3 sizeVariance:1 body:enemyPlatform point:ccp(1150,270)];
			[self addChild:enemyPlatformBags];
			
			SandBag * centerSandBag = [SandBag sandbagWithWorld:world position:ccp(660,340) rows:2 columns:4 sizeVariance:1 body:block3 point:ccp(660,290)];
			[self addChild:centerSandBag];
			ExplosiveBarrel * explosive1 = [ExplosiveBarrel explosiveBarrelWithWorld:world position:ccp(60,440) rotation:0];
			[self addChild:explosive1];
			[self createObject:explosive1 InRows:1 columns:4 xPadding:100 yPadding:0];
			
			Robot * robot1 = [Robot robotWithWorld:world Position:ccp(1000,300) identifier:-1];
			[self addChild:robot1];
			
			Robot * robot2 = [Robot robotWithWorld:world Position:ccp(900,300) identifier:-2];
			[self addChild:robot2];
            
            Robot * robot3 = [Robot robotWithWorld:world Position:ccp(400,200) identifier:-3];
            [self addChild:robot3];
			//GreenBlob * blob1 = [GreenBlob blobWithPos:ccp(550,160) World:world Identifier:-1];
			//[self addChild:blob1];
			
			//GreenBlob * blob2 = [GreenBlob blobWithPos:ccp(620,160) World:world Identifier:-2];
			//[self addChild:blob2];
			// Define the ground box shape.
			/*b2PolygonShape groundBox;		
			 //bottom
			 groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2([backGround texture].contentSize.width/PTM_RATIO,0));
			 groundBody->CreateFixture(&groundBox,0); 
			 
			 // top
			 groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(backGround.contentSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
			 groundBody->CreateFixture(&groundBox,0);
			 
			 // left
			 groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
			 groundBody->CreateFixture(&groundBox,0);
			 
			 // right
			 groundBox.SetAsEdge(b2Vec2([backGround texture].contentSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2([backGround texture].contentSize.width/PTM_RATIO,0));
			 groundBody->CreateFixture(&groundBox,0);
			 */
			//small block for training purposes
		}
        if (idtt == 2) {
            
            NSNumber * twoStar = [NSNumber numberWithInt:55];
            NSNumber * threeStar = [NSNumber numberWithInt:65];
            NSMutableArray * starArray = [Options sharedOptions].rangesForCurrentLevel;
            [starArray removeAllObjects];
            [starArray addObject:twoStar];
            [starArray addObject:threeStar];
            
            GameController * gc = [[HelloWorldLayer sharedHelloWorldLayer]getGameController];
			gc.timeLimit = 120;
            CCSprite * backGround = [CCSprite spriteWithSpriteFrameName:@"level 1.png"];//[CCSprite spriteWithSpriteFrameName:@"level 1.png"];
            //[backGround setBlendFunc:(ccBlendFunc) {GL_ONE,GL_ZERO}];
			//backGround.anchorPoint = ccp(0,0.5);
			backGround.position = ccp(screenSize.width/2,screenSize.height/2);
            // backGround.visible = NO;
			[[HelloWorldLayer sharedHelloWorldLayer]addChild:backGround];
			[HelloWorldLayer sharedHelloWorldLayer].levelBacking = backGround;
            
            CGPoint startPos = ccp(150,160);
            [self createPlayerInWorld:world Pos:startPos];
            
                        
            standardWall * left = [standardWall wallWithWorld:world position:ccp(0,0) Dimensions:CGSizeMake(10, 500)];
            [self addChild:left];
            
            standardWall * bottom = [standardWall wallWithWorld:world position:ccp(500,-500) Dimensions:CGSizeMake(500, 10)];
            [self addChild:bottom];
            
            standardWall * top = [standardWall wallWithWorld:world position:ccp(500,400) Dimensions:CGSizeMake(500, 10)];
            [self addChild:top];
            
            standardWall * right = [standardWall wallWithWorld:world position:ccp(1000,0) Dimensions:CGSizeMake(10, 500)];
            [self addChild:right];
            
            Entrance * entrance = [Entrance entranceWithWorld:world position:ccp(150,160)];
            [self addChild:entrance];
            IronBar * bar = [IronBar ironBarWithWorld:world Position:ccp(550,210) Length:100 Width:5 Rotation:0];
            [self addChild:bar];
            SandBag * bags = [SandBag sandbagWithWorld:world position:ccp(500,240) rows:2 columns:3 sizeVariance:1 body:bar point:[Helper toPixels:bar.body->GetWorldCenter()]];
            [self addChild:bags];
            
            Robot * robot1 = [Robot robotWithWorld:world Position:ccp(540,270) identifier:-1];
            [self addChild:robot1];
            Robot * robot2 = [Robot robotWithWorld:world Position:ccp(560,270) identifier:-2]; 
            [self addChild:robot2];
            IronBar * bar2 = [IronBar ironBarWithWorld:world Position:ccp(700,150) Length:270 Width:5 Rotation:240];
            [self addChild:bar2];
            
            StandardBlock * block1 = [StandardBlock blockWithWorld:world position:ccp(230,20) Dimensions:CGSizeMake(150, 10) Rotation:-45];
            [self addChild:block1];
            StandardBlock * block2 = [StandardBlock blockWithWorld:world position:ccp(340,-290) Dimensions:CGSizeMake(10, 200) Rotation:0];
            [self addChild:block2];
            CircleJoint * joint1 = [CircleJoint jointWithWorld:world Position:ccp(340,-90) Radius:10 levelObject1:block1 levelObject2:block2];
            [self addChild:joint1];
            
            Forcefield * forcefield1 = [Forcefield forcefieldWithWorld:world Position:ccp(440,-120) Rotation:0 Length:80];
            [self addChild:forcefield1];
            Forcefield * forcefield = [Forcefield forcefieldWithWorld:world Position:ccp(560,-290) Rotation:90 Length:210];
            [self addChild:forcefield];

            ExplosiveBox * boxRightOfForcefield = [ExplosiveBox explosiveBoxWithWorld:world position:ccp(450,-120) rotation:0 Dimensions:CGSizeMake(20, 10)];
            [self addChild:boxRightOfForcefield];
            NSMutableArray * switch2Array = [NSMutableArray arrayWithCapacity:2];
            [switch2Array addObject:forcefield1];
            [switch2Array addObject:boxRightOfForcefield];
            GeneratorSwitch * switch2 = [GeneratorSwitch generatorSwitchWithWorld:world position:ccp(500,270) Rotation:0 Dimensions:CGSizeMake(40, 10) Objects:switch2Array Event:switchEventDestroy];
            [self addChild:switch2];
            //ExplosiveBox * box1 = [ExplosiveBox explosiveBoxWithWorld:world position:ccp(380,-420) rotation:0 Dimensions:CGSizeMake(10, 10)];
            //[self createObject:box1 InRows:1 columns:5 xPadding:3 yPadding:0];
            //[self addChild:box1];
            
                        NSMutableArray * switch1Objects = [NSMutableArray arrayWithCapacity:1];
            [switch1Objects addObject:forcefield];
            GeneratorSwitch * switch1 = [GeneratorSwitch generatorSwitchWithWorld:world position:ccp(500,-400) Rotation:0 Dimensions:CGSizeMake(20, 10) Objects:switch1Objects Event:switchEventDestroy];
            [self addChild:switch1];
            
            IronBar * otherSideBar1 = [IronBar ironBarWithWorld:world Position:ccp(680,-340) Length:60 Width:5 Rotation:0];
            [self addChild:otherSideBar1];
            IronBar * otherSideBar2 = [IronBar ironBarWithWorld:world Position:ccp(750,-140) Length:40 Width:5 Rotation:0];
            [self addChild:otherSideBar2];
            ExplosiveBarrel * barrel1 = [ExplosiveBarrel explosiveBarrelWithWorld:world position:ccp(730,-300) rotation:30];
            [self addChild:barrel1];
            ExplosiveBarrel * barrel2 = [ExplosiveBarrel explosiveBarrelWithWorld:world position:ccp(710,100) rotation:-50];
            [self addChild:barrel2];
            ExplosiveBox * box1 = [ExplosiveBox explosiveBoxWithWorld:world position:ccp(690,-150) rotation:0];
            ExplosiveBox * box2 = [ExplosiveBox explosiveBoxWithWorld:world position:ccp(880,-200) rotation:160];
           // [self createObject:box2 InRows:2 columns:10 xPadding:3 yPadding:5];
            [self addChild:box1];
            [self addChild:box2];
            IronBar * enemyPlatformOtherSide = [IronBar ironBarWithWorld:world Position:ccp(700,-40) Length:100 Width:5 Rotation:0];
            [self addChild:enemyPlatformOtherSide];
            SandBag * sandBagLeft = [SandBag sandbagWithWorld:world position:ccp(610,-50) rows:2 columns:3 sizeVariance:1 body:enemyPlatformOtherSide point:[Helper toPixels:enemyPlatformOtherSide.body->GetWorldCenter()]];
            [self addChild:sandBagLeft];    
            SandBag * sandBagRight = [SandBag sandbagWithWorld:world position:ccp(780,-50) rows:2 columns:3 sizeVariance:1 body:enemyPlatformOtherSide point:[Helper toPixels:enemyPlatformOtherSide.body->GetWorldCenter()]];
            [self addChild:sandBagRight];  
            
            Robot * robotUpsideDown = [Robot robotWithWorld:world Position:ccp(700,-80) identifier:-3];
            robotUpsideDown.body->SetTransform(robotUpsideDown.body->GetWorldCenter(), CC_DEGREES_TO_RADIANS(180));
            Robot * robotRightsideUp = [Robot robotWithWorld:world Position:ccp(700,0) identifier:-4];
           // robotUpsideDown.hearingRange = 1;
            //robotRightsideUp.hearingRange = 1;
            [self addChild:robotUpsideDown];
            [self addChild:robotRightsideUp];
            
            IronBar * leftCrocked = [IronBar ironBarWithWorld:world Position:ccp(800,160) Length:75 Width:5 Rotation:280];
            IronBar * rightCrocked = [IronBar ironBarWithWorld:world Position:ccp(950,160) Length:75 Width:5 Rotation:-280];
            [self addChild:leftCrocked];
            [self addChild:rightCrocked];
            
            Exit * exit = [Exit exitWithWorld:world Position:ccp(875,200)];
            [self addChild:exit];
            
            /*CCArray * children = [self children];
            NSMutableArray * array = [NSMutableArray array];
            for (CCNode * member in children) {
                if (![member isKindOfClass:[Soldier class]]) {
                    [array addObject:member];
                }
            }
            //NSArray * reversedArray = [[array reverseObjectEnumerator]allObjects];
            NSMutableDictionary * saveDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
            [saveDictionary setValue:array forKey:@"level3"];
            [saveDictionary setValue:[Options sharedOptions].rangesForCurrentLevel forKey:@"StarValues"];
            NSAssert(saveDictionary!=nil,@"saveDictionary equals nil");
            [[Options sharedOptions]saveLevelSavesDictionary:saveDictionary forKey:@"level3"];    
             */
            
            //NSMutableDictionary * saveDictionary = [NSMutableDictionary dictionaryWithCapacity:100]; //this works, just saving and retrieving a number
            //[saveDictionary setValue:[NSString stringWithFormat:@"10"] forKey:@"ten"];
            //[[Options sharedOptions]saveLevelSavesDictionary:saveDictionary];
            
        }
        if (idtt>2) {
            //b2Body::setCurBodyID(14);
            //NSValue * startPosVal = [dictionary valueForKey:@"StartPos"];
            //CGPoint startPos = [startPosVal CGPointValue];
            CCSprite * backGround = [CCSprite spriteWithSpriteFrameName:@"level 1.png"];//[CCSprite spriteWithSpriteFrameName:@"level 1.png"];
            //[backGround setBlendFunc:(ccBlendFunc) {GL_ONE,GL_ZERO}];
			//backGround.anchorPoint = ccp(0,0.5);
			backGround.position = ccp(screenSize.width/2,screenSize.height/2);
            if ([[Options sharedOptions]isUsingEditor]==YES) {
                 backGround.visible = NO;
            }
            
			[[HelloWorldLayer sharedHelloWorldLayer]addChild:backGround];
			[HelloWorldLayer sharedHelloWorldLayer].levelBacking = backGround;

            [self createPlayerInWorld:world Pos:ccp(150,160)];
            
            Entrance * entrance = [Entrance entranceWithWorld:world position:ccp(150,160)];
            [self addChild:entrance];
            
            NSDictionary * dictionary = [[Options sharedOptions]getLevelSavesDictionaryForKey:[NSString stringWithFormat:@"level%i",[Options sharedOptions].currentLevel]]; 
            //NSAssert([dictionary count]>0,@"entire save is nill");
            GameController * gc = [[HelloWorldLayer sharedHelloWorldLayer]getGameController];
            NSNumber * savedTimeLimit = (NSNumber*)[dictionary objectForKey:@"TimeLimit"];
			//gc.timeLimit = savedTimeLimit.floatValue;
            gc.timeLimit = savedTimeLimit.floatValue;
            //change level backing every four levels. Don't have to save this.
           /* NSValue * startPosValue = [dictionary objectForKey:@"StartPos"];
            CGPoint startPos = [startPosValue CGPointValue];
             */
            
            
            NSMutableArray * array = [dictionary valueForKey:@"StarValues"]; //can check if NSArray is nil and handle that
            NSMutableArray * starArray = [Options sharedOptions].rangesForCurrentLevel;
            [starArray removeAllObjects];
            [starArray addObjectsFromArray:array]; //test this
            if ([starArray count]==0) {
                [starArray addObject:[NSNumber numberWithInt:0]];
                [starArray addObject:[NSNumber numberWithInt:0]]; 
            }
            //NSAssert(array!=nil,@"star array = nil");
            /*[[Options sharedOptions].rangesForCurrentLevel release];
            if (array==nil) {
                [Options sharedOptions].rangesForCurrentLevel = [NSMutableArray arrayWithCapacity:2];//test this
                CCLOG(@"star array was nil and was created");
            }else{
                [Options sharedOptions].rangesForCurrentLevel = [NSMutableArray arrayWithArray:array];
                CCLOG(@"star array existed and was loaded");
            }
            */
            //NSArray * children = [dictionary valueForKey:[NSString stringWithFormat:@"level%i",[Options sharedOptions].currentLevel]];
            //NSArray * children = [dictionary valueForKey:[NSString stringWithFormat:@"level%i",[Options sharedOptions].currentLevel]];
           // if(children==nil){
                //set up some default stuff for blank level.
           // }
           // NSAssert(children!=nil,@"loading children failed for current level"); 
            
            //CCLOG(@"1212212");
            //for (CCNode * child in children) {
             //   CCLOG(@"added child in save file to current level");
             //   [self addChild:child];
            //}
            //CCLOG(@"32323232");
            /*NSString * filePath = @"LevelSaves.txt";
            NSString * fileRoot = [[NSBundle mainBundle]pathForResource:filePath ofType:@"txt"];
            NSString * fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
            NSArray * allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            ObjectFactory * objFactory = ObjectFactory::sharedObjectFactory();
            for (NSString * curString in allLinedStrings) {
                NSArray * seperatedString = [curString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
                NSString * objectID = (NSString*)[seperatedString objectAtIndex:0];
                NSArray * properties = (NSArray*)[seperatedString objectAtIndex:1];
                objFactory->createObjectWithIDandProperties(objectID,properties,self);
                
            }
             */
                        
        }
		//GreenBlob * blob2 = [GreenBlob blobWithPos:ccp([o makeXConstantRelative:300],[o makeYConstantRelative:100]) World:world Identifier:0];
		//[self addChild:blob2];
	}
	return self;
}
-(BOOL)saveLevel{
    if ([[Options sharedOptions].rangesForCurrentLevel count] == 0) {
        CCLOG(@"can't save level because you haven't filled out the level info pane");
        return NO;
    }
    CCArray * children = [self children];
    NSMutableArray * array = [NSMutableArray array];
    for (CCNode * member in children) {
        if (![member isKindOfClass:[Soldier class]] && ![member isKindOfClass:[Entrance class]]) {
            [array addObject:member];
        }
    }
    //NSArray * reversedArray = [[array reverseObjectEnumerator]allObjects];
    NSMutableDictionary * saveDictionary = [NSMutableDictionary dictionaryWithCapacity:100];
    [saveDictionary setValue:array forKey:[NSString stringWithFormat:@"level%i",[Options sharedOptions].currentLevel]];
    [saveDictionary setValue:[Options sharedOptions].rangesForCurrentLevel forKey:@"StarValues"];
    [saveDictionary setValue:[NSNumber numberWithInt:[[HelloWorldLayer sharedHelloWorldLayer]getGameController].timeLimit] forKey:@"TimeLimit"];
    //[saveDictionary setValue:[NSValue valueWithCGPoint:[Helper toPixels:[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].body->GetWorldCenter()]] forKey:@"StartPos"];
    //NSAssert(saveDictionary!=nil,@"saveDictionary equals nil");
    [[Options sharedOptions]saveLevelSavesDictionary:saveDictionary forKey:[NSString stringWithFormat:@"level%i",[Options sharedOptions].currentLevel]];
    if (saveDictionary!=nil) {
        return YES;
    }
    return NO;
}
-(void)createObject:(BaseLevelObject*)obj InRows:(int)rows columns:(int)columns{
	int totalObjects = rows*columns;
	int curRow = -1; 
	int curColumn = 0;
	CGPoint startPos = [Helper toPixels:obj.body->GetWorldCenter()];
	for (int c = 0; c<totalObjects; c++) {
		BaseLevelObject * newInstance = [obj copy];
		curRow++;
		if (curRow>=columns) {
			curColumn++;
			curRow = 0;
		}
		CGPoint addPos = ccp(startPos.x + (newInstance.dimensions.width*curRow*2), startPos.y - (newInstance.dimensions.height*curColumn*2));
		newInstance.body->SetTransform([Helper toMeters:addPos],newInstance.body->GetAngle());
		[self addChild:newInstance];
		
	}
}
-(void)createObject:(BaseLevelObject*)obj InRows:(int)rows columns:(int)columns xPadding:(float)xPad yPadding:(float)yPad{
	int totalObjects = rows*columns;
	int curRow = 0;
	int curColumn = 0;
	xPad = [[Options sharedOptions]makeXConstantRelative:xPad];
	yPad = [[Options sharedOptions]makeYConstantRelative:yPad];
	CGPoint startPos = [Helper toPixels:obj.body->GetWorldCenter()];
	for (int c = 0; c<totalObjects; c++) {
		BaseLevelObject * newInstance = [obj copy];
		curRow++;
		if (curRow>columns) {
			curColumn++;
			curRow = 0;
		}
		CGPoint addPos = ccp(startPos.x + ((newInstance.dimensions.width +xPad)*curRow*2), startPos.y - ((newInstance.dimensions.height + yPad)*curColumn*2));
		newInstance.body->SetTransform([Helper toMeters:addPos],newInstance.body->GetAngle());
		[self addChild:newInstance];
		
	}
	
}
+(id)levelWithWorld:(b2World*)world identifier:(int)idtt;{
	return [[[self alloc]initWithWorld:world identifier:idtt]autorelease];
}
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	
	[super dealloc];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{

	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	CGPoint soldierPos = [Helper toPixels:[[HelloWorldLayer sharedHelloWorldLayer]getLocalSoldier].body->GetWorldCenter()];
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	location.x+=(soldierPos.x - screenSize.width/2);
	location.y+=(soldierPos.y - screenSize.height/2);
	CCLOG(@"x = %f   Y = %f",location.x,location.y);
	return YES;
}


@end
