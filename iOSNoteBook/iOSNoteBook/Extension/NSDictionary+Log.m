//
//  NSDictionary+Log.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

//打印到控制台时会调用该方法
- (NSString *)descriptionWithLocale:(id)locale{
    return self.debugDescription;
}
//有些时候不走上面的方法，而是走这个方法
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
    return self.debugDescription;
}
//用po打印调试信息时会调用该方法
- (NSString *)debugDescription{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:&error];
    if (error) {return [super debugDescription];}
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
