//
//  RSDebugView.m
//
//  Description:
//
//  Created by LPF. on 2019/6/25.
//

#import "RSDebugView.h"
#import "RSLogMessage.h"
#import "LPFGeneric.h"
#import "RSConsole.h"
#import <asl.h>
#import "LPFConsoleCrashController.h"
#import "LPFExtendView.h"
#import "UIView+Extension.h"
#import "LPFRootViewController.h"

@interface SystemLogMessage : NSObject

@property(nonatomic, assign) NSTimeInterval timeInterval;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, copy) NSString *sender;
@property(nonatomic, copy) NSString *messageText;
@property(nonatomic, assign) long long messageID;

@end

@implementation SystemLogMessage

//// 从日志的对象aslmsg中获取我们需要的数据
//+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage{
//    SystemLogMessage *logMessage = [[SystemLogMessage alloc] init];
//    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
//    if (timestamp) {
//        NSTimeInterval timeInterval = [@(timestamp) integerValue];
//        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
//        if (nanoseconds) {
//            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
//        }
//        logMessage.timeInterval = timeInterval;
//        logMessage.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    }
//    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
//    if (sender) {
//        logMessage.sender = @(sender);
//    }
//    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
//    if (messageText) {
//        logMessage.messageText = @(messageText);//NSLog写入的文本内容
//    }
//    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
//    if (messageID) {
//        logMessage.messageID = [@(messageID) longLongValue];
//    }
//    return logMessage;
//}

@end

@interface RSDebugView ()

@property(nonatomic, strong) UILabel                 *dateLabel;
@property(nonatomic, strong) NSDateFormatter         *dateFormatter;
@property(nonatomic, strong) dispatch_source_t       source_t;
@property(nonatomic, copy)   NSString                *logFilePath;
@property(nonatomic, copy)   NSArray<RSLogMessage *> *logs;
@property(nonatomic, strong) LPFExtendView           *extendView;
@property(nonatomic, strong) LPFRootViewController   *rootController;

@end

@implementation RSDebugView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
        [self setUpUI];
        [self setUpLayout];
//        [self redirectNSlogToDocumentFolder];
        [self setPortToMonitorAppleLogs];
    }
    return self;
}

- (void)setUp {
#if DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.windowLevel = UIWindowLevelAlert + 1;
        
        self.rootController = [[LPFRootViewController alloc] init];
//        self.frame = [UIScreen mainScreen].bounds;
        
        self.logs = [NSArray array];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        [self makeKeyAndVisible];
    });
#endif
}

