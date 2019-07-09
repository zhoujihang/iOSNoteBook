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
    [self teardown];
}

+ (void)setup {
    [[self rootDir] xz_createDirectory];
    NSLog(@"zjh rootDir:%@", [self rootDir]);
}
+ (void)teardown {
    dispatch_async(dispatch_get_main_queue(), ^{
        FileListViewController *vc = [[FileListViewController alloc] init];
        vc.fileList = [self filePathList];
        [[UIWindow getActiveController].navigationController pushViewController:vc animated:YES];
    });
}

+ (NSString *)rootDir {
    return [NSString xz_tempDirectory];
}
+ (NSArray<NSString *> *)filePathList {
    return @[
             [[self rootDir] xz_appendingPathComponent:@"AllClass.txt"],
             [[self rootDir] xz_appendingPathComponent:@"AllImage.txt"],
             [[self rootDir] xz_appendingPathComponent:@"AllImage_Class.txt"],
             [[self rootDir] xz_appendingPathComponent:@"AllCustomImage_Class.txt"]
             ];
}

+ (void)printAllClass {
    NSString *filePath = [[self rootDir] xz_appendingPathComponent:@"AllClass.txt"];
    NSMutableArray *marr = [@[] mutableCopy];
    zjh_enumerateAllClass(^(Class  _Nonnull __unsafe_unretained cls) {
        [marr addObject:NSStringFromClass(cls)];
    });
    [[marr componentsJoinedByString:@"\n"] xz_writeToFile:filePath];
}

+ (void)printAllImage {
    NSString *filePath = [[self rootDir] xz_appendingPathComponent:@"AllImage.txt"];
    NSMutableArray *marr = [@[] mutableCopy];
    zjh_enumerateAllImage(^(NSString * _Nonnull imagePath) {
        [marr addObject:imagePath];
    });
    [[marr componentsJoinedByString:@"\n\n"] xz_writeToFile:filePath];
}

+ (void)printAllClassOrderbyImage {
    NSString *filePath = [[self rootDir] xz_appendingPathComponent:@"AllImage_Class.txt"];
    NSDictionary *dic = [self generateClassListByImageExclude:nil includeList:nil];
    NSMutableString *mstr = [@"" mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        [mstr appendString:[NSString stringWithFormat:@"%@\n", key]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr xz_writeToFile:filePath];
}

+ (void)printAllCustomClassOrderbyImage {
    NSString *filePath = [[self rootDir] xz_appendingPathComponent:@"AllCustomImage_Class.txt"];
    NSDictionary *dic = [self generateClassListByImageExclude:@[@"/Applications/Xcode.app/", @"/usr/lib/", @"/System/Library/", @"/Developer/Library/"] includeList:nil];
    NSMutableString *mstr = [@"" mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSArray *list = dic[key];
        [mstr appendString:[NSString stringWithFormat:@"%@\n", key]];
        [mstr appendString:@"        "];
        [mstr appendString:[list componentsJoinedByString:@"\n        "]];
        [mstr appendString:@"\n\n"];
    }
    [mstr xz_writeToFile:filePath];
}

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

@end
