//
//  LPFCrashInfo.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/29.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "LPFCrashInfo.h"
#import <objc/runtime.h>

@implementation LPFCrashInfo

- (NSDictionary *)lpf_toDict {
    
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else {
                [dict setObject:[value lpf_dict] forKey:key];
            }
        } else if (key && !value) {
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
    
}

-(NSDictionary *)lpf_dictWithModelClass {
    return @{@"exception": @"LPFException", @"deviceInfo": @"LPFDeviceInfo"};
}

- (LPFException *)exception {
    if (!_exception) {
        _exception = [[LPFException alloc] init];
    }
    return _exception;
}

- (LPFDeviceInfo *)deviceInfo {
    if (!_deviceInfo) {
        _deviceInfo = [[LPFDeviceInfo alloc] init];
    }
    return _deviceInfo;
}

@end

@implementation LPFDeviceInfo
@end

@implementation LPFException
@end


