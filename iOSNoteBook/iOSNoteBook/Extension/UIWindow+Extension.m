//
//  UIWindow+Extension.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/9.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)

+ (UIWindow *)rootWindow {
    UIWindow *root = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        root = [[UIApplication sharedApplication].delegate window];
    } else {
        root = [[[UIApplication sharedApplication] windows] firstObject];
    }
    return root;
}

+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = nil;
    if ([[topWindow subviews] count]) {
        rootView = [[topWindow subviews] objectAtIndex:0];
    }
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"获取当前控制器错误");
    return result;
}

+ (UIViewController *)getActiveController {
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *normalWindow;
    for (UIWindow *window in windows) {
        if (window.windowLevel == UIWindowLevelNormal && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            normalWindow = window;
        }
    }
    UIViewController *topController = normalWindow.rootViewController;
    while(topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)topController;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return [[(UINavigationController *)tab.selectedViewController viewControllers] lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([topController isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)topController viewControllers] lastObject];
    } else {
        return topController;
    }
}

+ (UIViewController *)getActiveControllerWithoutPresented {
    UIViewController *controller = [self rootWindow].rootViewController;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)controller;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return [[(UINavigationController *)tab.selectedViewController viewControllers] lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([controller isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)controller viewControllers] lastObject];
    } else {
        return controller;
    }
}

@end
