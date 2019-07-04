//
//  LPFCrashInfo.h
//  Log
//
//  Created by 李鹏飞 on 2019/6/29.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ModelToDict.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPFDeviceInfo : NSObject

@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSString *platformVersion;
@property(nonatomic, strong) NSArray *deviceCapabilities;

@end

@interface LPFException : NSObject

@property(nonatomic, strong) NSArray *exceptioncallStachSymbols;
@property(nonatomic, strong) NSString *exceptionName;
@property(nonatomic, strong) NSString *exceptionReason;

@end

@interface LPFCrashInfo : NSObject

@property(nonatomic, strong) NSString *crashName;
@property(nonatomic, strong) LPFDeviceInfo *deviceInfo;
@property(nonatomic, strong) LPFException *exception;

- (NSAttributedString *)crash;

@end

NS_ASSUME_NONNULL_END
