//
//  LPFCrashCaught.h
//
//  Description:
//
//  Created by LPF. on 2019/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPFCrashCaught : NSObject

+ (instancetype)catchCrashLogs;
+ (nullable NSArray *)lpf_getCrashLogs;
+ (NSString *)lpf_getCrashPath;
+ (BOOL)lpf_clearCrashLogs;

@end

NS_ASSUME_NONNULL_END
