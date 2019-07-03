//
//  NSObject+Invocation.h
//
//  Description:
//
//  Created by LPF. on 2019/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Invocation)

/**
 * 方法调用注册
 *
 * @param selector 需要注册的方法
 */
- (NSInvocation *)rs_createInvocationWithSelector:(SEL)selector;

- (void)rs_invokeEvent:(nonnull NSInvocation *)invocation
              userInfo:(nullable NSDictionary *)userInfo;

- (id)rs_invokeEvent:(NSInvocation *)invocation
             objects:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END
