//
//  RSLogMessage.h
//  Log
//
//  Created by 李鹏飞 on 2019/6/25.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPFGeneric.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSLogMessage : NSObject

@property (nonatomic, copy)   NSString           *id;
@property (nonatomic, copy)   NSString           *time;
@property (nonatomic, copy)   NSString           *message;
@property (nonatomic, copy)   NSString           *originalMessage;
@property (nonatomic, copy)   NSAttributedString *consoleLine;
@property (nonatomic, strong) NSDateFormatter    *dateFormatter;
@property (nonatomic, strong) UIColor            *timeColor;
@property (nonatomic, strong) UIColor            *logColor;

@end

NS_ASSUME_NONNULL_END
