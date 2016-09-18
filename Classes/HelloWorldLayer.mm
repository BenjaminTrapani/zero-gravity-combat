//
//  HelloWorldLayer.mm
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 7/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Soldier.h"
#import "Level1.h"
#import "ParticleListener.h"
#import "EventBus.h"
#import "HUD.h"
#import "Bullets.h"
#import "DeletionManager.h"
#import "JetPack.h"
#import "GameOver.h"
#import "Options.h"
#import "LevelCompleted.h"
#import "LevelView.h"
#import "Zero_Gravity_CombatAppDelegate.h"
#import "ObjectView.h"
#import "PropertiesView.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize isFiringStickDead, levelBacking, gameStartPosition, surrenderCameraControl;
static HelloWorldLayer* helloWorldInstance;

+(HelloWorldLayer*) sharedHelloWorldLayer
{
	//NSAssert(helloWorldInstance != nil, @"hello world not yet initialized!");
	return helloWorldInstance;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	scene.tag = 123879;
	
	//HUD * myHud = [HUD hud];
	//myHud.tag = 43892;
    //hud = [HUD hud];
	//[scene addChild:myHud z:20];
		
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
	
	
		// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		isUsingEditor = [Options sharedOptions].isUsingEditor;
		//while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {}
		/*if ([Options sharedOptions].isUsingEditor==YES) {
            LevelView * view = [[LevelView alloc]init];
            UIWindow * window = ((Zero_Gravity_CombatAppDelegate*)[[UIApplication sharedApplication]delegate]).window;
            UIViewController * controller = window.rootViewController;
            [[controller view] addSubview:[view view]];
            
            ObjectView * ObjView = [[[ObjectView alloc]init]autorelease];
            [self addChild:ObjView z:104];
            //[[controller view] insertSubview:[view view] atIndex:0]; //2 didn't respond, 1 didn't respond, 0 not visible but responded
        }
         */
		//[gameController release];
        if ([Options sharedOptions].isIpad) {
            batch1 = [CCSpriteBatchNode batchNodeWithFile:@"ZGCTextureAtlashd.png"];
            batch2 = [CCSpriteBatchNode batchNodeWithFile:@"ZGCTextureAtlas2hd.png"];

        }else{
            batch1 = [CCSpriteBatchNode batchNodeWithFile:@"ZGCTextureAtlas.png"];
            batch2 = [CCSpriteBatchNode batchNodeWithFile:@"ZGCTextureAtlas2.png"];
        }
        [self addChild:batch1 z:100 tag:0];
        [self addChild:batch2 z:100 tag:1];
        
        hud = [HUD hud];
        //[[CCDirector sharedDirector].nextScene_ addChild:hud z:20];
        [self addChild:hud z:103];
        
       
        
        screenSize = [[CCDirector sharedDirector]winSize];
		gameController = [GameController gc];
		soundEngine = [CDAudioManager sharedManager].soundEngine;
		
		/*NSArray *defs = [NSArray arrayWithObjects:
						 [NSNumber numberWithInt:10], nil];
		[soundEngine defineSourceGroups:defs];
		*/
                //Optimization notes
				//using ccspritebatchnode doesn't call [child visit] in its visit function, which will make the overall time spent on [CCNode visit] a lot less. Try using it. CDSoundSource setPan and CDSoundSource setGain are also very slow. Find a way to reference both of these properties less times
		
				
		helloWorldInstance = self;
		// disable touches initially
		//[self setIsTouchEnabled:YES];
		
		// enable accelerometer
		//self.isAccelerometerEnabled = YES;
		
		self.isFiringStickDead = YES;
		
		//[[CCTouchDispatcher sharedDispatcher]addStandardDelegate:self priority:-12];
		
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, 0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		myContactListener = new ContactListener();
		world->SetContactListener(myContactListener);
		
		// Debug Draw functions
        if (isUsingEditor) {
            
        
            m_debugDraw = new GLESDebugDraw( PTM_RATIO );
            world->SetDebugDraw(m_debugDraw);
		
            uint32 flags = 0;
            flags += b2DebugDraw::e_shapeBit;
//          flags += b2DebugDraw::e_jointBit;
//          flags += b2DebugDraw::e_aabbBit;
//          flags += b2DebugDraw::e_pairBit;
//          flags += b2DebugDraw::e_centerOfMassBit;
            m_debugDraw->SetFlags(flags);		
		}
		listener = [[ParticleListener alloc]init];
		CCLOG(@"in hello world init, options.current level =%i",[Options sharedOptions].currentLevel);
		Level1 * l1 = [Level1 levelWithWorld:world identifier:[Options sharedOptions].currentLevel];//[Options sharedOptions].currentLevel]; 
		
        /*CCArray *l1C = [l1 children];
        for (CCNode * child in l1C) {
            NSAssert(child!=nil,@"child of level is nil");
        }*/
        
		[self addChild:l1];
		[self addChild:listener z:101];
		
        
        if ([Options sharedOptions].isUsingEditor==YES) {
            levelView = [[LevelView alloc]init];
            UIWindow * window = ((Zero_Gravity_CombatAppDelegate*)[[UIApplication sharedApplication]delegate]).window;
            UIViewController * controller = window.rootViewController;
            [controller.view addSubview:levelView.view];
            
            propertiesView = [[PropertiesView alloc]init];
            
            [controller.view addSubview:propertiesView.view];
            
            ObjectView * ObjView = [[[ObjectView alloc]init]autorelease];
            ObjView.position = [Helper relativePointFromPoint:ccp(0,-150)];
            [hud addChild:ObjView];
            
        }

        
         //test this, see if it fixes assertion caused by absence of soldier. After doing this, enable bullet pool.
		// Define the ground body.
		/*b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		//groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		//groundBody->CreateFixture(&groundBox,0);
		
		// right
		//groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		//groundBody->CreateFixture(&groundBox,0);
		*/
		
		
		
		
			
		
		/*
		audioNode = [CDXAudioNode audioNodeWithFile:@"singleShot.wav" soundEngine:soundEngine sourceId:0];
        audioNode.earNode = mySoldier.sprite;
		//audioNode.position = ccp(200,200);
		[mySoldier.primaryWeapon.sprite addChild:audioNode];
		 */
        //[mySoldier.sprite addChild:audioNode];
       
		
		//[[EventBus sharedEventBus]doSoldierCreated];
		
		

		
				
		//Set up sprite
		//b2Vec2 newgravity = [Helper toMeters:CGPointZero];
		//world->SetGravity(newgravity);		
										 
		//[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		/*
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		*/
		
		hasParticleReset = NO; 
		gameOver = NO;
		previousPos = gameStartPosition;
		
        
		firstLoop = YES;
        locked = NO;
		//gameController.position = ccp(screenSize.width/2,screenSize.height/2);
		[self addChild:gameController z:101];
		
		//[self addJoystick];
		[self schedule: @selector(tick:)];
        [self schedule:@selector(firstLoop:)];
        
		//[self schedule:@selector(cleanupDeletes) interval:0.1f];
		
	}
	return self;
}
-(void)firstLoop:(ccTime)delta{
    [self unschedule:@selector(firstLoop:)];
    if (firstLoop==YES) {
        [[self getHUD]onSoldierCreated];
        firstLoop = NO;
        
    }

}


 
/*-(void)addJoystick
{
	float stickRAdius = 50;
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	joystick = [SneakyJoystick joystickWithRect:CGRectMake(0, 0, stickRAdius, stickRAdius)];
	
	joystick.autoCenter = YES;
	joystick.hasDeadzone = YES;
	joystick.deadRadius = 10;
	
	skinStick = [SneakyJoystickSkinnedBase skinnedBase];;
	skinStick.backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"joystickBack.png"];
	skinStick.thumbSprite = [CCSprite spriteWithSpriteFrameName:@"joystickFront.png"];
	skinStick.thumbSprite.scale = 0.5f;
	skinStick.joystick = joystick;
	skinStick.position = ccp(stickRAdius*1.5f,stickRAdius*1.5f);
	[self addChild:skinStick];
}
 */

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    if (isUsingEditor){
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
}

