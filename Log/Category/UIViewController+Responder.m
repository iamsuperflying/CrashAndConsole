//
//  UIViewController+Responder.m
//  Log
//
//  Created by 李鹏飞 on 2019/7/4.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "UIViewController+Responder.h"

@implementation UIViewController (Responder)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    NSLog(@"self: %@ sender: %@", NSStringFromClass([self class]), NSStringFromClass([sender class]));
    NSLog(@"action: %@", NSStringFromSelector(action));
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        NSLog(@"title: %@ imageName: %@", button.titleLabel.text, button.imageView.image);
        
    }
    
    return [super canPerformAction:action withSender:sender];
}

@end
