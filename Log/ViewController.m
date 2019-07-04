//
//  ViewController.m
//
//  Description:
//
//  Created by LPF. on 2019/6/25.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "RSLogMessage.h"
#import "RSSegmentControl.h"
#import "LPFCrashCaught.h"

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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RSSegmentControl *segmentControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"sdfasfdfsadfds");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"哈哈哈哈哈哈");
    });
    
//    NSArray *arr = @[];
    
    dispatch_queue_t q = dispatch_queue_create([@"com.flying.test" UTF8String], NULL);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), q, ^{
        NSLog(@"heheheheheeh");
//        arr[1];
    });
    
    
    
    NSLog(@"%@", NSStringFromClass([UIApplication sharedApplication].delegate.window.rootViewController.class));
    
//    [LPFCrashCaught lpf_clearCrashLogs];
//    NSArray *arr = [LPFCrashCaught lpf_getCrashLogs];
//    NSLog(@"%@", arr);
//     [self performSelector:NSSelectorFromString(@"write crash from model") withObject:nil afterDelay:10];
//
//    [self.segmentControl addSegmentWithTitle:@"Console" image:[UIImage imageNamed:@"rizhi"]];
//    [self.segmentControl addSegmentWithTitle:@"Crash" image:[UIImage imageNamed:@"yichang"]];
    
}


@end
