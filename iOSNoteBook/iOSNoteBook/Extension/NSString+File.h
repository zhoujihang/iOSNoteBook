//
//  NSString+File.h
//  XZTenant
//
//  Created by 周际航 on 2017/9/1.
//  Copyright © 2017年 xiaozhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

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

/// 添加路径节点，当路径中出现 // 时，此方法会将其替换为 单个 ／ 如 http://www.baidu.com 会变为 http:/www.baidu.com 故此方法不可做网络url拼接
- (NSString *)ext_appendingPathComponent:(NSString *)path;

/// 将当前内容当作路径扩展到 DocumentPath 后
- (NSString *)ext_appendToDocumentPath;
/// 将当前内容当作路径扩展到 CachesPath 后
- (NSString *)ext_appendToCachesPath;
/// 将当前内容当作路径扩展到 TempPath 后
- (NSString *)ext_appendToTempPath;

/// 返回当前目录下所有文件的名字
- (NSArray<NSString *>*)ext_contentNameList;

@end
