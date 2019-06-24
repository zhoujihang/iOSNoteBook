//
//  RuntimeTest.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeTestBaseClass : NSObject

- (void)baseFunc;

@end

@interface RuntimeTestSubClass : RuntimeTestBaseClass

- (void)func1;
+ (void)classFunc;

@end

@interface RuntimeTestSubClass (Extension)

- (void)ext_baseFunc;
- (void)ext_func1;
+ (void)ext_classFunc;

@end

@interface RuntimeTest : NSObject

+ (void)test;

@end

NS_ASSUME_NONNULL_END