-(void)doLeft{
	//CCLOG(@"doing left");
	[[EventBus sharedEventBus]doPlayerMoved:CGPointMake(-1, 0) jdegrees:0 direction:@"left"];
	//listener.propulsionFlames.angle = 0;
}
-(void)doRight{
	//CCLOG(@"doing right");
	[[EventBus sharedEventBus]doPlayerMoved:CGPointMake(1, 0) jdegrees:0 direction:@"right"];
	//iopoiuiolistener.propulsionFlames.angle = 180;
}

-(CGPoint)makePointRelative:(CGPoint)point{
    point.x+=gameController.position.x;
    point.y+=gameController.position.y;
    return point;
}
/*-(void)stepWorldAsync:(NSNumber*)input{
    if(locked)return;
    float dt = input.floatValue;
    locked = YES;
    int32 velocityIterations = 8;//8; //doesn't really effect the speed of the program. Setting this to 1 gave an extra 2-4 fps but royally screwed up physics.
	int32 positionIterations = 1;//1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    locked = NO;
}
 */
-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;//8; //doesn't really effect the speed of the program. Setting this to 1 gave an extra 2-4 fps but royally screwed up physics.
	int32 positionIterations = 1;//1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
    //[self performSelectorInBackground:@selector(stepWorldAsync:) withObject:[NSNumber numberWithFloat:dt]];
		//other random stuff not related to box2d
	
	CGPoint soldierPos = [Helper toPixels:mySoldier.body->GetWorldCenter()];
	
	levelBacking.position = ccp(previousPos.x-((previousPos.x-gameStartPosition.x)/10),previousPos.y-((previousPos.y-gameStartPosition.y)/10));
	
	CCCamera * myCam = [self camera];
	//CGPoint m1 = ccpMidpoint(soldierPos, previousPos);
	//CGPoint newLocation = ccpMidpoint(m1, previousPos);
	CGPoint newLocation;
	camMomentumX = 0;
	camMomentumY = 0;

	do {
	float dampingX = abs(previousPos.x - soldierPos.x)/15.0f; //the higher the last value (15.0f), the slower the camera is to respond
	float dampingY = abs(previousPos.y - soldierPos.y)/15.0f;
		//if (ccpDistance(previousPos, soldierPos)>screenSize.width/50) {
		
		if (previousPos.x<soldierPos.x) {
			camMomentumX += dampingX;
		}
		if (previousPos.x>soldierPos.x) {
			camMomentumX -= dampingX;
		}
		
		if (previousPos.y<soldierPos.y) {
			camMomentumY += dampingY;
		}
		if (previousPos.y>soldierPos.y) {
			camMomentumY -= dampingY;
		}
	/*}else {
		if (camMomentumX>0) {
			camMomentumX -= dampingX;
		}
		if (camMomentumX<0) {
			camMomentumX += dampingX;
		}
		if (camMomentumY>0) {
			camMomentumY -= dampingY;
		}
		if (camMomentumY<0) {
			camMomentumY += dampingY;
		}
		
	}
	 */
	/*if (camMomentumX>0) {
		camMomentumX -= dampingX/2;
	}
	if (camMomentumX<0) {
		camMomentumX += dampingX/2;
	}
	if (camMomentumY>0) {
		camMomentumY -= dampingY/2;
	}
	if (camMomentumY<0) {
		camMomentumY += dampingY/2;
	}
	*/
	
	//CCLOG(@"currentPos.x = %f currentPos.y = %f",currentPos.x,currentPos.y);
	newLocation = ccp(previousPos.x+camMomentumX,previousPos.y+camMomentumY);
	//CCLOG(@"newLocation.x = %f newLocation.y = %f",newLocation.x,newLocation.y);
	} while (abs(newLocation.x-soldierPos.x)>screenSize.width/2 || abs(newLocation.y-soldierPos.y)>screenSize.height/2);
	
	previousPos = newLocation;
    /*#if usingEditor == 1
    if (!surrenderCameraControl) {
        [myCam setEyeX:newLocation.x - screenSize.width/2 eyeY:newLocation.y -screenSize.height/2 eyeZ:1.0];
        [myCam setCenterX:newLocation.x - screenSize.width/2 centerY:newLocation.y -screenSize.height/2 centerZ:0.0];
        gameController.position = ccp(newLocation.x-screenSize.width/2,newLocation.y-screenSize.height/2);
        hud.position = gameController.position;

    }
    #else
     */
    [myCam setEyeX:newLocation.x - screenSize.width/2 eyeY:newLocation.y -screenSize.height/2 eyeZ:1.0];
    [myCam setCenterX:newLocation.x - screenSize.width/2 centerY:newLocation.y -screenSize.height/2 centerZ:0.0];
    gameController.position = ccp(newLocation.x-screenSize.width/2,newLocation.y-screenSize.height/2);
    hud.position = gameController.position;

   // #endif
    
	
		//self.rotation = 360 - mySoldier.sprite.rotation;
	//relativeAngle = self.rotation;
	
	//NSAssert(myHud!=nil, @"hud = nil");
	//myHud.joystick.rotation = self.rotation;
	//myHud.firingStick.rotation = self.rotation;
	CGPoint velocity = hud.joystick.velocity;
	CGPoint shotVelocity = hud.firingStick.velocity;
	float joystickDegrees = hud.joystick.degrees;
	//this is movement and jet pack stuff
	//listener.propulsionFlames.position = soldierPos;
	if (velocity.x!=0 || velocity.y!=0) {
		[[EventBus sharedEventBus]doPlayerMoved:velocity jdegrees:joystickDegrees];
	}
	//this is shooting stuff
	float shotDegrees = hud.firingStick.degrees;
	//CCLOG(@"joystickDeg = %f",shotDegrees);
	if (shotVelocity.x!=0 && shotVelocity.y!=0) {
		self.isFiringStickDead = NO;
		
		//[[EventBus sharedEventBus]doWeaponFired:shotVelocity bulletDegrees:shotDegrees];
        [mySoldier onWeaponFired:shotVelocity bulletDegrees:shotDegrees];
	}else {
		self.isFiringStickDead = YES;
		
		if (shotDegrees!=0) {
			[mySoldier rotateGunToAngle:shotDegrees shaking:NO];
		}
	}
		
	
	
	//[[DeletionManager sharedDeletionManager]deleteObjects];
	//[[DeletionManager sharedDeletionManager]resetObjects];
	//end random other stuff
	
	//Iterate over the bodies in the physics world
   // if(locked)return;
    
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
        if (body->IsActive() == false) {
            //CCLOG(@"continued because a body was inactive");
            continue;
        }
		BodyNode* bodyNode = (BodyNode*)body->GetUserData();
        
        if (bodyNode->shouldDelete) {
            [[bodyNode parent] removeChild:bodyNode cleanup:YES];
            continue;
            //bodyNode = nil;
            //[bodyNode release];
            //[bodyNode dealloc];
        }
                
		if (bodyNode != NULL && bodyNode.sprite != nil)
		{
			// update the sprite's position to where their physics bodies are
            CGPoint bnSpritePos = [Helper toPixels:body->GetWorldCenter()];
            //CGPoint backingPos = levelBacking.position;
            //b2AABB aabb = body->GetFixtureList()->GetAABB();
            //b2Vec2 extents = aabb.GetExtents();
           // CGRect bodyRect = bodyNode.sprite.boundingBox;
           // CGRect screenRect = CGRectMake(-screenSize.width + previousPos.x, -screenSize.height + previousPos.y, screenSize.width + previousPos.x, screenSize.height + previousPos.y);
            
            /*CGSize spriteSize = bodyNode.sprite.contentSize;
            float longestEdge;
            if (spriteSize.width>spriteSize.height) {
                longestEdge = spriteSize.width * bodyNode.sprite.scaleX;
            }else{
                longestEdge = spriteSize.height * bodyNode.sprite.scaleY;
            }
			if (bnSpritePos.x-longestEdge>screenSize.width+previousPos.x || bnSpritePos.x+longestEdge<-screenSize.width+previousPos.x || bnSpritePos.y-longestEdge>previousPos.y+screenSize.height || bnSpritePos.y+longestEdge<previousPos.y-screenSize.height) {
                 bodyNode.sprite.visible = NO;
            }else{
                bodyNode.sprite.visible = YES;
            } 

            //}
			*/
            bodyNode.sprite.position = bnSpritePos; 
            float angle = body->GetAngle();
            bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));

                               
			if (bodyNode.userData == kBodyTypeWeapon) {
				if (bodyNode.body->GetFixtureList()->GetFilterData().groupIndex!=-8) {
				
					float distanceFromSoldier = ccpDistance([Helper toPixels:mySoldier.body->GetWorldCenter()], bodyNode.sprite.position);
					if (distanceFromSoldier<screenSize.width/7) {
						if (((Weapon*)bodyNode).hasCarrier == NO) {
							[hud gunCloseForPickup:(Weapon*)bodyNode];
                           // CCLOG(@"gun close for pickup");
						}
						
					}
				}
			}
			if (bodyNode->shouldRemoveJoints) {
				b2JointEdge* je = bodyNode.body->GetJointList();
				
				while (je)
				{
					b2JointEdge* je0 = je;
					je = je->next;
					
					world->DestroyJoint(je0->joint);
				}
				
			}
            if (bodyNode->shouldReset) {
                bodyNode.sprite.visible = NO;
                bodyNode.body->SetActive(false);
                bodyNode.shouldReset = NO;
            }
			
			
		}
		 
	}
}
//DEBUG COCOS2D_DEBUG=1 CD_DEBUG=1;

