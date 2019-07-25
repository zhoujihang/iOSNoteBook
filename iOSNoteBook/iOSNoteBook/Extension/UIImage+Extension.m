//
//  UIImage+Extension.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/23.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)ext_resizeImage {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.size.height*0.5, self.size.width*0.5, self.size.height*0.5, self.size.width*0.5);
    return [self ext_resizeImageWithCapInsets:insets];
}
- (UIImage *)ext_resizeImageWithCapInsets:(UIEdgeInsets)insets {
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}
+ (UIImage *)ext_resizeImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    CGSize size = image.size;
    UIEdgeInsets insets = UIEdgeInsetsMake(size.height*0.5, size.width*0.5, size.height*0.5, size.width*0.5);
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}
+ (UIImage *)ext_resizeImageWithName:(NSString *)name capInsets:(UIEdgeInsets)insets {
    UIImage *image = [UIImage imageNamed:name];
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)ext_imageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)ext_imageWithScale:(CGFloat)scale {
    CGFloat width = self.size.width * scale;
    CGFloat height = self.size.height * scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)ext_imageWithView:(UIView *)view {
    if (!view) {return nil;}
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currentContext];
    UIImage  *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)ext_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)ext_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)corner fillColor:(UIColor *)fillColor radiusColor:(UIColor *)radiusColor {
    if (size.width <= 0 || size.height <= 0) {return nil;}
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [fillColor setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
    [radiusColor setFill];
    CGContextAddRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)ext_circleTransparentImageWithDiameter:(CGFloat)diameter radiusColor:(UIColor *)color {
    return [self ext_imageWithSize:CGSizeMake(diameter, diameter) cornerRadius:diameter
                        rectCorner:UIRectCornerAllCorners fillColor:[UIColor clearColor] radiusColor:[UIColor whiteColor]];
}
+ (UIImage *)ext_circleTransparentImageWithDiameter:(CGFloat)diameter {
    return [self ext_imageWithSize:CGSizeMake(diameter, diameter) cornerRadius:diameter rectCorner:UIRectCornerAllCorners fillColor:[UIColor clearColor] radiusColor:[UIColor whiteColor]];
}

+ (UIImage *)ext_gradientImageWithSize:(CGSize)size startColor:(UIColor *)sc endColor:(UIColor *)ec startPoint:(CGPoint)sp endPoint:(CGPoint)ep {
    if (size.width <= 0 || size.height <= 0) { return nil; }
    if (sc == nil || ec == nil) { return nil; }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CFArrayRef colors = (__bridge CFArrayRef)@[(__bridge id)sc.CGColor, (__bridge id)ec.CGColor];
    CGFloat locations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGContextDrawLinearGradient(ctx, gradient, sp, ep, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    return image;
}

- (UIImage *)ext_circleImage {
    CGFloat imageW = self.size.width;
    CGFloat imageH = self.size.height;
    CGFloat diameter = imageW < imageH ? imageW : imageH;// 直径
    CGFloat radius = diameter * 0.5; // 半径
    CGFloat centerX = radius; // 圆心
    CGFloat centerY = radius;
    CGSize imageSize = CGSizeMake(diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    CGRect drawRect = CGRectZero;
    if (imageW > imageH) {
        drawRect = CGRectMake(-(imageW - imageH)*0.5, 0, imageW, imageH);
    } else {
        drawRect = CGRectMake(0, -(imageH - imageW)*0.5, imageW, imageH);
    }
    [self drawInRect:drawRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)ext_ovalImage {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGSize imageSize = CGSizeMake(width, height);
    CGRect imageRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, imageRect);
    CGContextClip(ctx);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
