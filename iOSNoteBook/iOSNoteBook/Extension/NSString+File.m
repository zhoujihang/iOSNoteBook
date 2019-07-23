//
//  NSString+File.m
//  XZTenant
//
//  Created by 周际航 on 2017/9/1.
//  Copyright © 2017年 xiaozhu.com. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

+ (NSString *)ext_documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)ext_cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)ext_tempDirectory {
    return NSTemporaryDirectory();
}

- (BOOL)ext_createDirectory {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self]) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil];
        return result;
    } else {
        return NO;
    }
}

- (NSString *)ext_fileContent {
    return [[NSString alloc] initWithContentsOfFile:self encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)ext_writeToFile:(NSString *)path {
    return [self writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)ext_removeItem {
    return [[NSFileManager defaultManager] removeItemAtPath:self error:nil];
}

- (BOOL)ext_isExistItem {
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (NSString *)ext_fileNameWithoutDirectory {
    NSArray *pathArr = [self componentsSeparatedByString:@"/"];
    NSString *fileName = pathArr.lastObject ?: self;
    return fileName;
}

- (NSString *)ext_directoryPathWithoutFileName {
    return [self stringByDeletingLastPathComponent];
}

- (NSString *)ext_appendingPathComponent:(NSString *)path {
    return [self stringByAppendingPathComponent:path];
}

- (NSString *)ext_appendToDocumentPath {
    NSString *documentPath = [NSString ext_documentDirectory];
    if (![self hasPrefix:documentPath]) {
        return [documentPath ext_appendingPathComponent:self];
    } else {
        return self;
    }
}
- (NSString *)ext_appendToCachesPath {
    NSString *cachesPath = [NSString ext_cachesDirectory];
    if (![self hasPrefix:cachesPath]) {
        return [cachesPath ext_appendingPathComponent:self];
    } else {
        return self;
    }
}
- (NSString *)ext_appendToTempPath {
    NSString *tempPath = [NSString ext_tempDirectory];
    if (![self hasPrefix:tempPath]) {
        return [tempPath ext_appendingPathComponent:self];
    } else {
        return self;
    }
}

- (NSArray<NSString *> *)ext_contentNameList {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self error:nil];
}

@end
