//
//  NSObject+ModelToDict.m
//  Log
//
//  Created by 李鹏飞 on 2019/7/1.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "NSObject+ModelToDict.h"
#import <objc/runtime.h>

@implementation NSObject (ModelToDict)

- (NSDictionary *)lpf_dict {
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
        } else if (key && value == nil) {
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

- (id)idFromObject:(nonnull id)object {
    if ([object isKindOfClass:[NSArray class]]) {
        if (object && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                else {
                    [array addObject:[obj dictionary]];
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                else {
                    [dic setObject:[object[key] lpf_dict] forKey:key];
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}

+ (NSArray *)lpf_objcProperties {
    /* 获取关联对象 */
    NSArray *ptyList = objc_getAssociatedObject(self, _cmd);
    
    /* 如果 ptyList 有值,直接返回 */
    if (ptyList) {
        return ptyList;
    }
  
    unsigned int outCount = 0;
    /* retain, creat, copy 需要release */
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *mtArray = [NSMutableArray array];
    
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName_C = property_getName(property);
        NSString *propertyName_OC = [NSString stringWithCString:propertyName_C encoding:NSUTF8StringEncoding];
        [mtArray addObject:propertyName_OC];
    }

    objc_setAssociatedObject(self, _cmd, mtArray.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /* 释放 */
    free(propertyList);
    return mtArray.copy;
}

+ (instancetype)lpf_modelWithDict:(NSDictionary *)dict {

    id model = [[self alloc] init];
    
    NSArray *propertyList = [self lpf_objcProperties];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([propertyList containsObject:key]) {
        
            NSString *ivarType;
            
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                ivarType = @"NSString";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                ivarType = @"NSArray";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                ivarType = @"int";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                ivarType = @"NSDictionary";
            }
            
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) { //  是字典对象,并且属性名对应类型是自定义类型
                // value:user字典 -> User模型
                // 获取模型(user)类对象
                NSString *ivarType = [self lpf_dictWithModelClass][key];
                Class modalClass = NSClassFromString(ivarType);

                // 字典转模型
                if (modalClass) {
                    // 字典转模型 user
                    obj = [modalClass lpf_modelWithDict:obj];
                }

            }

//            // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
//            // 判断值是否是数组
//            if ([obj isKindOfClass:[NSArray class]]) {
//                // 判断对应类有没有实现字典数组转模型数组的协议
//                if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
//
//                    // 转换成id类型，就能调用任何对象的方法
//                    id idSelf = self;
//
//                    // 获取数组中字典对应的模型
//                    NSString *type =  [idSelf arrayContainModelClass][key];
//
//                    // 生成模型
//                    Class classModel = NSClassFromString(type);
//                    NSMutableArray *arrM = [NSMutableArray array];
//                    // 遍历字典数组，生成模型数组
//                    for (NSDictionary *dict in obj) {
//                        // 字典转模型
//                        id model =  [classModel lpf_modelWithDict:dict];
//                        [arrM addObject:model];
//                    }
//
//                    // 把模型数组赋值给value
//                    obj = arrM;
//
//                }
//            }
            
            // KVC字典转模型
            if (obj) {
                /* 说明属性存在,可以使用 KVC 设置数值 */
                [model setValue:obj forKey:key];
            }
        }
        
    }];
    
    /* 返回对象 */
    return model;
}

@end
