//
//  UIView+Extension.h
//
//  Created by iOS on 2018/6/27.
//  Copyright © 2018年 Risense. All rights reserved.
//

#import <UIKit/UIKit.h>
CGPoint CGRectGetCenter(CGRect rect);
@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

+ (instancetype)viewFromNib;
+ (UINib *)nib;

- (void)removeAllSubViews;
- (UIImage *)screenshot;
- (UIImage *)screenshotRect:(CGRect)frame;

/**
 * 添加一个无偏移的阴影
 * view 必须设置 clipsToBounds = NO
 */
- (void)addNoOffsetShadow:(CGFloat)radius;

/**
 * 添加一个阴影
 * view 必须设置 clipsToBounds = NO
 */
- (void)addShadowWithColor:(UIColor *)color
              shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(CGFloat)shadowOpacity
              shadowRadius:(CGFloat)shadowRadius;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

/**
 计算 Label 高度
 NSStringDrawingUsesDeviceMetrics

 @param text 文字
 @param width Label 的宽度
 @param font Label 字体
 @return 高度
 */
- (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

/** 计算 Label 宽度
 */
- (CGFloat)widthForText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

- (void)addConstraintsWithVF:(NSString *)vf
                     metrics:(nullable NSDictionary<NSString *,id> *)metrics
                       views:(NSDictionary<NSString *, id> *)views;

@end
