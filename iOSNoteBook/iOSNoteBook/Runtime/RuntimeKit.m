//
//  RuntimeKit.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeKit.h"
#import <objc/runtime.h>
#import <mach-o/getsect.h>
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

#pragma mark - MachO 文件
void zjh_enumerateMachImages(void(^handler)(const mach_header_xx *mh, const char *path)) {
    if (handler == nil) {return;}
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        handler((const mach_header_xx *)_dyld_get_image_header(i), _dyld_get_image_name(i));
    }
}

void zjh_enumerateClassesInMachImage(const mach_header_xx *mh, const char *sectionName, void(^handler)(Class __unsafe_unretained aClass)) {
    if (handler == nil) {return;}
#ifndef __LP64__
    const struct section *section = getsectbynamefromheader(mh, "__DATA", sectionName);
    if (section == NULL) {return;}
    uint32_t size = section->size;
#else
    const struct section_64 *section = getsectbynamefromheader_64(mh, "__DATA", sectionName);
    if (section == NULL) {return;}
    uint64_t size = section->size;
#endif
    char *imageBaseAddress = (char *)mh;
    Class *classReferences = (Class *)(void *)(imageBaseAddress + ((uintptr_t)section->offset&0xffffffff));
    NSInteger count = size/sizeof(void *);
    for (unsigned long i = 0; i < count; i++) {
        Class aClass = classReferences[i];
        if (aClass) {handler(aClass);}
    }
}

void zjh_enumerateClassesInMachImage__objc_classlist(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass)) {
    zjh_enumerateClassesInMachImage(mh, "__objc_classlist", handler);
}
void zjh_enumerateClassesInMachImage__objc_classrefs(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass)) {
//    NSArray *ignoreList = @[@"/Applications/Xcode.app/", @"/usr/lib/", @"/System/Library/", @"/Developer/Library/"];
    /// 遍历 __objc_classrefs 时，有许多系统 image 读取 class 结构时会崩溃，需要过滤。
    zjh_enumerateClassesInMachImage(mh, "__objc_classrefs", handler);
}

void zjh_enumerateProtocol(Protocol *protocol, void (^handle)(SEL sel, BOOL isRequiredMethod, BOOL isInstanceMethod)) {
    if (!handle) {return;}
    unsigned int count = 0;
    struct objc_method_description *list1 = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
    for (unsigned int i=0; i<count; i++) {handle(list1[i].name, YES, YES);}
    struct objc_method_description *list2 = protocol_copyMethodDescriptionList(protocol, YES, NO, &count);
    for (unsigned int i=0; i<count; i++) {handle(list2[i].name, YES, NO);}
    struct objc_method_description *list3 = protocol_copyMethodDescriptionList(protocol, NO, YES, &count);
    for (unsigned int i=0; i<count; i++) {handle(list3[i].name, NO, YES);}
    struct objc_method_description *list4 = protocol_copyMethodDescriptionList(protocol, NO, NO, &count);
    for (unsigned int i=0; i<count; i++) {handle(list4[i].name, NO, NO);}
    free(list1);
    free(list2);
    free(list3);
    free(list4);
}
