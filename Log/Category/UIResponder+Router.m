//
//  UIResponder+Router.m
//
//  Description:
//
//  Created by LPF. on 2019/6/18.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)rs_routerEventWithName:(NSString *)eventName objects:(NSArray *)objects {
    [[self nextResponder] rs_routerEventWithName:eventName objects:objects];
}

@end
