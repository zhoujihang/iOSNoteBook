//
//  NSURL+Extension.h
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Extension)

/// 将url后面的参数返回成字典格式，不做解码操作
- (NSDictionary *_Nonnull)ext_queryParameters;
/// 将url后面的参数返回成字典格式，并且键值做一次解码操作
- (NSDictionary *_Nonnull)ext_queryParametersDecoded;

@end

NS_ASSUME_NONNULL_END
