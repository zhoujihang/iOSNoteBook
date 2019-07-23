//
//  RuntimeClassTest.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/9.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeClassTest.h"
#import "RuntimeKit.h"
#import "FileListViewController.h"

@implementation RuntimeClassTest

+ (void)test {
    [self setup];
    [self printAllClass];
    [self printAllImage];
    [self printAllClassOrderbyImage];
    [self printAllCustomClassOrderbyImage];
    [self printAllClassOrderbyImageInMach__objc_classlist];
    [self printAllClassOrderbyImageInMach__objc_classrefs];
    [self compareAllClassBetween__objc_classlistAnd__objc_classrefs];
    [self teardown];
}

+ (void)setup {
    [[self rootDir] ext_createDirectory];
    NSLog(@"zjh rootDir:%@", [self rootDir]);
}
+ (void)teardown {
    dispatch_async(dispatch_get_main_queue(), ^{
        FileListViewController *vc = [[FileListViewController alloc] init];
        vc.fileList = [self filePathList];
        [[UIWindow ext_getActiveController].navigationController pushViewController:vc animated:YES];
    });
}

+ (NSString *)rootDir {
    return [NSString ext_tempDirectory];
}
+ (NSArray<NSString *> *)filePathList {
    return @[
             [[self rootDir] ext_appendingPathComponent:@"AllClass.txt"],
             [[self rootDir] ext_appendingPathComponent:@"AllImage.txt"],
             [[self rootDir] ext_appendingPathComponent:@"AllImage_Class.txt"],
             [[self rootDir] ext_appendingPathComponent:@"AllCustomImage_Class.txt"],
             [[self rootDir] ext_appendingPathComponent:@"AllImage_Class_Mach__objc_classlist.txt"],
             [[self rootDir] ext_appendingPathComponent:@"AllImage_Class_Mach__objc_classrefs.txt"],
             [[self rootDir] ext_appendingPathComponent:@"compare__objc_classlistAnd__objc_classrefs.txt"]
             ];
}

