//
//  Singleton.h
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 10/20/12.
//
//

#ifndef Zero_Gravity_Combat_Singleton_h
#define Zero_Gravity_Combat_Singleton_h
class Singleton{
public:
    Singleton();
    ~Singleton();
    static Singleton * sharedInstance();
    bool isIpad;
private:
    static Singleton * instanceOfSingleton;
};


#endif
