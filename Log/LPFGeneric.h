//
//  LPFGeneric.h
//  Log
//
//  Created by 李鹏飞 on 2019/6/29.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#ifndef LPFGeneric_h
#define LPFGeneric_h

#import <UIKit/UIKit.h>
#import <pthread.h>



CG_INLINE void dispatch_async_on_main_queue(void (^block)(void)) {
    
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

CG_INLINE NSString * rs_format(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return contentStr;
}

CG_INLINE void LogDebug(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSLog(@"%@", [[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

CG_INLINE void LogError(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSLog(@"Error: %@", [[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
}

//static inline NSFormatter * lpf_formatter() {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    formatter.locale = [NSLocale currentLocale];
//    return formatter;
//}

CG_INLINE UIColor *rs_rgbColor(CGFloat r, CGFloat g, CGFloat b) {
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];
}

CG_INLINE CGRect lpf_extendWindowDefaultFrame() {
    return CGRectMake(100, 100, 50, 50);
}

CG_INLINE CGFloat rs_screenWidth() {
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

CG_INLINE CGFloat rs_screenHeight() {
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

CG_INLINE BOOL rs_iPhoneXStyle() {
    return (rs_screenWidth() == 375.f && rs_screenHeight() == 812.f)
    || (rs_screenWidth() == 414.f && rs_screenHeight() == 896.f);
}

//CG_INLINE CGFloat rs_statusBarAndNavigationBarHeight() {
//    return rs_iPhoneXStyle() ? 88.f : 64.f;
//}
//
//CG_INLINE CGFloat rs_statusBarHeight() {
//    return rs_iPhoneXStyle() ? 44.f : 20.f;
//}

CG_INLINE CGFloat rs_bottomHeight() {
    return rs_iPhoneXStyle() ? 34.f : 0;
}

CG_INLINE CGRect rs_fullScreenFrame() {
    return CGRectMake(0, 0, rs_screenWidth(), rs_screenHeight());
}

#endif /* LPFGeneric_h */
