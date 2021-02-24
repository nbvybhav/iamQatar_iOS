//
//  UIButton+Property.m
//  IamQatar
//
//  Created by alisons on 1/4/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "UIButton+Property.h"
#import <objc/runtime.h>

@implementation UIButton (Property)

static char UIB_PROPERTY_KEY;

@dynamic property;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setProperty:(NSObject *)property
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)property
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

@end
