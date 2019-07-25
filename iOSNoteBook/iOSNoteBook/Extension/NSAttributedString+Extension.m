//
//  NSAttributedString+Extension.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

- (CGSize)ext_sizeWithBounding:(CGSize)size {
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin;
    CGRect bounds = [self boundingRectWithSize:size options:options context:nil];
    return CGSizeMake(ceil(bounds.size.width), ceil(bounds.size.height));
}

@end
