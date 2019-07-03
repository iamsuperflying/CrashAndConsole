//
//  RSLogMessage.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/25.
//  Copyright © 2019 李鹏飞. All rights reserved.
//
#import "RSLogMessage.h"
#import <UIKit/UIKit.h>

static inline UIColor * KDefaultTimeColor() {
    return rs_rgbColor(41, 204, 51);
}

@implementation RSLogMessage

- (NSString *)description {
    return rs_format(@"\n[%@]\n%@\n", self.time, self.message);
}

- (NSString *)debugDescription {
    return rs_format(@"\n[%@]\n%@\n", self.time, self.message);
}

- (void)setOriginalMessage:(NSString *)originalMessage {
    _originalMessage = originalMessage;
    
    /// processName[pid:threadId] (e.g. Log[18267:1471107])
    /// get threadId
    /// __uint64_t threadId;
    /// if (pthread_threadid_np(0, &threadId)) {
    ///   threadId = pthread_mach_thread_np(pthread_self());
    /// }
    NSString *idStr = rs_format(@"%@[%ld:", [NSProcessInfo processInfo].processName, (long) getpid());
    
    NSRange range = [originalMessage rangeOfString:idStr];
    NSRange pid_threadIdRange = [originalMessage rangeOfString:@"]"];
    NSString *message;
    if (range.location != NSNotFound) {
        message = [originalMessage substringFromIndex:pid_threadIdRange.location + 2];
    } else {
        message = originalMessage;
    }
    
    self.message = message;
    /// 截取时间 [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    self.time = [originalMessage substringToIndex:19];
    
    /** 开启自定义日期格式输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateTodo = [formatter dateFromString:self.time];
    self.time = [self.dateFormatter stringFromDate:dateTodo];
     */
    
    
    NSDictionary *timeAttributes =  @{NSForegroundColorAttributeName:KDefaultTimeColor(),
                                      NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSDictionary *messageAttributes =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                         NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSString *consoleLine = rs_format(@"%@  %@\n", self.time, message);

    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:consoleLine];
    [attrStringM addAttributes:timeAttributes range:NSMakeRange(0, self.time.length)];
    [attrStringM addAttributes:messageAttributes range:[consoleLine rangeOfString:message]];
    self.consoleLine = attrStringM;
}

#pragma mark - Lazy
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}

@end
