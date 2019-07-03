//
//  LPFExtendView.h
//  Log
//
//  Created by 李鹏飞 on 2019/6/27.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowBlock)(BOOL selected);

@interface LPFExtendView : UIView

@property(nonatomic, assign, getter=isShow) BOOL show;
@property(nonatomic, copy) ShowBlock block;

@end

NS_ASSUME_NONNULL_END
