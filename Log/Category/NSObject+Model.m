//
//  NSObject+Model.m
//  07-Runtime(字典转模型)(了解)
//
//  Created by xiaomage on 15/10/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "NSObject+Model.h"

#import <objc/message.h>
/*
 Ivar ivar1;
 Ivar ivar2;
 Ivar ivar3;
 Ivar a[] = {ivar3,ivar1,ivar2};
 Ivar *ivar = &a;

 */
@implementation NSObject (Model)
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    
    // 1.创建对应类的对象
    id objc = [[self alloc] init];
    
    // runtime:遍历模型中所有成员属性,去字典中查找
    // 属性定义在哪,定义在类,类里面有个属性列表(数组)
    
    // 遍历模型所有成员属性
    // ivar:成员属性
    // class_copyIvarList:把成员属性列表复制一份给你
    // Ivar *:指向Ivar指针
    // Ivar *:指向一个成员变量数组
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员名
       NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ;
        

        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        
        // user value:字典
        // 获取字典的value
        id value = dict[key];
        // 给模型的属性赋值
        // value:字典的值
        // key:属性名
        
        // 成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // user:NSDictionary
        // 二级转换
        // 值是字典,成员属性的类型不是字典,才需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) { // 需要字典转换成模型
            // 转换成哪个类型
            
            // @"@\"User\"" User
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            // User\"";
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            
            // 字符串截取
            
            // 获取需要转换类的类对象
        
           Class modelClass =  NSClassFromString(propertyType);
        
            if (modelClass) {
                value =  [modelClass modelWithDict:value];
                
            }
        }
        
        if (value) {
            // KVC赋值:不能传空
            [objc setValue:value forKey:key];
            
        }

    }
    
    
    return objc;
}
@end
