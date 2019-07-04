//
//  LPFCrashView.h
//
//  Description:
//
//  Created by LPF. on 2019/6/28.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"
@class LPFCrashInfo;

NS_ASSUME_NONNULL_BEGIN

RSExtern KCrashShareEventName;

@interface LPFCrashView : UIView

@property(nonatomic, strong) NSArray<LPFCrashInfo *> *crashes;

@end

NS_ASSUME_NONNULL_END
