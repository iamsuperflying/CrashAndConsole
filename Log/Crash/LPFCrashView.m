//
//  LPFCrashView.m
//
//  Description:
//
//  Created by LPF. on 2019/6/28.
//

#import "LPFCrashView.h"
#import "LPFGeneric.h"
#import "UIButton+LPFExtension.h"
#import "UIView+Extension.h"

RSConstString KCrashShareEventName = @"KCrashShareEventName";

@interface LPFCrashView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *crashList;
@property(nonatomic, strong) UITextView *crashTV;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *shareButton;
@property(nonatomic, assign) CGFloat bottomHeight;

@end

@implementation LPFCrashView

- (instancetype)init {
    self = [super init];
    if( self) {
    
    }
    return self;
}

#pragma mark - Events
- (void)share:(UIButton *)sender {
    [self rs_routerEventWithName:KCrashShareEventName objects:@[self.crashTV.text]];
}

- (void)back:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.crashTV.x = self.width;
        self.bottomView.y = self.height;
        self.crashList.alpha = 1;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.crashList.frame = self.bounds;
    self.crashTV.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.bottomView.frame = CGRectMake(0, self.height, self.width, self.bottomHeight);
    self.backButton.frame = CGRectMake(16, 0, 50, 50);
    self.shareButton.frame = CGRectMake(self.width - 16 - 50, 0, 50, 50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crashes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        NSDictionary *dic = self.crashes[indexPath.row];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = rs_format(@"%@", dic.allKeys.firstObject);
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.crashTV.text = rs_format(@"%@", self.crashes[indexPath.row]);
    [UIView animateWithDuration:0.25 animations:^{
        self.crashTV.x = 0;
        self.bottomView.y = self.height - self.bottomHeight;
        tableView.alpha = 0;
    }];
}

- (UITableView *)crashList {
    if (!_crashList) {
        _crashList = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _crashList.rowHeight = 44;
        _crashList.delegate = self;
        _crashList.dataSource = self;
        _crashList.backgroundColor = [UIColor clearColor];
        _crashList.tableFooterView = [[UIView alloc] init];
        [self addSubview:_crashList];
    }
    return _crashList;
}

- (UITextView *)crashTV {
    if (!_crashTV) {
        _crashTV = [[UITextView alloc] init];
        _crashTV.backgroundColor = [UIColor clearColor];
        _crashTV.editable = NO;
        _crashTV.textColor = [UIColor whiteColor];
        _crashTV.font = [UIFont fontWithName:@"Menlo-Bold" size:14];
        _crashTV.contentInset = UIEdgeInsetsMake(0, 0, self.bottomHeight, 0);
        [self addSubview:_crashTV];
    }
    return _crashTV;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self addSubview:_bottomView];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, self.width, self.bottomHeight);
        [_bottomView addSubview:effectview];
    }
    return _bottomView;
}

- (UIButton *)shareButton {
    if(!_shareButton) {
        _shareButton = [UIButton buttonWithImage:[UIImage imageNamed:@"share"]
                                     selectImage:nil
                                          target:self
                                          action:@selector(share:)
                                           title:nil];
        [self.bottomView addSubview:_shareButton];
    }
    return _shareButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithImage:[UIImage imageNamed:@"back"]
                                    selectImage:nil
                                         target:self
                                         action:@selector(back:)
                                          title:nil];
        [self.bottomView addSubview:_backButton];
    }
    return _backButton;
}

- (CGFloat)bottomHeight {
    return rs_bottomHeight() + 50;
}

@end
