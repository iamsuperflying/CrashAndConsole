//
//  RSSegmentControl.h
//
//  Description:
//
//  Created by LPF. on 2019/6/27.
//

#import <UIKit/UIKit.h>
#import "RSSegment.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSegmentControl : UIControl

@property(nonatomic, strong) NSArray<NSString *> *titles;
@property(nonatomic, strong) NSArray<UIImage *> *images;

@property(nonatomic, strong) UISegmentedControl *s;

- (instancetype)initWithImages:(nullable NSArray<UIImage *> *)images;
- (instancetype)initWithTitles:(nullable NSArray<NSString *> *)titles;

/// control is automatically sized to fit content
- (instancetype)initWithSegments:(nullable NSArray<RSSegment *> *)segments;

- (void)addSegmentWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;

/// must be 0..#segments - 1 (or ignored). default is nil
- (void)setTitle:(nullable NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (nullable NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

/// must be 0..#segments - 1 (or ignored). default is nil
- (void)setImage:(nullable UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (nullable UIImage *)imageForSegmentAtIndex:(NSUInteger)segment;

/// must be 0..#segments - 1 (or ignored). default is nil
- (void)setTitle:(nullable NSString *)title image:(nullable UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (RSSegment *)itemForSegmentAtIndex:(NSUInteger)segment;

/// set to 0.0 width to autosize. default is 0.0
- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment;
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

- (void)removeAllSegments;

@end


@interface RSSegmentControl ()

@property(nonatomic, strong) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic, strong) IBInspectable UIImage *backgroundImage;
@property(nonatomic, readonly, assign) IBInspectable NSUInteger numberOfSegments;

@property(nonatomic, readonly, assign) IBInspectable NSInteger segment;
@property(nonatomic, readonly, strong) IBInspectable UIImage *image;
@property(nonatomic, readonly, strong) IBInspectable NSString *title;

@property(nonatomic) NSInteger selectedSegmentIndex;

@end

NS_ASSUME_NONNULL_END
