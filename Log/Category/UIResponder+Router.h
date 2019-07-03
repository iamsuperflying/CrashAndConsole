//
//  UIResponder+Router.h
//
//  Description:
//
//  Created by LPF. on 2019/6/18.
//

#import <UIKit/UIKit.h>
#import "NSObject+Invocation.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * const RSConstString;

/**
 * extern String
 *
 * EventName KClassNameFunctionNameEventName
 * example: KCellButtonClickEventName
 */
#define RSExtern extern RSConstString

@interface UIResponder (Router)

/**
 * 传递事件
 *
 * 事件会自动沿着默认的响应链
 * FirstResponder -> UIView -> UIViewController -> UIWindow -> UIApplacation
 * 往下传递
 * 响应者重写该方法即拦截响应
 * 继续发送则需调用 [super rs_routerEventWithName: objects:].
 *
 * @param eventName 事件名称
 * @param objects   参数列表, 需与方法参数列表一一对应
 */
- (void)rs_routerEventWithName:(nonnull NSString *)eventName
                       objects:(nullable NSArray *)objects;


@end

NS_ASSUME_NONNULL_END
