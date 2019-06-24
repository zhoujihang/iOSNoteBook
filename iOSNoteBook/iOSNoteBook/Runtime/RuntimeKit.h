//
//  RuntimeKit.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - method swizzled

/**
 方法交换
 @param cls 目标类
 @param hookClassSelector 是否交换类方法，默认交换的实例方法
 @param fromSelector 被交换的方法
 @param toSelector 交换成目标方法
 */
FOUNDATION_EXTERN void zjh_hookClass(Class cls, bool hookClassSelector, SEL fromSelector, SEL toSelector);

/**
 遍历所有的类
 @param ^callback 回调
 */
FOUNDATION_EXTERN void zjh_enumerateAllClass(void (^callback)(Class cls));


NS_ASSUME_NONNULL_END
