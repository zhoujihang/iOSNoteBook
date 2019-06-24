//
//  RuntimeKit.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeKit.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

void zjh_hookClass(Class cls, bool hookClassSelector, SEL fromSelector, SEL toSelector) {
    Class targetCls = hookClassSelector ? object_getClass(cls) : cls;
    Method fromMethod = class_getInstanceMethod(targetCls, fromSelector);
    Method toMethod = class_getInstanceMethod(targetCls, toSelector);
    
    // 此处为何要先在 class 中添加方法，而不能直接交换？
    // 原因是为了避免交换了父类中的方法实现，导致父类被污染。
    if (class_addMethod(targetCls, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(targetCls, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

void zjh_enumerateAllClass(void (^callback)(Class cls)) {
    
}