-(PropertiesView*)getPropertiesView{
    return propertiesView;
}
-(LevelView*)getLevelView{
    return levelView;
}
-(void)cleanupDeletes{
	[[DeletionManager sharedDeletionManager]deleteObjects];
}
-(float)getRelativeAngle{
	return relativeAngle;
}
-(void)doGameOver{
	if (gameOver) {
		return;
	}
	gameOver = YES;
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOver scene] withColor:ccc3(0, 0, 0)]];
	
}
-(b2World*)getWorld{
	NSAssert(world!=NULL, @"world doesn't equal anything in HelloWorldLayer getWorld");
	return world;
}
-(NSMutableArray*) getSpriteBatches{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:2];
    [array addObject:batch1];
    [array addObject:batch2];
    return array;
}

-(Soldier*) getLocalSoldier{
	return mySoldier;
}
-(void)setSoldier:(Soldier*)newSoldier{
    mySoldier = newSoldier;
}
-(ParticleListener*)getParticleListener{
	return listener;
}
-(HUD*)getHUD{
	NSAssert(hud!=nil,@"hud doesn't equal anything. Don't ask for it");
	return hud;
}
-(CDSoundEngine*)getSoundEngine{
	return soundEngine;
}

-(GameController*)getGameController{
	return gameController;
}

