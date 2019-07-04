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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"用户点击步骤开始 %@", NSStringFromClass(self.class));
//    [[self nextResponder] touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"用户点击步骤结束 %@", NSStringFromClass(self.class));
//    [self.nextResponder touchesEnded:touches withEvent:event];
//}

@end
