//
//  NSString+Extension.m
//  XZTenant
//
//  Created by 周际航 on 2017/9/1.
//  Copyright © 2017年 xiaozhu.com. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

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

- (CGSize)ext_sizeWithFont:(UIFont *)font boundingSize:(CGSize)size {
    if (!font) {return CGSizeZero;}
    CGRect bounds = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return CGSizeMake(ceil(bounds.size.width), ceil(bounds.size.height));
}

- (NSString *)ext_stringByRepeat:(NSInteger)repeat {
    return [self stringByPaddingToLength:self.length*repeat withString:self startingAtIndex:0];
}
- (NSString *)ext_stringByRepeatToLength:(NSInteger)length {
    return [self stringByPaddingToLength:length withString:self startingAtIndex:0];
}

- (NSDecimalNumber *)ext_decimal {
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
    if ([number compare:[NSDecimalNumber notANumber]] == NSOrderedSame) {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    return number;
}
- (NSString *)ext_add:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:numberStr];
    return [number1 decimalNumberByAdding:number2 withBehavior:handler].stringValue;
}
- (NSString *)ext_subtract:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:numberStr];
    return [number1 decimalNumberBySubtracting:number2 withBehavior:handler].stringValue;
}
- (NSString *)ext_multiply:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:numberStr];
    return [number1 decimalNumberByMultiplyingBy:number2 withBehavior:handler].stringValue;
}
- (NSString *)ext_divide:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:numberStr];
    return [number1 decimalNumberByDividingBy:number2 withBehavior:handler].stringValue;
}
- (NSString *)ext_roundWithPrecision:(NSInteger)precision roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self];
    return [number1 decimalNumberByRoundingAccordingToBehavior:handler].stringValue;
}

- (BOOL)ext_isBiggerThanFloatStr:(NSString *)value {
    return [self ext_comparisonResultToFloatNum2:value] == NSOrderedDescending;
}
- (BOOL)ext_isEqualToFloatStr:(NSString *)value {
    return [self ext_comparisonResultToFloatNum2:value] == NSOrderedSame;
}
- (BOOL)ext_isLessThanFloatStr:(NSString *)value {
    return [self ext_comparisonResultToFloatNum2:value] == NSOrderedAscending;
}
/// 精度6位小数，四舍五入
- (NSComparisonResult)ext_comparisonResultToFloatNum2:(NSString *)num2Str {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:6 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *num1 = [self ext_decimal];
    NSDecimalNumber *num2 = [num2Str ext_decimal];
    NSDecimalNumber *substract = [num1 decimalNumberBySubtracting:num2 withBehavior:handler];
    return [substract compare:[NSDecimalNumber zero]];
}

@end
