//
//  NSArray+Log.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale {
    return self.debugDescription;
}

- (NSString *)debugDescription {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    return strM;
}

@end
