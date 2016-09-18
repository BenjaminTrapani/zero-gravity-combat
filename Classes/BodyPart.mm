//
//  BodyPart.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 6/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//notes on use:
//-set health outside of this class
#import "BodyPart.h"
#import "CDXAudioNode.h"
#import "b2Shape.h"
#import "RaysCastCallback.h"
@implementation BodyPart
@synthesize spirtDirection;
@synthesize relativeSpirtPosition;
@synthesize maxHealth;
-(b2Body*) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef
                  fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)fileName{
    //calling this because body part creation code doesn't;
    [super init];
    super.usesSpriteBatch = NO;
    super.destructible = YES;
    super.takesDamageFromBullets = YES;
    super.destructionParticle = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bodyPartDeathParticle.plist"];
    super.destructionSound = [CDXAudioNode audioNodeWithFile:@"bodyPartDeathSound.wav" soundEngine:[[HelloWorldLayer sharedHelloWorldLayer]getSoundEngine] sourceId:0];
    super.contactColor = ccc3(250, 0, 0);
    super.explosive = NO;
    
    return [super createBodyInWorld:world bodyDef:bodyDef fixtureDef:fixtureDef spriteFrameName:fileName];
    
}
-(void)setHealth:(float)nhealth{
    if (nhealth>health) {
        maxHealth = nhealth/2.0f;
        [super setHealth:maxHealth];
    }else{
        [super setHealth:nhealth];
    }
    
}
-(void)explode{
    [super explode];
    CCNode * parent = [self parent];
    if (parent) {
        [parent onBodyPartDestroyed:self];
    }
        b2JointEdge* je = super.body->GetJointList();
        while (je)
        {
            b2JointEdge* je0 = je;
            je = je->next;
            
            b2Joint * curJoint = je0->joint;
            b2Vec2 anchorA = curJoint->GetAnchorA();
            b2Vec2 anchorB = curJoint->GetAnchorB();
            b2Vec2 estLocofJoint = b2Vec2((anchorA.x+anchorB.x)/2,(anchorA.y + anchorB.y)/2);
            //BodyPart * connectedBody = nil;
            if (je0->other) {
               BodyPart * connectedBody = (BodyPart*)je0->other->GetUserData(); 
                CCParticleSystem * bloodSpirt = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bloodSpirt.plist"];
                CGPoint pixelContactPoint = [Helper toPixels:estLocofJoint];
                bloodSpirt.position = [super.sprite convertToNodeSpace:pixelContactPoint];
                [super.sprite addChild:bloodSpirt];
                                
                 
                [connectedBody onLinkedBodyDestroyed:self withPoint:pixelContactPoint]; //add this method to spaceguard
                
            }
            
            //world->DestroyJoint(curJoint);
        }
    

}
-(void)dealloc{
        [super dealloc];
}
-(void)onLinkedBodyDestroyed:(BodyPart*)destroyedBody withPoint:(CGPoint)bloodPos{
    CCParticleSystem * bloodSpirt = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bloodSpirt.plist"];
    bloodSpirt.position = [super.sprite convertToNodeSpace:bloodPos];
    [super.sprite addChild:bloodSpirt];
}
@end
