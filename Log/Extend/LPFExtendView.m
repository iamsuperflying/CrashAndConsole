//
//  LPFExtendView.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/27.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "LPFExtendView.h"
#import "LPFGeneric.h"

@interface LPFExtendButton : UIButton

@property(nonatomic, assign) CGFloat radius;

@end

@implementation LPFExtendButton

//+ (instancetype)buttonWithSegment:(RSSegment *)segment {
//    return [self buttonWithTitle:segment.title image:segment.image];
//}

+ (instancetype)buttonWithTitle:(NSString *)title
                          image:(UIImage *)image
                         radius:(CGFloat)radius {
    LPFExtendButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:12];
    [button setTitle:title];
    [button setImage:image];
    button.adjustsImageWhenHighlighted = NO;
    
    
    [button addShadowWithColor:[UIColor blackColor]
                  shadowOffset:CGSizeMake(0.5, 2)
                 shadowOpacity:0.4
                  shadowRadius:radius];
    return button;
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
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
//    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
}

- (void)transformIdentity {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.transform = CGAffineTransformIdentity;
//    }];
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


@interface LPFExtendView ()

@property(nonatomic, strong) UIVisualEffectView *effectview;
@property(nonatomic, strong) UIStackView *containerView;
@property(nonatomic, strong) LPFExtendButton *currentButton;

@end

@implementation LPFExtendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
//    self.backgroundColor = [UIColor blueColor];
    
    CGFloat radius = (CGRectGetHeight(self.frame) - 6) * 0.5;
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    
    self.currentButton = [LPFExtendButton buttonWithTitle:@"+"
                                                    image:nil
                                                   radius:radius];
    LPFExtendButton *t2Button = [LPFExtendButton buttonWithTitle:@"E"
                                                          image:nil
                                                         radius:radius];
    LPFExtendButton *t3Button = [LPFExtendButton buttonWithTitle:@"S"
                                                          image:nil
                                                         radius:radius];
    LPFExtendButton *t4Button = [LPFExtendButton buttonWithTitle:@"T"
                                                          image:nil
                                                         radius:radius];
    

    
    [self.containerView addArrangedSubview:t2Button];
    [self.containerView addArrangedSubview:t3Button];
    [self.containerView addArrangedSubview:t4Button];
    
    
    t2Button.hidden = YES;
    t3Button.hidden = YES;
    t4Button.hidden = YES;
    
    [self addSubview:self.currentButton];
    //    [self addConstraintsWithVF:@"H:|-3-[currentButton(44.)]" metrics:nil views:@{ @"currentButton" : _currentButton}];
    //    [self addConstraintsWithVF:@"V:|-3-[currentButton]-3-|" metrics:nil views:@{@"currentButton": _currentButton}];
    
    self.currentButton.frame = CGRectMake(3, 3, 44, 44);
    self.currentButton.radius = 22;
    self.currentButton.selected = YES;
    
//    [self.currentButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)click:(LPFExtendButton *)button {

    self.show = !self.isShow;
    !self.block ? : self.block(self.show);
    
    [UIView animateWithDuration:0.15 animations:^{
        
        if (self.isShow) {
            
            self.currentButton.transform = CGAffineTransformRotate(self.currentButton.transform, M_PI_4);
//            self.frame = CGRectMake(100, 200, 201, CGRectGetHeight(self.bounds));
            [self.containerView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof LPFExtendButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                button.hidden = NO;
                
            }];
            
            self.currentButton.transform = CGAffineTransformRotate(self.currentButton.transform, M_PI_4 * 0.5);
        } else {
            
            self.currentButton.transform = CGAffineTransformIdentity;
//            self.frame = CGRectMake(100, 200, 50, CGRectGetHeight(self.bounds));
            [self.containerView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof LPFExtendButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                button.hidden = idx != 0;
                
            }];
            
//            self.currentButton.transform = CGAffineTransformIdentity;
        }
    
    }];

}

- (UIStackView *)containerView {
    if (!_containerView) {
        _containerView = [[UIStackView alloc] init];
        _containerView.axis = UILayoutConstraintAxisHorizontal;
        _containerView.distribution = UIStackViewDistributionFillEqually;
        _containerView.spacing = 6;
        _containerView.alignment = UIStackViewAlignmentFill;
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_containerView];
        [self addConstraintsWithVF:@"H:|-53-[container]-3-|" metrics:nil views:@{ @"container" : _containerView}];
        [self addConstraintsWithVF:@"V:|-3-[container]-3-|" metrics:nil views:@{@"container": _containerView}];
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

- (void)addConstraintsWithVF:(NSString *)vf
                     metrics:(nullable NSDictionary<NSString *,id> *)metrics
                       views:(NSDictionary<NSString *, id> *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vf
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (LPFExtendButton *button in self.containerView.arrangedSubviews) {
        button.radius = (CGRectGetHeight(self.frame) - 6) * 0.5;
    }
}

/**
 NSString *vfH = @"H:|[detailLabel]|";
 [self addConstraintsWithVF:vfH metrics:nil views:@{@"detailLabel" : _detailLabel}];
 NSString *vfV = @"V:[titleLabel]-20-[detailLabel]";
 [self addConstraintsWithVF:vfV metrics:nil views:@{@"titleLabel" : self.titleLabel, @"detailLabel" : _detailLabel}];
 */

@end
