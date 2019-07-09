//
//  RuntimeTest.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeSelectorTest.h"
#import <objc/runtime.h>
#import "RuntimeKit.h"

@implementation RuntimeSelectorTest_BaseClass

- (void)baseFunc {
    NSLog(@"zjh base");
}

@end

@implementation RuntimeSelectorTest_SubClass

- (void)func1 {
    NSLog(@"zjh func1");
}
+ (void)classFunc {
    NSLog(@"zjh classFunc");
}

@end

@implementation RuntimeSelectorTest_SubClass (Extension)

- (void)ext_func1 {
    NSLog(@"zjh ext_func1");
    [self ext_func1];
}
- (void)ext_baseFunc {
    NSLog(@"zjh ext_baseFunc");
    [self ext_baseFunc];
}
+ (void)ext_classFunc {
    NSLog(@"zjh ext_classFunc");
    [self ext_classFunc];
}

@end


@implementation RuntimeSelectorTest

+ (void)load {
    /// 测试 实例方法交换
    zjh_hookClass([RuntimeSelectorTest_SubClass class], false,@selector(func1), @selector(ext_func1));
    /// 测试 类方法交换
    zjh_hookClass(object_getClass([RuntimeSelectorTest_SubClass class]), true, @selector(classFunc), @selector(ext_classFunc));
    /// 测试 子类未实现的父类方法交换
    zjh_hookClass([RuntimeSelectorTest_SubClass class], false, @selector(baseFunc), @selector(ext_baseFunc));
}

+ (void)test {
    RuntimeSelectorTest_SubClass *instance = [RuntimeSelectorTest_SubClass new];
    [instance func1];
    NSLog(@"--------------");
    [RuntimeSelectorTest_SubClass classFunc];
    NSLog(@"--------------");
    [instance baseFunc];
    NSLog(@"--------------");
    [[RuntimeSelectorTest_BaseClass new] baseFunc];
}

@end
