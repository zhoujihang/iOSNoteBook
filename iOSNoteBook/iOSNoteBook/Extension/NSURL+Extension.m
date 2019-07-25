//
//  NSURL+Extension.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Extension)

- (NSDictionary *)ext_queryParameters {
    if (self.query.length == 0) {return @{};}
    NSArray<NSString *> *kvArray = [self.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *mdic = [@{} mutableCopy];
    for (NSString *kv in kvArray) {
        NSRange range = [kv rangeOfString:@"="];
        if (range.location == NSNotFound || range.length == 0) {continue;}
        NSString *key = [kv substringToIndex:range.location];
        NSString *value = [kv substringFromIndex:(range.location + range.length)];
        if (key.length > 0) {
            mdic[key] = value;
        }
    }
    return [mdic copy];
}

- (NSDictionary *)ext_queryParametersDecoded {
    NSDictionary *dic = [self ext_queryParameters];
    NSMutableDictionary *mdic = [@{} mutableCopy];
    for (NSString *key in dic.allKeys) {
        NSString *value = dic[key];
        NSString *key_decode = [key stringByRemovingPercentEncoding];
        NSString *value_decode = [value stringByRemovingPercentEncoding];
        if (![key_decode isKindOfClass:[NSString class]]) {continue;}
        if (![value_decode isKindOfClass:[NSString class]]) {continue;}
        [mdic setObject:value_decode forKey:key_decode];
    }
    return [mdic copy];
}

@end
