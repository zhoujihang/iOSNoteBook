//
//  NSString+Extension.h
//  XZTenant
//
//  Created by 周际航 on 2017/9/1.
//  Copyright © 2017年 xiaozhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

#pragma mark - 文件系统
+ (NSString *)ext_documentDirectory;
+ (NSString *)ext_cachesDirectory;
+ (NSString *)ext_tempDirectory;

/// 创建文件夹
- (BOOL)ext_createDirectory;

/// 删除文件或文件夹
- (BOOL)ext_removeItem;
/// 文件或文件夹是否存在
- (BOOL)ext_isExistItem;

/// 读取文件内容
- (NSString *)ext_fileContent;
/// 将内容覆盖式写入到指定文件内，需确保文件夹路径存
- (BOOL)ext_writeToFile:(NSString *)path;

/// 去除地址得到最后的文件名
- (NSString *)ext_fileNameWithoutDirectory;
/// 去除文件名得到目录地址
- (NSString *)ext_directoryPathWithoutFileName;

/// 添加地址路径节点，不可做网络url拼接
- (NSString *)ext_appendingPathComponent:(NSString *)path;

/// 将当前内容当作路径扩展到 DocumentPath 后
- (NSString *)ext_appendToDocumentPath;
/// 将当前内容当作路径扩展到 CachesPath 后
- (NSString *)ext_appendToCachesPath;
/// 将当前内容当作路径扩展到 TempPath 后
- (NSString *)ext_appendToTempPath;

/// 返回当前目录下所有文件的名字
- (NSArray<NSString *>*)ext_contentNameList;

#pragma mark - 字符串
/// 计算文本大小
- (CGSize)ext_sizeWithFont:(UIFont *)font boundingSize:(CGSize)size;

- (NSString *)ext_stringByRepeat:(NSInteger)repeat;
- (NSString *)ext_stringByRepeatToLength:(NSInteger)length;

#pragma mark - 精度计算
/// 字符串 转 精度数字
- (NSDecimalNumber *)ext_decimal;
/// 字符串通用性精度计算
- (NSString *)ext_add:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode;
- (NSString *)ext_subtract:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode;
- (NSString *)ext_multiply:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode;
- (NSString *)ext_divide:(NSString *)numberStr precision:(NSInteger)precision roundingMode:(NSRoundingMode)mode;
- (NSString *)ext_roundWithPrecision:(NSInteger)precision roundingMode:(NSRoundingMode)mode;
/// 浮点数大小比较，精度6位小数，四舍五入
- (BOOL)ext_isBiggerThanFloatStr:(NSString *)value;
- (BOOL)ext_isEqualToFloatStr:(NSString *)value;
- (BOOL)ext_isLessThanFloatStr:(NSString *)value;

@end
