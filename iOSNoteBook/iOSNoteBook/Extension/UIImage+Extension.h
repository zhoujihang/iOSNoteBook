//
//  UIImage+Extension.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/23.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

#pragma mark - 图片拉伸
/// 拉伸中心点
- (UIImage *)ext_resizeImage;
- (UIImage *)ext_resizeImageWithCapInsets:(UIEdgeInsets)insets;
+ (UIImage *)ext_resizeImageWithName:(NSString *)name;
+ (UIImage *)ext_resizeImageWithName:(NSString *)name capInsets:(UIEdgeInsets)insets;

- (UIImage *)ext_imageWithScale:(CGFloat)scale;
- (UIImage *)ext_imageWithSize:(CGSize)size;

#pragma mark - 创造图片
+ (UIImage *)ext_imageWithView:(UIView *)view;
+ (UIImage *)ext_imageWithColor:(UIColor *)color;
/// 绘制一张size大小，radius圆角的方形图片，中间部分颜色为 fillColor，圆角部分颜色为radiusColor；可以用来制作圆角遮罩层。
+ (UIImage *)ext_imageWithSize:(CGSize)size cornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)corner fillColor:(UIColor *)fillColor radiusColor:(UIColor *)radiusColor;
+ (UIImage *)ext_circleTransparentImageWithDiameter:(CGFloat)diameter radiusColor:(UIColor *)color;
+ (UIImage *)ext_circleTransparentImageWithDiameter:(CGFloat)diameter;
+ (UIImage *)ext_gradientImageWithSize:(CGSize)size startColor:(UIColor *)sc endColor:(UIColor *)ec startPoint:(CGPoint)sp endPoint:(CGPoint)ep;


#pragma mark - 图片裁剪
/// 裁一个圆形图片 正中间
- (UIImage *)ext_circleImage;
/// 裁一个椭圆图片 
- (UIImage *)ext_ovalImage;

@end

NS_ASSUME_NONNULL_END
