//
//  RSSearchTextField.m
//
//  Description:
//
//  Created by LPF. on 2019/6/26.
//

#import "RSSearchTextField.h"
#import "UIView+Extension.h"

@implementation RSSearchTextField

////控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    CGFloat x = self.bounds.size.width - 27 - iconRect.size.width;
    
    return CGRectMake(x, iconRect.origin.y, iconRect.size.width, iconRect.size.height);
}
//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}
////控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGFloat otherWidth = CGRectGetWidth(self.leftView.bounds);
    CGFloat width = CGRectGetWidth(self.bounds) - 27 - otherWidth;
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, width, bounds.size.height);
    return inset;
}

@end
