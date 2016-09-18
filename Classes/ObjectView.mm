//
//  ObjectView.m
//  Zero Gravity Combat
//
//  Created by Ben Trapani on 5/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectView.h"
#import "Constants.h"
#import "ObjectFactory.h"
#import "Options.h"
#import "MyMenuItem.h"
#import "MyMenu.h"
#import "HelloWorldLayer.h"
#import "PropertiesView.h"
@implementation ObjectView

-(id)init{
    if ((self = [super init])) {
        MyMenu * menuWithAllObjects = [MyMenu menuWithItems:nil];
        menuWithAllObjects.isContinuous = NO;
        [self addChild:menuWithAllObjects];
        ObjectFactory * factory = ObjectFactory::sharedObjectFactory();
        float yLoc = 0;
        float xLoc = 0;//[[Options sharedOptions]makeXConstantRelative:100];
        float longestX = 0;
        float labelScale = 0.5f;
        float maxHeight = [[Options sharedOptions]makeYConstantRelative:170]; //150
        CCLabelBMFont * hideLabel = [CCLabelBMFont labelWithString:@"Hide" fntFile:@"FuturedBMFont.fnt"];
        CCMenuItemLabel * hide = [CCMenuItemLabel itemWithLabel:hideLabel target:self selector:@selector(hideThis)];
        hide.position = ccp(0,175);
        [menuWithAllObjects addChild:hide];
        CCLabelBMFont * showLabel = [CCLabelBMFont labelWithString:@"Show" fntFile:@"FuturedBMFont.fnt"];
        CCMenuItemLabel * show = [CCMenuItemLabel itemWithLabel:showLabel target:self selector:@selector(showThis)];
        show.position = ccp(-1000,175);
        [menuWithAllObjects addChild:show];
        for (int i = 0; i<LEVEL_OBJECT_COUNT+AI_OBJECT_COUNT; i++) {
            Class curClass;
            if (i<LEVEL_OBJECT_COUNT) {
                curClass = factory->levelObjectClassForInt(i);
            }else{
                curClass = factory->baseAIClassForInt(i-LEVEL_OBJECT_COUNT);
            }
            
            NSString * name = NSStringFromClass(curClass);
            CCLabelBMFont * bmLabel = [CCLabelBMFont labelWithString:name fntFile:@"FuturedBMFont.fnt"];
            bmLabel.scale = labelScale;
            CGSize labelSize = bmLabel.contentSize;
            labelSize.width *= labelScale;
            labelSize.height *= labelScale;
            if (labelSize.width>longestX) {
                longestX = labelSize.width;
            }
            yLoc += labelSize.height;
            if (yLoc>maxHeight) {
                yLoc = labelSize.height;
                xLoc += longestX;
                longestX = 0;
            }
            CCMenuItemLabel * item = [CCMenuItemLabel itemWithLabel:bmLabel target:self selector:@selector(levelObjectClicked:)];
            item.position = ccp(xLoc/*+labelSize.width*/,yLoc);
            item.userData = name;
            [menuWithAllObjects addChild:item];
        }
    }
    return self;
}
-(void)hideThis{
    self.position = ccp(1000, self.position.y);
}
-(void)showThis{
    self.position = ccp(0,self.position.y);
}
-(void)levelObjectClicked:(CCMenuItemLabel*)sender{
    NSString * className = (NSString*)sender.userData;
    Class sentClass = NSClassFromString(className);
    [[[HelloWorldLayer sharedHelloWorldLayer]getPropertiesView]updatePropertiesWithClass:sentClass];
    //[sentClass createDefault]; //make all objects conform to an initWithProperties and getProperties. Try using the similar encodeWithCoder and decodeWithCoder functions
    //load this object in the properties view
}
@end
