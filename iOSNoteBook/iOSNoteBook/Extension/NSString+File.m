//
//  NSString+File.m
//  XZTenant
//
//  Created by 周际航 on 2017/9/1.
//  Copyright © 2017年 xiaozhu.com. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

+ (NSString *)xz_documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)xz_cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)xz_tempDirectory {
    return NSTemporaryDirectory();
}

- (BOOL)xz_createDirectory {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self]) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil];
        return result;
    } else {
        return NO;
    }
}

- (NSString *)xz_fileContent {
    return [[NSString alloc] initWithContentsOfFile:self encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)xz_writeToFile:(NSString *)path {
    return [self writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)xz_removeItem {
    return [[NSFileManager defaultManager] removeItemAtPath:self error:nil];
}

- (BOOL)xz_isExistItem {
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (NSString *)xz_fileNameWithoutDirectory {
    NSArray *pathArr = [self componentsSeparatedByString:@"/"];
    NSString *fileName = pathArr.lastObject ?: self;
    return fileName;
}

- (NSString *)xz_directoryPathWithoutFileName {
    return [self stringByDeletingLastPathComponent];
}

- (NSString *)xz_appendingPathComponent:(NSString *)path {
    return [self stringByAppendingPathComponent:path];
}

- (NSString *)xz_appendToDocumentPath {
    NSString *documentPath = [NSString xz_documentDirectory];
    if (![self hasPrefix:documentPath]) {
        return [documentPath xz_appendingPathComponent:self];
    } else {
        return self;
    }
}
- (NSString *)xz_appendToCachesPath {
    NSString *cachesPath = [NSString xz_cachesDirectory];
    if (![self hasPrefix:cachesPath]) {
        return [cachesPath xz_appendingPathComponent:self];
    } else {
        return self;
    }
}
- (NSString *)xz_appendToTempPath {
    NSString *tempPath = [NSString xz_tempDirectory];
    if (![self hasPrefix:tempPath]) {
        return [tempPath xz_appendingPathComponent:self];
    } else {
        return self;
    }
}

- (NSArray<NSString *> *)xz_contentNameList {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self error:nil];
}

@end
