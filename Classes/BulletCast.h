//
//  BulletCast.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/12/12.
//
//

#ifndef Zero_Gravity_Combat_BulletCast_h
#define Zero_Gravity_Combat_BulletCast_h
#import "Box2D.h"
#import "vector.h"
#import "Constants.h"
class BulletCast : public b2RayCastCallback
{
public:
    BulletCast() : m_fixture(NULL) {
        categoryBits = CATEGORY_BULLET;
        maskBits = MASK_BULLET;
    }
	
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point, const b2Vec2& normal, float32 fraction) {
        //quickly discard invalid collisions based on filter data
        const b2Filter * filter = &fixture->GetFilterData();
        if(! (filter->maskBits & categoryBits) !=0 && (filter->categoryBits & maskBits) !=0) return -1;
        
        if (ignoreIndex!=0) {
            if (fixture->GetFilterData().groupIndex == ignoreIndex) {
                return -1;
            }
        }

        
        //if(filter->groupIndex == ignoreIndex)return-1;
        m_fixture = fixture;
        m_point = point;
        m_normal = normal;
        m_fraction = fraction;
        return fraction;
    }
	
    uint16 categoryBits;
    uint16 maskBits;
    b2Fixture* m_fixture;
    b2Vec2 m_point;
    b2Vec2 m_normal;
    float32 m_fraction;
	int16 ignoreIndex;
	
};


#endif
