//
//  RuntimeProtocolTest.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/17.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "RuntimeProtocolTest.h"
#import "RuntimeKit.h"
#import "FileListViewController.h"

@implementation RuntimeProtocolTest

+ (void)test {
    [self setup];
    [self printMethodInProtocol];
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
             [[self rootDir] ext_appendingPathComponent:@"sel_ignore_list.txt"]
             ];
}

+ (void)printMethodInProtocol {
    NSString *path = [[self rootDir] ext_appendingPathComponent:@"sel_ignore_list.txt"];
    NSArray *list = @[@protocol(UITableViewDelegate),
                      @protocol(UITableViewDataSource),
                      @protocol(UICollectionViewDelegate),
                      @protocol(UICollectionViewDataSource),
                      @protocol(UIApplicationDelegate),
                      @protocol(UIPickerViewDelegate),
                      ];
    __block NSMutableSet *set = [NSMutableSet set];
    for (Protocol *protocol in list) {
        zjh_enumerateProtocol(protocol, ^(SEL  _Nonnull sel, BOOL isRequiredMethod, BOOL isInstanceMethod) {
            [set addObject:NSStringFromSelector(sel)];
        });
    }
    NSArray *resultList = [[set allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    NSString *str = [resultList componentsJoinedByString:@"\n"];
    [str ext_writeToFile:path];
}

@end
