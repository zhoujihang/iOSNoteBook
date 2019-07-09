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

#pragma mark - 遍历所有的类
void zjh_enumerateAllClass(void (^callback)(Class cls)) {
    if (!callback) {return;}
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
//    或
//    unsigned int numClasses = 0;
//    Class *classes = objc_copyClassList(&numClasses);
    
    for (NSInteger i=0; i < numClasses; i++) {
        Class cls = classes[i];
        if (!cls) {break;}
#if DEBUG
        // If `Zombie Objects` in Xcode Diagnostics is enabled, the last two classes may be not readable, there will be EXC_BAD_ACCESS. Disabling `Zombie Objects` can resolve it.
        Class superClass = class_getSuperclass(cls);
        if ((intptr_t)superClass > 0x5000000000000000) {continue;}
#endif
        if (cls) {callback(cls);}
    }
    free(classes);
}

#pragma mark - 遍历所有的image
void zjh_enumerateAllImage(void (^callback)(NSString *imagePath)) {
    unsigned int count = 0;
    const char **imgList = objc_copyImageNames(&count);
    for (unsigned int i=0; i<count; i++) {
        NSString* name = [NSString stringWithCString:imgList[i] encoding:NSUTF8StringEncoding];
        if (callback) {callback(name);}
    }
    free(imgList);
}

#pragma mark - 遍历指定 image 中的 class
void zjh_enumerateAllClassForImage(NSString *imagePath, void (^callback)(Class cls)) {
    unsigned int count = 0;
    const char **clsList = objc_copyClassNamesForImage([imagePath UTF8String], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:clsList[i]];
        Class cls = name.length > 0 ? NSClassFromString(name) : nil;
        if (cls && callback) {callback(cls);}
    }
    free(clsList);
}

#pragma mark - 遍历所有 image 中的 class
void zjh_enumerateAllClassOrderbyImage(void (^callback)(NSString *image, Class cls)) {
    zjh_enumerateAllImage(^(NSString *imagePath) {
        zjh_enumerateAllClassForImage(imagePath, ^(__unsafe_unretained Class cls) {
            if (callback) {callback(imagePath, cls);}
        });
    });
}
