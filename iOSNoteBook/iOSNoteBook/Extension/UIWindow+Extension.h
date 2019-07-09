//
//  UIWindow+Extension.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/9.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (Extension)

+ (UIViewController *)getCurrentRootViewController;
+ (UIViewController *)getActiveController;
+ (UIViewController *)getActiveControllerWithoutPresented;

@end

NS_ASSUME_NONNULL_END
