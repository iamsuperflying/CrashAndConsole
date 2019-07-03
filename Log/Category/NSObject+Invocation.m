//
//  NSObject+Invocation.m
//
//  Description:
//
//  Created by LPF. on 2019/6/18.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)

- (NSInvocation *)rs_createInvocationWithSelector:(SEL)selector {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    if (!signature) {
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance", [self class], NSStringFromSelector(selector)];
        @throw [[NSException alloc] initWithName:@"remind:" reason:info userInfo:nil];
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    return  invocation;
}

- (void)rs_invokeEvent:(NSInvocation *)invocation userInfo:(NSDictionary *)userInfo {
    if (userInfo) {
        [invocation setArgument:&userInfo atIndex:2];
    }
    [invocation invoke];
}

- (id)rs_invokeEvent:(NSInvocation *)invocation objects:(NSArray *)objects {

    if (!invocation) {
        return nil;
    }
    NSMethodSignature *signature = invocation.methodSignature;
    /// 参数个数 signature.numberOfArguments
    /// 默认有一个_cmd 一个target 所以要 -2
    NSInteger paramsCount = signature.numberOfArguments - 2;
    // 当 objects 的个数多于函数的参数的时候, 取前面的参数
    // 当 objects 的个数少于函数的参数的时候, 不需要设置,默认为 nil
    paramsCount = MIN(paramsCount, objects.count);
    
    for (NSInteger index = 0; index < paramsCount; index ++) {
        id object = objects[index];
        // 对参数是nil的处理
        if (!object || [object isKindOfClass:[NSNull class]]) {
            continue;
        }
        [invocation setArgument:&object atIndex:index + 2];
    }
    
    [invocation invoke];
    id returnValue;
    if (signature.methodReturnLength) {
        //获取返回值
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

@end
