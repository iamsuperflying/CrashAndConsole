//
//  UIView+Extension.m
//
//  Created by iOS on 2018/6/27.
//  Copyright © 2018年 Risense. All rights reserved.
//

#import "UIView+Extension.h"
CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}
@implementation UIView (Extension)

+ (instancetype)viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] lastObject];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight
{
    CGRect newframe = self.frame;
    newframe.origin.y = newRight - self.frame.size.width;
    self.frame = newframe;
}

- (void)removeAllSubViews
{
    while (self.subviews.count > 0) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)screenshotRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:frame afterScreenUpdates:YES];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**  防止像素没有落在坐标点上  */
static inline float pixel(float num) {
    float unit = 1.0 / [UIScreen mainScreen].scale;
    double remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0 ? unit : 0);
}

- (void)addNoOffsetShadow:(CGFloat)radius {
    [self addShadowWithColor:[UIColor lightGrayColor]
                shadowOffset:CGSizeZero
               shadowOpacity:0.3
                shadowRadius:radius];
}

- (void)addShadowWithColor:(UIColor *)color
              shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(CGFloat)shadowOpacity
              shadowRadius:(CGFloat)shadowRadius {
    self.layer.cornerRadius = shadowRadius;
    // 阴影颜色
    self.layer.shadowColor = color.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = shadowOffset;
    // 阴影透明度，默认0
    self.layer.shadowOpacity = shadowOpacity;
    // 阴影半径，默认3
    self.layer.shadowRadius = shadowRadius;
}

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

- (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    CGSize textSize = CGSizeMake(width, CGFLOAT_MAX);
    // 一个label的高度
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize labelSize = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesDeviceMetrics
                                       attributes:attributes
                                          context:nil].size;
    return labelSize.height;
}

- (CGFloat)widthForText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    CGSize textSize = CGSizeMake(CGFLOAT_MAX, height);
    // 一个label的高度
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize labelSize = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesDeviceMetrics
                                       attributes:attributes
                                          context:nil].size;
    return labelSize.height;
}

- (void)addConstraintsWithVF:(NSString *)vf
                     metrics:(nullable NSDictionary<NSString *,id> *)metrics
                       views:(NSDictionary<NSString *, id> *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

@end
