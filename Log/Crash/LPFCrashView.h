//
//  LPFCrashView.h
//
//  Description:
//
//  Created by LPF. on 2019/6/28.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"

NS_ASSUME_NONNULL_BEGIN

RSExtern KCrashShareEventName;

@interface LPFCrashView : UIView

@property(nonatomic, strong) NSArray<NSDictionary *> *crashes;

@end

NS_ASSUME_NONNULL_END
