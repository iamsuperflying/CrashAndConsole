//
//  RSLogsView.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/25.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "RSConsole.h"
#import "RSLogMessage.h"
#import "UIView+Extension.h"
#import "RSSearchTextField.h"
#import "RSSegmentControl.h"
#import "LPFExtendView.h"
#import "LPFCrashView.h"
#import "LPFCrashCaught.h"
#import "UIButton+LPFExtension.h"

static const char * KArrayQueue = "com.console.arrayQueue";

//@interface RSSegmentButton : UIButton
//
//@end
//
//@implementation RSSegmentButton
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self addShadowWithColor:[UIColor blackColor] shadowOffset:CGSizeMake(0.5, 2) shadowOpacity:0.4 shadowRadius:8];
//}
//
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    UIColor *bgColor = selected ? rs_rgbColor(99, 99, 102) : [UIColor clearColor];
//    [self setBackgroundColor:bgColor];
//    self.clipsToBounds = !selected;
//}
//
//@end

@interface LPFOutputSelectButton : UIButton

@end

@implementation LPFOutputSelectButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 29CC33
    
    CGFloat iamgeW = CGRectGetWidth(self.imageView.frame);
    CGFloat imageX = CGRectGetWidth(self.frame) - iamgeW;
    
    self.imageView.frame = CGRectMake(imageX, CGRectGetMinY(self.imageView.frame), iamgeW, CGRectGetHeight(self.imageView.frame));
    self.titleLabel.frame = CGRectMake(0, CGRectGetMinY(self.titleLabel.frame), imageX,  CGRectGetHeight(self.titleLabel.frame));
    
    NSLog(@"%s title: %@ %@", __func__, self.titleLabel.text, NSStringFromCGRect(self.titleLabel.frame));
    
}

@end

@interface RSConsole ()<UITextFieldDelegate>

@property(nonatomic, assign, readwrite, getter=isShow) BOOL show;

@property(nonatomic, strong) dispatch_queue_t arrayQueue;
@property(nonatomic, copy) NSArray<RSLogMessage *> *logs;
@property(nonatomic, strong) UIView *searchRightView;
@property(nonatomic, strong) UILabel *searchResultCountLabel;
@property(nonatomic, strong) UIButton *searchResultPreviousButton;
@property(nonatomic, strong) UIButton *searchResultNextButton;
@property(nonatomic, strong) RSSegmentControl *segmentControl;
@property(nonatomic, strong) LPFOutputSelectButton *selectButton;
@property(nonatomic, strong) UIView *filterView;
@property(nonatomic, strong) UIButton *filterButton;
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) RSSearchTextField *searchTF;
@property(nonatomic, strong) UITextView *logsTV;




@end

@implementation RSConsole

static RSConsole *_instance;

+ (instancetype)console {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RSConsole alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
//    return self;
//}

//+ (void)show {
//    RSConsole *console = [self console];
//    if (console.isShow) {
//        return;
//    }
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    [window addSubview:console];
//    console.frame = CGRectMake(0, 300, CGRectGetWidth(window.frame), CGRectGetHeight(window.frame) - 300);
//    
//     [[NSNotificationCenter defaultCenter] addObserver:console selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}

+ (void)hide {
    [[self console] removeFromSuperview];
}

- (void)setUpUI {
    self.selectButton = [LPFOutputSelectButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setTitle:@"Nortmal" forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [self addSubview:self.selectButton];
}

- (void)updateLogs:(NSArray<RSLogMessage *> *)logs {
    self.logs = [logs copy];
    self.logsTV.attributedText = [[NSAttributedString alloc] init];
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] init];
    [logs enumerateObjectsUsingBlock:^(RSLogMessage * _Nonnull log, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [textAttr appendAttributedString:log.consoleLine];
        
//        NSString *message = rs_format(@"%@\n%@", self.logsTV.attributedText, log.originalMessage);
//        self.logsTV.text = message;
//        self.logsTV.layoutManager.allowsNonContiguousLayout = NO;
//        //获取总文字个数
//        [self.logsTV scrollRangeToVisible:NSMakeRange(0, message.length)];
        //使用可放在你的自定义方法或者UITextViewDelegate方法里面使用，比如文本变更时候 - textViewDidChange
    }];
    
    self.searchTF.leftView = nil;
    self.logsTV.attributedText = textAttr;
    self.logsTV.layoutManager.allowsNonContiguousLayout = NO;
    //        //获取总文字个数
    [self.logsTV scrollRangeToVisible:NSMakeRange(0, textAttr.length)];
    
}

