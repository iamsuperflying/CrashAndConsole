//
//  LPFRootViewController.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/27.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "LPFRootViewController.h"
#import "LPFExtendView.h"
#import "LPFCrashView.h"
#import "RSConsole.h"
#import "UIView+Extension.h"
#import "RSSegmentControl.h"
#import "LPFCrashCaught.h"
#import "LPFGeneric.h"
#import <QuickLook/QuickLook.h>

@interface LPFRootViewController ()<UIScrollViewDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property(nonatomic, strong) LPFCrashView *crashView;
@property(nonatomic, strong) RSConsole *console;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) RSSegmentControl *segmentControl;
@property(nonatomic, strong) UIVisualEffectView *effectview;
@property(nonatomic, strong) UIDocumentInteractionController *documentController;
@property(nonatomic, strong) QLPreviewController *previewController;

@end

@implementation LPFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.effectview];

    self.console = [RSConsole sharedConsole];
    self.crashView = [[LPFCrashView alloc] init];
    NSArray *crashes = [LPFCrashCaught lpf_getCrashLogs];
    self.crashView.crashes = [LPFCrashCaught lpf_getCrashLogs];
    [self setUpScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
//    [RSConsole show];
//    [RSConsole console].update = ^NSArray<RSLogMessage *> * _Nonnull{
//        self.logs = @[];
//        return self.logs;
//    };
    [self setUpUI];
    
}

- (void)setUpUI {
    
//    self.view.layer.cornerRadius = 10;
//    self.view.layer.masksToBounds = YES;
    self.segmentControl = [[RSSegmentControl alloc] initWithFrame:CGRectMake(5, 10, rs_screenWidth() - 10, 44)];
    [self.view addSubview:self.segmentControl];
    [self.segmentControl addSegmentWithTitle:@"Console" image:[UIImage imageNamed:@"rizhi"]];
    [self.segmentControl addSegmentWithTitle:@"Crash" image:[UIImage imageNamed:@"yichang"]];
    [self.segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
   
}

- (void)segmentClick:(UISegmentedControl *)segmentControl {
    NSInteger index = segmentControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(index * rs_screenWidth(), 0) animated:YES];
}

- (void)rs_routerEventWithName:(NSString *)eventName objects:(NSArray *)objects {
//    NSArray *items = @[@"crash share", objects.firstObject];
//    [items addObjectsFromArray:objects];
    
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                    UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage,
                                    UIActivityTypeMail,
                                    UIActivityTypePrint,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo,
                                    UIActivityTypePostToTencentWeibo];
    
    
    NSString *crashPath = [LPFCrashCaught lpf_getCrashPath];
////    [crashPath con]
    NSURL *shareURL = [NSURL fileURLWithPath:crashPath];
    
    NSString *shareMessage = crashPath.lastPathComponent;

    NSArray *shareItems = @[shareMessage, shareURL];

    UIActivityViewController *a = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    a.excludedActivityTypes = excludedActivities;
    [self presentViewController:a animated:YES completion:nil];
}

//- (void)preview {
//    _previewController = [[QLPreviewController alloc] init];
//    _previewController.dataSource = self;
//    _previewController.delegate = self;
//    [self presentViewController:_previewController animated:YES completion:nil];
//}
//
//-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
//    return 1;
//}
//
//-(id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
//    NSString *crashPath = [LPFCrashCaught lpf_getCrashPath];
//    //    [crashPath con]
//    NSURL *shareURL = [NSURL fileURLWithPath:crashPath];
//    return shareURL;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"doc"];
//    NSURL *myDoucment = [NSURL fileURLWithPath:path];
//    return myDoucment;
//}

#pragma mark - UIDocumentInteractionControllerDelegate
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
//    return self;
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return [UIApplication sharedApplication].delegate.window.rootViewController.view;
//    return self.view;
}
-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds;
//    return self.view.bounds;
}

//ios系统分享
-(void)SystemShareWithTitle:(NSString*)title withText:(NSString*)text withImageUrl:(NSString*)url withSiteUrl:(NSString*)siteurl withVC:(UIViewController*)VC
{
    NSString *titleText = title;
    NSString *shareText = text;
    NSURL *URL = [NSURL URLWithString:siteurl];
    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    UIActivityViewController *a = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:titleText,shareText,URL,image, nil] applicationActivities:nil];
    [VC presentViewController:a animated:true completion:nil];
}

#pragma mark - Notification
- (void)keyboardNotification:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.view.y = rect.origin.y - self.view.height;
}

#pragma mark - Layout
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat height = self.view.height - 64;
    self.scrollView.frame = CGRectMake(0, 64, self.view.width, height);
    self.console.frame = CGRectMake(0, 0, self.view.width, height);
    self.crashView.frame = CGRectMake(self.view.width, 0, self.view.width, height);
}

- (void)setUpScrollView {
    
    // 控制器属性，调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    // 将子控制器的view添加到ScrollView上
    CGFloat childViewW = CGRectGetWidth(self.view.bounds);
    // 添加子控制器view到scrollView上
    NSInteger count = self.childViewControllers.count;
    // scrollView的内容
    scrollView.contentSize = CGSizeMake(count * childViewW, 0);
    
    [scrollView addSubview:self.console];
    [scrollView addSubview:self.crashView];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.frame = self.view.bounds;
    }
    return _effectview;
}


@end
