//
//  RSLogsView.h
//  Log
//
//  Created by 李鹏飞 on 2019/6/25.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFGeneric.h"
@class RSLogMessage;

// 636366

NS_ASSUME_NONNULL_BEGIN

typedef NSArray<RSLogMessage *> * _Nonnull (^UpdateLogsBlock)(void);

@interface RSConsole : UIView

@property(nonatomic, assign, readonly, getter=isShow) BOOL show;
@property (nonatomic, copy) UpdateLogsBlock update;

+ (instancetype)console;
+ (void)show;
+ (void)hide;
- (void)updateLogs:(NSArray<RSLogMessage *> *)logs;

@end

NS_ASSUME_NONNULL_END