-(Level1*)getCurrentLevel{
    return currentLevel;
}
-(void)setCurrentLevel:(Level1*)input{
    currentLevel = input;
}

//-(void)setGameController:(GameController*)gc{
//	gameController = gc;
//}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		//[self addNewSpriteWithCoords: location];
	}
}

/*- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}
*/
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	[[CCTouchDispatcher sharedDispatcher]removeDelegate:hud];
	//[skinStick release];
	delete m_debugDraw;
	helloWorldInstance = nil;
	[listener release];
	//[gameController release];
	
	//[mySoldier release];
	
	//[bullets release];
	//CCLOG(@"helloworlddealloc");
    //UIWindow * window = ((Zero_Gravity_CombatAppDelegate*)[[UIApplication sharedApplication]delegate]).window;
    //UIViewController * controller = window.rootViewController;
    //[controller.view willRemoveSubview:propertiesView.view];
    //[controller.view willRemoveSubview:levelView.view];
     
    [propertiesView.view removeFromSuperview];
    [levelView.view removeFromSuperview];
	[propertiesView release];
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:propertiesView];
    
    //CCLOG(@"pview retain count = %i",[propertiesView retainCount]);
    [levelView release];
    //[levelView release];
    //CCLOG(@"lview retain count = %i",[levelView retainCount]);
	[[Options sharedOptions]clearSoundArray];
	//[[EventBus sharedEventBus]removeSubscriber:[self getHUD] fromEvent:@"soldierCreated"];
	[super dealloc];
    [[EventBus sharedEventBus]clearEvents];
	//[[GameController sharedGameController]removeAllChildrenWithCleanup:YES];
	delete myContactListener;
	//[[DeletionManager sharedDeletionManager]clearDeletes];
	
	//[mySoldier dealloc];
	
	
	
	
	 //changed delete position to avoid bad access on exit
	
	delete world;
	world = NULL;
	
	// don't forget to call "super dealloc"
	
}
@end
