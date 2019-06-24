//
//  RuntimeTest.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeTest.h"
#import <objc/runtime.h>
#import "RuntimeKit.h"

@implementation RuntimeTestBaseClass

- (void)baseFunc {
    NSLog(@"zjh base");
}

@end

@implementation RuntimeTestSubClass

- (void)func1 {
    NSLog(@"zjh func1");
}
+ (void)classFunc {
    NSLog(@"zjh classFunc");
}

@end

@implementation RuntimeTestSubClass (Extension)

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


@implementation RuntimeTest

+ (void)load {
    /// 测试 实例方法交换
    zjh_hookClass([RuntimeTestSubClass class], false,@selector(func1), @selector(ext_func1));
    /// 测试 类方法交换
    zjh_hookClass(object_getClass([RuntimeTestSubClass class]), true, @selector(classFunc), @selector(ext_classFunc));
    /// 测试 子类未实现的父类方法交换
    zjh_hookClass([RuntimeTestSubClass class], false, @selector(baseFunc), @selector(ext_baseFunc));
}

+ (void)test {
    RuntimeTestSubClass *instance = [RuntimeTestSubClass new];
    [instance func1];
    NSLog(@"--------------");
    [RuntimeTestSubClass classFunc];
    NSLog(@"--------------");
    [instance baseFunc];
    NSLog(@"--------------");
    [[RuntimeTestBaseClass new] baseFunc];
}

@end
