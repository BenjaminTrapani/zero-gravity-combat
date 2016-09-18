//
//  Singleton.cpp
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/20/12.
//
//

#include "Singleton.h"
#include <stdlib.h>
Singleton * Singleton::instanceOfSingleton = NULL;
Singleton::Singleton(){
    isIpad = false;
}
Singleton * Singleton::sharedInstance(){
    if (instanceOfSingleton == NULL) {
        instanceOfSingleton = new Singleton();
    }
    return instanceOfSingleton;
}
Singleton::~Singleton(){
    delete instanceOfSingleton; //the goal of this singleton is to scale box2d forces. test this.
}

