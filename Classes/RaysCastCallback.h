/*
 *  RaysCastCallback.h
 *  Zero Gravity Combat
 *
 *  Created by Ben Trapani on 10/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "Box2D.h"
#import "vector.h"
class RaysCastCallback : public b2RayCastCallback
{
public:
    RaysCastCallback() : m_fixture(NULL) {
    }
	
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float32 fraction) { 
        if (ignoreIndex!=0) {
            if (fixture->GetFilterData().groupIndex == ignoreIndex) {
                return -1;
            }
        }
		if (allIntersections==YES) {
			foundBodies.push_back( fixture->GetBody() );
			return 1;
		}
        m_fixture = fixture;        
        m_point = point;        
        m_normal = normal;        
        m_fraction = fraction;        
        return fraction;     
    }    
	int16 ignoreIndex; //if specified, the raycast will ignore any fixtures with a group index specified here
	BOOL allIntersections; //if yes, the raycast will store a list of all the fixtures it encounters
    b2Fixture* m_fixture;    
    b2Vec2 m_point;    
    b2Vec2 m_normal;    
    float32 m_fraction;
	std::vector<b2Body*> foundBodies;
	
};