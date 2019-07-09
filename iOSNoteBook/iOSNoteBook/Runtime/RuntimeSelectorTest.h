//
//  RuntimeTest.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeSelectorTest_BaseClass : NSObject

- (void)baseFunc;

@end

@interface RuntimeSelectorTest_SubClass : RuntimeSelectorTest_BaseClass

- (void)func1;
+ (void)classFunc;

@end

@interface RuntimeSelectorTest_SubClass (Extension)

- (void)ext_baseFunc;
- (void)ext_func1;
+ (void)ext_classFunc;

@end

@interface RuntimeSelectorTest : NSObject

+ (void)test;

@end

NS_ASSUME_NONNULL_END
