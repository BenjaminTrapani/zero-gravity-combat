//
//  ObjectFactory.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectFactory.h"

#import "StandardBlock.h" //done
#import "standardWall.h" //done
#import "GreenBlob.h"  //done
#import "SandBag.h"  //done
#import "ExplosiveBarrel.h" //done
#import "Entrance.h" //done
#import "Glass.h" //done
#import "CircleJoint.h" //done
#import "Robot.h" //done
#import "ElectricArc.h" //done
#import "IronBar.h" //done
#import "ExplosiveBox.h" //done
#import "Exit.h" //done
#import "Forcefield.h" //done
#import "GeneratorSwitch.h" //done
#import "RocketRobot.h"
#import "WaterPipe.h"
#import "ElectricDoor.h"
#import "SciFiBar.h"
#import "RotatingWheel.h"
#import "DoorSwitch.h"
#import "SpaceGuard.h"
#import "GroundBlock.h"
#import "BlueCylinder.h"
#import "PressurizedSteam.h"
#import "PinkAlien.h"
//@implementation ObjectFactory
static ObjectFactory *instanceOfObjectFactory;

ObjectFactory * ObjectFactory::sharedObjectFactory(){
    if (instanceOfObjectFactory==NULL) {
        instanceOfObjectFactory = new ObjectFactory;
    }
    return instanceOfObjectFactory;
}

Class ObjectFactory::levelObjectClassForInt(int c){
    switch (c) {
        case 0:
            return [StandardBlock class];
            break;
        case 1:
            return [standardWall class];
            break;
        case 2:
            return [SandBag class];
            break;
        case 3:
            return [ExplosiveBarrel class];
            break;
        case 4:
            return [Entrance class];
            break;
        case 5:
            return [Glass class];
            break;
        case 6:
            return [CircleJoint class];
            break;
        case 7:
            return [ElectricArc class];
            break;
        case 8:
            return [IronBar class];
            break;
        case 9:
            return [ExplosiveBox class];
            break;
        case 10:
            return [Exit class];
            break;
        case 11:
            return [Forcefield class];
            break;
        case 12:
            return [GeneratorSwitch class];
            break;
        case 13:
            return [WaterPipe class];
            break;
        case 14:
            return [ElectricDoor class];
        case 15:
            return [SciFiBar class];
        case 16:
            return [RotatingWheel class];
        case 17:
            return [DoorSwitch class];
        case 18:
            return [GroundBlock class];
        case 19:
            return [BlueCylinder class];
        case 20:
            return [PressurizedSteam class];

        default:
            return nil;
            break;
    }
}
Class ObjectFactory::baseAIClassForInt(int c){
    switch (c) {
        case 0:
            return [GreenBlob class];
            break;
        case 1:
            return [Robot class];
            break;
        case 2:
            return [RocketRobot class];
            break;
        case 3:
            return [SpaceGuard class];
            break;
        case 4:
            return [PinkAlien class];
            break;
        default:
            return nil;
            break;
    }

}