- (void)updateLogs:(NSArray<RSLogMessage *> *)logs matchingString:(NSString *)matchingString {
    
    if (!matchingString.length) {
        [self updateLogs:logs];
        return;
    }
    
    if (!self.arrayQueue) {
        self.arrayQueue = dispatch_queue_create(KArrayQueue, NULL);
    }
    
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] init];
    __block NSInteger searchResultCount = 0;
    dispatch_async(self.arrayQueue, ^{
        [logs enumerateObjectsUsingBlock:^(RSLogMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([message.message containsString:matchingString]) {
                [attrStrM appendAttributedString:message.consoleLine];
                searchResultCount += 1;
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.searchTF.leftView = self.searchResultCountLabel;
            self.searchResultCountLabel.frame = CGRectMake(0, 0, 60, self.searchTF.height);
            self.searchResultCountLabel.text = rs_format(@"%zd matches", searchResultCount);
            self.logsTV.attributedText = attrStrM;
            self.logsTV.layoutManager.allowsNonContiguousLayout = NO;
            [self.logsTV scrollRangeToVisible:NSMakeRange(0, attrStrM.length)];
        });
        
    });
    
    
}

- (IBAction)loadNewLogs:(UIButton *)sender {
//    NSArray *logs = !_update ? nil : _update();
//    [self updateLogs:self.logs];
}

#pragma mark - Func
- (BOOL)isShow {
    return self.superview;
}

- (IBAction)deleteLogs:(UIButton *)sender {
    if (!_update) {
        return;
    }
    NSArray<RSLogMessage *> *logs = _update();
    [self updateLogs:logs];
}

- (void)segmentClick:(RSSegmentControl *)segmentControl {
    NSInteger index = segmentControl.selectedSegmentIndex;
    if (index == 1) {
        LPFCrashView *view = [[LPFCrashView alloc] init];
        view.frame = self.logsTV.frame;
        view.crashes = [LPFCrashCaught lpf_getCrashLogs];
        [self addSubview:view];
    } else {
        
    }
}

#pragma mark - Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}


- (void)filterChanged:(UITextField *)tf {
    NSString *regExpStr = tf.text;
    [self updateLogs:self.logs matchingString:regExpStr];
    
    // 创建 NSRegularExpression 对象,匹配
//    NSRegularExpression *regExp = [[NSRegularExpression alloc]
//                                   initWithPattern:regExpStr
//                                   options:NSRegularExpressionCaseInsensitive
//                                   error:nil];
//    [regExp enumerateMatchesInString:log
//                             options:NSMatchingReportProgress
//                               range:NSMakeRange(0, log.length)
//                          usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
//
//                              if (result) {
//                                  NSString *resultStr = [log substringWithRange:result.range];
//                                  NSLog(@"result %@", resultStr);
//                              }
//
//                          }];
    
    UIColor *color = tf.text.length ? rs_rgbColor(41, 204, 51) : [UIColor whiteColor];
    self.filterButton.layer.borderColor = color.CGColor;
    self.filterButton.selected = tf.text.length;
    
}


#pragma mark - Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

- (void)filterButtonClick:(UIButton *)sender {
    
}

- (void)deleteButtonClick:(UIButton *)sender {
    
}

- (void)selectButtonClick:(UIButton *)sender {
    
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bottomY = self.height - 56 - rs_bottomHeight();
    self.selectButton.frame = CGRectMake(5, bottomY, 66, 40);
    self.deleteButton.frame = CGRectMake(rs_screenWidth() - 50, bottomY,40, 40);
    self.filterView.frame = CGRectMake(81, bottomY, rs_screenWidth() - 136, 40);
    self.filterButton.frame = CGRectMake(5, 8, 24, 24);
    self.filterButton.layer.cornerRadius = CGRectGetWidth(self.filterButton.bounds) * 0.5;
    self.searchTF.frame = CGRectMake(34, 5, self.filterView.width - 39, 30);
    self.logsTV.frame = CGRectMake(5, 5, rs_screenWidth() - 10, bottomY - 10);
}

