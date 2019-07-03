//
//  NSObject+ModelToDict.h
//  Log
//
//  Created by 李鹏飞 on 2019/7/1.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPFModelToDict <NSObject>

@optional
-(NSDictionary *)lpf_dictWithModelClass;

@end


@interface NSObject (ModelToDict)<LPFModelToDict>

- (NSDictionary *)lpf_dict;
- (id)idFromObject:(nonnull id)object;
+ (instancetype)lpf_modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
