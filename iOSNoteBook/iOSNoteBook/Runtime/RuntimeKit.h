//
//  RuntimeKit.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef __LP64__
typedef struct mach_header mach_header_xx;
#else
typedef struct mach_header_64 mach_header_xx;
#endif

#pragma mark - method swizzled

/**
 方法交换
 @param cls 目标类
 @param hookClassSelector 是否交换类方法，默认交换的实例方法
 @param fromSelector 被交换的方法
 @param toSelector 交换成目标方法
 */
FOUNDATION_EXTERN void zjh_hookClass(Class cls, bool hookClassSelector, SEL fromSelector, SEL toSelector);

/// 遍历所有的类
FOUNDATION_EXTERN void zjh_enumerateAllClass(void (^callback)(Class cls));
/// 遍历所有的image
FOUNDATION_EXTERN void zjh_enumerateAllImage(void (^callback)(NSString *imagePath));
/// 遍历指定 image 中的 class
FOUNDATION_EXTERN void zjh_enumerateAllClassForImage(NSString *imagePath, void (^callback)(Class cls));
/// 遍历所有 image 中的 class
FOUNDATION_EXTERN void zjh_enumerateAllClassOrderbyImage(void (^callback)(NSString *image, Class cls));

/// 遍历MachO中记载的所有的 image
FOUNDATION_EXTERN void zjh_enumerateMachImages(void(^handler)(const mach_header_xx *mh, const char *path));
/// 遍历MachO中记载的所有的 image 在 section段 __objc_classlist 中存储的class记录
FOUNDATION_EXTERN void zjh_enumerateClassesInMachImage__objc_classlist(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass));
/// 遍历MachO中记载的所有的 image 在 section段 __objc_classrefs 中存储的class记录
FOUNDATION_EXTERN void zjh_enumerateClassesInMachImage__objc_classrefs(const mach_header_xx *mh, void(^handler)(Class __unsafe_unretained aClass));

/// 遍历协议中的方法
FOUNDATION_EXTERN void zjh_enumerateProtocol(Protocol *protocol, void (^handle)(SEL sel, BOOL isRequiredMethod, BOOL isInstanceMethod));

NS_ASSUME_NONNULL_END