#pragma mark - Lazy
//- (UIView *)searchRightView {
//    if (!_searchRightView) {
//        self.searchRightView = [[UIView alloc] init];
//
//        _searchResultCountLabel = [[UILabel alloc] init];
//        _searchResultCountLabel.textColor = [UIColor lightGrayColor];
//        self.searchResultCountLabel.font = [UIFont systemFontOfSize:11];
//        [self.searchRightView addSubview:self.searchResultCountLabel];
////
//        _searchResultPreviousButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.searchResultPreviousButton setTitle:@"<" forState:UIControlStateNormal];
//        self.searchResultPreviousButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.searchResultPreviousButton setTitleColor:self.searchTF.textColor forState:UIControlStateNormal];
//        [self.searchResultPreviousButton sizeToFit];
//        [self.searchRightView addSubview:self.searchResultPreviousButton];
//
//        _searchResultNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.searchResultNextButton setTitle:@">" forState:UIControlStateNormal];
//        self.searchResultNextButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.searchResultNextButton setTitleColor:self.searchTF.textColor forState:UIControlStateNormal];
//        [self.searchResultNextButton sizeToFit];
//        [self.searchRightView addSubview:self.searchResultNextButton];
//
//        self.searchTF.rightView = self.searchRightView;
//        self.searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
//    }
//    return _searchRightView;
//}

- (UILabel *)searchResultCountLabel {
    if (!_searchResultCountLabel) {
        _searchResultCountLabel = [[UILabel alloc] init];
        _searchResultCountLabel.numberOfLines = 0;
        _searchResultCountLabel.textColor = [UIColor lightGrayColor];
        self.searchResultCountLabel.font = [UIFont systemFontOfSize:11];
        self.searchTF.leftView = _searchResultCountLabel;
        self.searchTF.leftViewMode = UITextFieldViewModeWhileEditing;
    }
    return _searchResultCountLabel;
}

- (UITextView *)logsTV {
    if (!_logs) {
        _logsTV = [[UITextView alloc] init];
        _logsTV.backgroundColor = [UIColor clearColor];
        _logsTV.editable = NO;
        [self addSubview:_logsTV];
    }
    return _logsTV;
}

- (LPFOutputSelectButton *)selectButton {
    if (!_selectButton) {
        _selectButton = (LPFOutputSelectButton *)[LPFOutputSelectButton buttonWithImage:[UIImage imageNamed:@"select"]
                                                   selectImage:nil
                                                        target:self
                                                        action:@selector(selectButtonClick:)
                                                         title:@"Normal"];
        [self addSubview:_selectButton];
    }
    return _selectButton;
}

- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] init];
        [self addSubview:_filterView];
        _filterView.layer.borderWidth = 1.0;
        _filterView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _filterView.layer.cornerRadius = 2;
        _filterView.layer.masksToBounds = YES;
        _filterView.backgroundColor = [UIColor clearColor];
    }
    return _filterView;
}

- (UIButton *)filterButton {
    if (!_filterButton) {
        // 41 204 51
        _filterButton = [UIButton buttonWithImage:[UIImage imageNamed:@"filter"]
                                      selectImage:[UIImage imageNamed:@"filtered"]
                                           target:self
                                           action:@selector(filterButtonClick:)
                                            title:nil];
        _filterButton.layer.borderWidth = 1.5;
        _filterButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _filterButton.imageEdgeInsets = UIEdgeInsetsMake(2, 3, 2, 3);
        _filterButton.layer.masksToBounds = YES;
        [self.filterView addSubview:_filterButton];
    }
    return _filterButton;
}

- (RSSearchTextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[RSSearchTextField alloc] init];
        [self.filterView addSubview:_searchTF];
        _searchTF.font = [UIFont fontWithName:@"Menlo-Bold" size:14];
        NSDictionary *attributes =  @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                      NSFontAttributeName:_searchTF.font};
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Search..."
                                                                         attributes:attributes];
        _searchTF.attributedPlaceholder = attrString;
        _searchTF.returnKeyType = UIReturnKeyDone;
        [_searchTF addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventEditingChanged];
        _searchTF.textColor = [UIColor whiteColor];
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.delegate = self;
        
    }
    return _searchTF;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithImage:[UIImage imageNamed:@"shanchu"]
                                      selectImage:nil
                                           target:self
                                           action:@selector(deleteButtonClick:)
                                            title:nil];
        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}

@end
