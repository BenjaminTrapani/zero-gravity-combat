/*
 *  MyQueryCallback.h
 *  Zero Gravity Combat
 *
 *  Created by Ben Trapani on 1/22/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#import"Box2D.h"
#import "vector.h"
class MyQueryCallback : public b2QueryCallback {
public:
	std::vector<b2Body*> foundBodies;
	
	bool ReportFixture(b2Fixture* fixture) {
		foundBodies.push_back( fixture->GetBody() ); 
		return true;//keep going to find all fixtures in the query area
	}
};