#pragma mark - 打印所有运行时的类
+ (void)printAllClass {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllClass.txt"];
    NSMutableArray *marr = [@[] mutableCopy];
    zjh_enumerateAllClass(^(Class  _Nonnull __unsafe_unretained cls) {
        [marr addObject:NSStringFromClass(cls)];
    });
    NSMutableString *mstr = [@"" mutableCopy];
    [mstr appendFormat:@"class count:%ld\n\n", marr.count];
    [mstr appendString:[marr componentsJoinedByString:@"\n"]];
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 打印所有镜像
+ (void)printAllImage {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllImage.txt"];
    NSMutableArray *marr = [@[] mutableCopy];
    zjh_enumerateAllImage(^(NSString * _Nonnull imagePath) {
        [marr addObject:imagePath];
    });
    NSMutableString *mstr = [@"" mutableCopy];
    [mstr appendFormat:@"image count:%ld\n\n", marr.count];
    [mstr appendString:[marr componentsJoinedByString:@"\n\n"]];
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 打印 运行时 所有的类（分类到各自镜像）
+ (void)printAllClassOrderbyImage {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllImage_Class.txt"];
    NSDictionary *dic = [self generateClassListByImageExclude:nil includeList:nil];
    NSMutableString *mstr = [@"" mutableCopy];
    [mstr appendFormat:@"image count:%ld\n\n", dic.allKeys.count];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        [mstr appendString:[NSString stringWithFormat:@"%@  count:%ld\n", key, list.count]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 打印 运行时 工程中定义的类（分类到各自镜像）
+ (void)printAllCustomClassOrderbyImage {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllCustomImage_Class.txt"];
    NSDictionary *dic = [self generateClassListByImageExclude:@[@"/Applications/Xcode.app/", @"/usr/lib/", @"/System/Library/", @"/Developer/Library/"] includeList:nil];
    NSMutableString *mstr = [@"" mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        [mstr appendString:[NSString stringWithFormat:@"%@  count:%ld\n", key, list.count]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 打印工程镜像在  __objc_classlist 段中类
+ (void)printAllClassOrderbyImageInMach__objc_classlist {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllImage_Class_Mach__objc_classlist.txt"];
    NSDictionary *dic = [self generateMachClassListByImageInSection__objc_classlist];
    NSMutableString *mstr = [@"" mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        if (list.count == 0) {continue;}
        [mstr appendString:[NSString stringWithFormat:@"%@\n  count:%ld\n", key, list.count]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr ext_writeToFile:filePath];
}
#pragma mark - 打印工程镜像在  __objc_classrefs 段中类
+ (void)printAllClassOrderbyImageInMach__objc_classrefs {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"AllImage_Class_Mach__objc_classrefs.txt"];
    NSDictionary *dic = [self generateMachClassListByImageInSection__objc_classrefs];
    NSMutableString *mstr = [@"" mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        if (list.count == 0) {continue;}
        [mstr appendString:[NSString stringWithFormat:@"%@\n  count:%ld\n", key, list.count]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 比较 __objc_classlist 和 __objc_classrefs 的差异
+ (void)compareAllClassBetween__objc_classlistAnd__objc_classrefs {
    NSString *filePath = [[self rootDir] ext_appendingPathComponent:@"compare__objc_classlistAnd__objc_classrefs.txt"];
    NSDictionary *dic1 = [self generateMachClassListByImageInSection__objc_classlist];
    NSDictionary *dic2 = [self generateMachClassListByImageInSection__objc_classrefs];
    NSString *executablePath = [[NSBundle mainBundle] executablePath];
    NSArray *classlist = dic1[executablePath];
    NSArray *classrefs = dic2[executablePath];
    NSMutableArray *existList = [@[] mutableCopy];
    NSMutableArray *unique_classlist = [@[] mutableCopy];
    NSMutableArray *unique_classrefs = [@[] mutableCopy];
    NSMutableDictionary *mdic = [@{} mutableCopy];
    for (NSString *item in classlist) {
        mdic[item] = item;
    }
    for (NSString *item in classrefs) {
        NSString *value = mdic[item];
        if (value.length > 0) {
            [existList addObject:item];
            mdic[item] = nil;
        } else {
            [unique_classrefs addObject:item];
        }
    }
    [unique_classlist addObjectsFromArray:mdic.allKeys];
    NSMutableString *mstr = [@"" mutableCopy];
    [mstr appendFormat:@"__objc_classlist 独有 %ld\n", unique_classlist.count];
    for (NSString *item in unique_classlist) {
        [mstr appendFormat:@"        %@\n", item];
    }
    [mstr appendString:@"\n\n"];
    [mstr appendFormat:@"__objc_classrefs 独有 %ld\n", unique_classrefs.count];
    for (NSString *item in unique_classrefs) {
        [mstr appendFormat:@"        %@\n", item];
    }
    [mstr appendString:@"\n\n"];
    [mstr appendFormat:@"__objc_classlist 与 __objc_classrefs 都有 %ld\n", existList.count];
    for (NSString *item in existList) {
        [mstr appendFormat:@"        %@\n", item];
    }
    [mstr ext_writeToFile:filePath];
}

#pragma mark - 获取运行时所有的image和class，提供过滤数组
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)generateClassListByImageExclude:(NSArray<NSString *> *)excludeList includeList:(NSArray<NSString *> *)includeList {
    NSMutableDictionary<NSString *, NSMutableArray *> *mdic = [@{} mutableCopy];
    zjh_enumerateAllClassOrderbyImage(^(NSString * _Nonnull image, Class  _Nonnull __unsafe_unretained cls) {
        if (image.length == 0) {return;}
        /// 过滤 image
        if (excludeList.count > 0) {
            for (NSString *item in excludeList) {if ([image containsString:item]) {return;}}
        }
        if (includeList.count > 0) {
            BOOL isContain = NO;
            for (NSString *item in includeList) {
                isContain = [item containsString:image];
            }
            if (!isContain) {return;}
        }
        /// 保存
        NSMutableArray *marr = mdic[image] ?: [@[] mutableCopy];
        if (!mdic[image]) {mdic[image] = marr;}
        [marr addObject:NSStringFromClass(cls)];
    });
    return [mdic copy];
}

#pragma mark - 获取 macho 中 __objc_classlist 段里的内容（过滤了系统镜像）
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)generateMachClassListByImageInSection__objc_classlist {
    NSArray *ignoreList = @[@"/Applications/Xcode.app/", @"/usr/lib/", @"/System/Library/", @"/Developer/Library/"];
    NSMutableDictionary<NSString *, NSMutableArray *> *mdic = [@{} mutableCopy];
    zjh_enumerateMachImages(^(const mach_header_xx * _Nonnull mh, const char * _Nonnull path) {
        NSString *image = [NSString stringWithUTF8String:path];
        NSMutableArray *marr = mdic[image] ?: [@[] mutableCopy];
        if (!mdic[image]) {mdic[image] = marr;}
        NSString *pathStr = [NSString stringWithUTF8String:path];
        for (NSString *item in ignoreList) {
            if ([pathStr containsString:item]) {
                return;
            }
        }
        zjh_enumerateClassesInMachImage__objc_classlist(mh, ^(__unsafe_unretained Class  _Nonnull aClass) {
            [marr addObject:NSStringFromClass(aClass)];
        });
    });
    return [mdic copy];
}

#pragma mark - 获取 macho 中 __objc_classrefs 段里的内容（过滤了系统镜像）
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)generateMachClassListByImageInSection__objc_classrefs {
    NSMutableDictionary<NSString *, NSMutableArray *> *mdic = [@{} mutableCopy];
    NSArray *ignoreList = @[@"/Applications/Xcode.app/", @"/usr/lib/", @"/System/Library/", @"/Developer/Library/"];
    /// 遍历 __objc_classrefs 时，有许多系统 image 读取 class 结构时会崩溃，所以干脆把以上都过滤了。
    zjh_enumerateMachImages(^(const mach_header_xx * _Nonnull mh, const char * _Nonnull path) {
        NSString *image = [NSString stringWithUTF8String:path];
        NSMutableArray *marr = mdic[image] ?: [@[] mutableCopy];
        if (!mdic[image]) {mdic[image] = marr;}
        NSString *pathStr = [NSString stringWithUTF8String:path];
        for (NSString *item in ignoreList) {
            if ([pathStr containsString:item]) {
                return;
            }
        }
        zjh_enumerateClassesInMachImage__objc_classrefs(mh, ^(__unsafe_unretained Class  _Nonnull aClass) {
            [marr addObject:NSStringFromClass(aClass)];
        });
    });
    return [mdic copy];
}


@end