- (void)setUpUI {
    self.backgroundColor = [UIColor clearColor];
    self.extendView = [[LPFExtendView alloc] init];
    self.extendView.backgroundColor = [UIColor redColor];
    [self addSubview:self.extendView];
    [self addSubview:self.dateLabel];
    
    self.extendView.block = ^(BOOL selected) {
        if (selected) {
            self.size = CGSizeMake(201, self.height);
        } else {
            self.size = CGSizeMake(50, self.height);
        }
    };
    
}
#pragma mark - 将NSLog的输出信息写入到log文件中，并输出为log文件
// 将NSLog打印信息保存到Documents目录下的文件中
- (void)redirectNSlogToDocumentFolder {
    // 存于Document文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.log",[[NSDate alloc] initWithTimeIntervalSinceNow:8*3600]];
    _logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 将log输入到文件
    freopen([_logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (void)readFile {
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:_logFilePath encoding:NSUTF8StringEncoding error: &error];
    if (textFileContents == nil) {
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
       }
    NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
    NSLog(@"%@", lines);
}

- (void)setUpLayout {
    
    self.frame = lpf_extendWindowDefaultFrame();
    self.extendView.frame = self.bounds;
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(16);
//        make.right.mas_offset(10);
//        make.top.bottom.mas_offset(0);
//    }];

    [self addConstraintsWithVF:@"H:|[extendView]|" metrics:nil views:@{@"extendView" : self.extendView}];
    
    [self addConstraintsWithVF:@"V:|[extendView]|" metrics:nil views:@{@"extendView" : self.extendView}];
    
//    self.dateLabel.frame = CGRectMake(100, 100, 120, 50);
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
    //    self.frame = CGRectMake(16, 0, CGRectGetWidth(self.frame) - 32, CGRectGetHeight(self.frame));
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetHeight(frame) * 0.5;
    self.clipsToBounds = YES;
}

- (void)tap:(UITapGestureRecognizer *)ges {
    
    [self readLogs];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(2, 2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
    
}

- (void)setPortToMonitorAppleLogs {
    // asl is replaced by os_log after ios 10.0, so we should judge system version
    if (@available(iOS 10_0, *)) {
        if (self.source_t) {
            dispatch_cancel(self.source_t);
        }

        int fd = STDERR_FILENO;
        int origianlFD = fd;
        int originalStdHandle = dup(fd); // save the original for reset

        int fildes[2];
        pipe(fildes);  // [0] is read end of pipe while [1] is write end
        dup2(fildes[1], fd);  // duplicate write end of pipe "onto" fd (this closes fd)
        close(fildes[1]);  // close original write end of pipe
        fd = fildes[0];  // we can now monitor the read end of the pipe

        NSMutableData* receivedData = [[NSMutableData alloc] init];
        fcntl(fd, F_SETFL, O_NONBLOCK);// set the reading of this file descriptor without delay

        dispatch_queue_t highPriorityGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_source_t source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, highPriorityGlobalQueue);

        int writeEnd = fildes[1];
        dispatch_source_set_cancel_handler(source_t, ^{
            close(writeEnd);
            // reset the original file descriptor
            dup2(originalStdHandle, origianlFD);
        });
        
        /// 分割前后
        __uint64_t threadId;
        if (pthread_threadid_np(0, &threadId)) {
            threadId = pthread_mach_thread_np(pthread_self());
        }

        dispatch_source_set_event_handler(source_t, ^{
            @autoreleasepool {
                char buffer[1024 * 8];
                ssize_t size = read(fd, (void*)buffer, (size_t)(sizeof(buffer)));

                [receivedData setLength:0];
                [receivedData appendBytes:buffer length:size];

                NSString *logMessage = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                if (logMessage) {
                    RSLogMessage *log = [[RSLogMessage alloc] init];
                    log.originalMessage = logMessage;
                    log.id = @"NO MSG ID";
                    
                    dispatch_async_on_main_queue(^{
                        NSMutableArray *currentLogs = [self.logs mutableCopy];
                        [currentLogs addObject:log];
                        self.logs = currentLogs;
                    });
                    // print on STDOUT_FILENO，so that the log can still print on xcode console
                    printf("%s\n",[logMessage UTF8String]);
                }
            }
        });

        dispatch_resume(source_t);

        self.source_t = source_t;
    }
}

- (void)readLogs {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    
    [keyWindow addSubview:self.rootController.view];
    self.rootController.view.frame = CGRectMake(0, 300, keyWindow.width, keyWindow.height - 300);
    
}

//- (NSMutableArray<SystemLogMessage *> *)allLogMessagesForCurrentProcess{
//    asl_object_t query = asl_new(ASL_TYPE_QUERY);
//    // Filter for messages from the current process. Note that this appears to happen by default on device, but is required in the simulator.
//    NSString *pidString = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
//    asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
//
//    aslresponse response = asl_search(NULL, query);
//    aslmsg aslMessage = NULL;
//
//    NSMutableArray *logMessages = [NSMutableArray array];
//    while ((aslMessage = asl_next(response))) {
//        [logMessages addObject:[SystemLogMessage logMessageFromASLMessage:aslMessage]];
//    }
//    asl_release(response);
//
//    return logMessages;
//}

#pragma mark -Setter
- (void)setLogs:(NSArray<RSLogMessage *> *)logs {
    _logs = logs;
    if ([RSConsole sharedConsole].isShow) {
        [[RSConsole sharedConsole] updateLogs:logs];
    }
}

#pragma mark - Lazy
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss:SSS";
    }
    return _dateFormatter;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.numberOfLines = 0;
        NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"buildTime"];
//        if (!date) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd";
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"HH:mm:ss";
    
            date = rs_format(@"%@\ntime: %@", [dateFormatter stringFromDate:[NSDate date]], [timeFormatter stringFromDate:[NSDate date]]);
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"buildTime"];
//        }
        
        NSString *ver = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        
        _dateLabel.text = rs_format(@"version：%@ 测试\nbuild: %@", ver, date);
        
    }
    return _dateLabel;
}

@end
