//
//  ContactListener.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Box2D.h"

class ContactListener : public b2ContactListener {
private:
	CGPoint lastContactPoint;
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};
