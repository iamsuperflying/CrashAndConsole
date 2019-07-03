//
//  UIButton+LPFExtension.h
//
//  Description:
//
//  Created by LPF. on 2019/6/28.
//

#import <UIKit/UIKit.h>

@interface UIButton (LPFExtension)
/**
 *  快速创建一个button
 */
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                                  title:(NSString *)title
                         titleLabelFont:(UIFont *)font
                             titleColor:(UIColor *)titleColor
                                 target:(id)target
                                 action:(SEL)action
                          clipsToBounds:(BOOL)clipsToBounds;

+ (UIButton *)buttonWithTitleLabelFont:(UIFont *)font
                            titleColor:(UIColor *)titleColor
                                 image:(UIImage *)image
                           selectImage:(UIImage *)selectImage
                                target:(id)target
                                action:(SEL)action
                         clipsToBounds:(BOOL)clipsToBounds
                                 Title:(NSString *)title;

+ (UIButton *)buttonWithTitleLabelFont:(UIFont *)font
                            titleColor:(UIColor *)titleColor
                                target:(id)target
                                action:(SEL)action
                                 Title:(NSString *)title
                         SelectedTitle:(NSString *)selectedTitle;

+ (UIButton *)buttonWithImage:(UIImage *)image
                  selectImage:(UIImage *)selectImage
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title;

/**
 *  快速创建一个带边框的button
 */
+ (instancetype)borderButtonWithBackgroundColor:(UIColor *)backgroundColor
                                          title:(NSString *)title
                                 titleLabelFont:(UIFont *)font
                                     titleColor:(UIColor *)titleColor
                                         target:(id)target
                                         action:(SEL)action
                                  clipsToBounds:(BOOL)clipsToBounds;


@end
