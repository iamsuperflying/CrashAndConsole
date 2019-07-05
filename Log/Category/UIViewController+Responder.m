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
    
    /**
     21:36:49.3649 Top View: Demo.BookViewController
     21:52:37.5237 Application: WillResignActive
     21:52:38.5238 Application: DidEnterBackground
     21:53:08.538 Application: WillEnterForeground
     21:53:09.539 Application: DidBecomeActive
     21:53:27.5327 Touch: (UIButton) in Demo.AudioViewController
     21:53:27.5327 Selector: nextButtonAction: by (UIButton) in Demo.AudioViewController
     */
    
    NSLog(@"self: %@ sender: %@", NSStringFromClass([self class]), NSStringFromClass([sender class]));
    NSLog(@"action: %@", NSStringFromSelector(action));
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        NSLog(@"title: %@ imageName: %@ action: %@", button.titleLabel.text, button.imageView.image, [button allTargets]);
    }
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        id view = [cell superview];
        while (view && ![view isKindOfClass:[UITableView class]] ) {
            view = [view superview];
        }
        UITableView *tableView = (UITableView *)view;
        
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        
        NSLog(@"%@", tableView);
    }
    
    
    return [super canPerformAction:action withSender:sender];
}

@end

