//
//  RSSegmentControl.m
//
//  Description:
//
//  Created by LPF. on 2019/6/27.
//

#import "RSSegmentControl.h"
#import "LPFGeneric.h"

IB_DESIGNABLE
@interface RSSegmentButton : UIButton

@end

@implementation RSSegmentButton

+ (instancetype)buttonWithSegment:(RSSegment *)segment {
    return [self buttonWithTitle:segment.title image:segment.image];
}

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image {
    RSSegmentButton *button = [RSSegmentButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:12];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    
    [button addShadowWithColor:[UIColor blackColor]
                  shadowOffset:CGSizeMake(0.5, 2)
                 shadowOpacity:0.4
                  shadowRadius:8];
    return button;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)addShadowWithColor:(UIColor *)color
              shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(CGFloat)shadowOpacity
              shadowRadius:(CGFloat)shadowRadius {
    self.layer.cornerRadius = shadowRadius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowRadius;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    UIColor *bgColor = selected ? rs_rgbColor(99, 99, 102) : [UIColor clearColor];
    [self setBackgroundColor:bgColor];
    self.clipsToBounds = !selected;
    if (!selected) {
        return;
    }
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

- (void)transformIdentity {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self transformIdentity];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self transformIdentity];
}

@end

IB_DESIGNABLE
@interface RSSegmentControl ()

@property(nonatomic, strong) UIStackView *containerView;
@property(nonatomic, strong) UIImageView *backGroundImageView;
@property(nonatomic, weak) RSSegmentButton *currentSelectedButton;
@property(nonatomic, strong) UIVisualEffectView *effectview;

@end

@implementation RSSegmentControl

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.effectview.superview) {
        [self insertSubview:self.effectview atIndex:0];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    if (self = [super init]) {
        self.titles = titles;
        [self removeAllSegments];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    if (self = [super init]) {
        self.images = images;
        [self removeAllSegments];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (void)setUpUI {
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)removeAllSegments {
    NSArray<__kindof UIView *> *arrangedSubviews = [self.containerView.arrangedSubviews copy];
    [arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.containerView removeArrangedSubview:obj];
    }];
}

- (instancetype)initWithSegments:(NSArray<RSSegment *> *)segments {
    self = [super init];
    if (self) {
        [self removeAllSegments];
        [segments enumerateObjectsUsingBlock:^(RSSegment * _Nonnull segment, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSegmentWithTitle:segment.title image:segment.image];
        }];
        [self selected:0];
    }
    return self;
}

- (void)resetSelected {
    
}

- (void)segmentClick:(RSSegmentButton *)button {
    NSInteger index = [self.containerView.arrangedSubviews indexOfObject:button];
    [self selected:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)selected:(NSInteger)index {
    if (index >= self.containerView.arrangedSubviews.count) {
        LogError(@"数组越界");
        return;
    }
    _selectedSegmentIndex = index;
    self.currentSelectedButton.selected = NO;
    RSSegmentButton *button = (RSSegmentButton *)self.containerView.arrangedSubviews[index];
    button.selected = YES;
    self.currentSelectedButton = button;
}

- (void)addTitleSegment:(NSString *)title {
    
}

- (void)addImageSegment:(UIImage *)image {
    
}

- (void)addSegmentWithTitle:(NSString *)title image:(UIImage *)image {
    RSSegmentButton *button = [RSSegmentButton buttonWithTitle:title image:image];
    [button addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchDown];
    [self.containerView addArrangedSubview:button];
    [self selected:0];
}

- (void)setNumberOfSegments:(NSUInteger)numberOfSegments {
    _numberOfSegments = numberOfSegments;
    for (int i = 0; i < numberOfSegments; i++) {
        [self addSegmentWithTitle:rs_format(@"%zd", i+1) image:nil];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backGroundImageView.image = backgroundImage;
}

- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] init];
        [self insertSubview:_backGroundImageView atIndex:0];
    }
    return _backGroundImageView;
}

- (UIStackView *)containerView {
    if (!_containerView) {
        CGRect frame = CGRectMake(5, 5, CGRectGetWidth(self.bounds) - 10, CGRectGetHeight(self.bounds) -10);
        _containerView = [[UIStackView alloc] initWithFrame:frame];
        _containerView.axis = UILayoutConstraintAxisHorizontal;
        _containerView.distribution = UIStackViewDistributionFillEqually;
        _containerView.spacing = 5;
        _containerView.alignment = UIStackViewAlignmentFill;
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.frame = self.bounds;
    }
    return _effectview;
}

- (NSInteger)countOfNumberOfSegments {
    return self.containerView.arrangedSubviews.count;
}

- (RSSegmentButton *)segmentButtonForSegmentAtIndex:(NSUInteger)segment {
    if (segment < 0 || segment >= [self countOfNumberOfSegments]) {
        return nil;
    }
    return  self.containerView.arrangedSubviews[segment];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
    RSSegmentButton *button = [self segmentButtonForSegmentAtIndex:segment];
    if (!button) {
        return nil;
    }
    return button.titleLabel.text;
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment {
    RSSegmentButton *button = [self segmentButtonForSegmentAtIndex:segment];
    if (!button) {
        return nil;
    }
    return button.imageView.image;
}

- (void)setSegment:(NSInteger)segment {
    _segment = segment;
    self.title = [self titleForSegmentAtIndex:segment];
    self.image = [self imageForSegmentAtIndex:segment];
}

- (void)setTitle:(NSString * _Nonnull)title {
    _title = title;
    [self setTitle:title forSegmentAtIndex:self.segment];
}

- (void)setImage:(UIImage * _Nonnull)image {
    _image = image;
    [self setImage:image forSegmentAtIndex:self.segment];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    RSSegmentButton *button = [self segmentButtonForSegmentAtIndex:segment];
    if (!button) {
        return;
    }
    [button setTitle:title];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    RSSegmentButton *button = [self segmentButtonForSegmentAtIndex:segment];
    if (!button) {
        return;
    }
    [button setImage:image];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    [self.containerView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof RSSegmentButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.layer.cornerRadius = cornerRadius;
    }];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

@end
