//
//  UIButton+LPFExtension.m
//
//  Description:
//
//  Created by LPF. on 2019/6/28.
//

#import "UIButton+LPFExtension.h"

@implementation UIButton (LPFExtension)
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                                  title:(NSString *)title
                         titleLabelFont:(UIFont *)font
                             titleColor:(UIColor *)titleColor
                                 target:(id)target
                                 action:(SEL)action
                          clipsToBounds:(BOOL)clipsToBounds {
    
    UIButton *button = [[UIButton alloc] init];
    if (clipsToBounds) button.layer.cornerRadius = 22;
    //    button.clipsToBounds = clipsToBounds;
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)buttonWithTitleLabelFont:(UIFont *)font
                   titleColor:(UIColor *)titleColor
                        image:(UIImage *)image
                  selectImage:(UIImage *)selectImage
                       target:(id)target
                       action:(SEL)action
                clipsToBounds:(BOOL)clipsToBounds
                        Title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (clipsToBounds) button.layer.cornerRadius = 5;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

+ (UIButton *)buttonWithTitleLabelFont:(UIFont *)font
                            titleColor:(UIColor *)titleColor
                                target:(id)target
                                action:(SEL)action
                                 Title:(NSString *)title
                         SelectedTitle:(NSString *)selectedTitle {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



/**
 *  快速创建一个带边框的button
 *
 *  @param backgroundColor button背景颜色
 *  @param title           按钮title文字
 *  @param font            按钮title字体大小
 *  @param titleColor      按钮titleyanse
 *  @param target          target
 *  @param action          action
 *
 *  @return 创建好的button
 */
//+ (UIButton *)borderButtonWithBackgroundColor:(UIColor *)backgroundColor
//                                        title:(NSString *)title
//                               titleLabelFont:(UIFont *)font
//                                   titleColor:(UIColor *)titleColor
//                                       target:(id)target
//                                       action:(SEL)action
//                                clipsToBounds:(BOOL)clipsToBounds {
//
//    UIButton *button = [[UIButton alloc] init];
//    if (clipsToBounds) button.layer.cornerRadius = 5;
//    button.layer.borderWidth = 1.0;
//    button.layer.borderColor = LPFSeparatorColor.CGColor;
//    button.backgroundColor = backgroundColor;
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = font;
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}


+ (instancetype)buttonWithImage:(UIImage *)image
                      selectImage:(UIImage *)selectImage
                           target:(id)target
                           action:(SEL)action
                            title:(NSString *)title {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:12];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
