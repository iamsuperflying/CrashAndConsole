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

+ (nullable instancetype)lpf_modelWithDictionary:(NSDictionary *)dictionary {
    
    id model = [[self alloc] init];
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName_C = property_getName(property);
        NSString *propertyName_OC = [NSString stringWithCString:propertyName_C encoding:NSUTF8StringEncoding];
        
        id value = dictionary[propertyName_OC];
        
        
        Class type = getPropertType(property);
        
        // 值是字典,成员属性的类型不是字典,才需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]]
            && ![NSStringFromClass(type) containsString:@"NS"]) {
            
            if(type) {
                value = [type lpf_modelWithDictionary:value];
            }
            
        }
        if (value) {
            [model setValue:value forKey:propertyName_OC];
        }
        
        
    }
    
    free(propertyList);
    
    return model;
    
    
    
}


Class getPropertType(objc_property_t property) {
    const char * type = property_getAttributes(property);
    NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
    NSArray *slices = [attr componentsSeparatedByString:@"\""];
    if ([attr hasPrefix:@"T@"] && slices.count > 1) {
        NSString * typeClassName = slices[1];
        return NSClassFromString(typeClassName);
    }
    return nil;
}

@end
